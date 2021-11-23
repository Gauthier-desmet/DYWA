<#   
.SYNOPSIS   
   
  Gets servers from Active Directory, check for terminal server sessions and output to HTML with the additional option of email. 
   
.DESCRIPTION   
    
  This script gets a list of all computers running a server OS from AD, gets all TS sessions from each server (minus null user and ICA sessions) and then writes the output to HTML with the option of sending it as an email (off by default).  
   
.COMPATABILITY    
    
  Tested on PS v3/v4 and against servers from 2000 Servers to Server 2008 R2. It should work on 2012 but I haven't tested it. 
     
.EXAMPLE 
  PS C:\> Get_Server_TS_Sessions.ps1 
  All options are set as variables in the GLOBALS section so you simply run the script. 
 
.NOTES   
     
  This script requires the ActiveDirectory and PSTerminalServices modules. The AD module should just need to be imported but you will need to download and install the PSTS module from http://psterminalservices.codeplex.com 
 
  This script also requires the sortable.js script to make the table columns sortable. Download the script and place it in the same directory as $OutputFile. Get it here: http://www.kryogenix.org/code/browser/sorttable 
   
  The account running the script or scheduled task obviously must have the appropriate permissions on each server.  
   
  NAME:       Get_Server_TS_Sessions.ps1   
   
  AUTHOR:     Brian D. Arnold   
   
  CREATED:    10/28/13   
   
  LASTEDIT:   06/05/2014  
#>   

################### 
#### FUNCTIONS #### 
################### 

<#

.SYNOPSIS

  This function will help you to test if a computer is pingable.

.DESCRIPTION

  This function will help you to test if a computer is pingable.

.PARAMETER  Computer

  The name or IP address of the computer

.EXAMPLE

  PS C:\> Get-PingStatus server01
  True

.EXAMPLE

  PS C:\> if (Get-PingStatus server01) { Write-Host "I'm up!" }

.EXAMPLE

  PS C:\> if (!(Get-PingStatus server01)) { Write-Host "I'm not up!" }

.OUTPUTS

  True or False.

 .NOTES

  NAME:       Get-PingStatus

  AUTHOR:     Fredrik Wall, fredrik@poweradmin.se

  BLOG:  poweradmin.se/blog

  TWITTER: walle75

  CREATED: 21/07/2009

  LASTEDIT:   30/05/13

     Changed Variable names and Parameter header.

#>
function Get-PingStatus
{
    [cmdletbinding()]
    param(
        [parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
        [Alias('Name','IP','IPAddress')]
       [string]$Computer
    )

    $PingStatus = Get-WmiObject -Query "SELECT StatusCode FROM win32_PingStatus WHERE ADDRESS = '$Computer'"

    if ($PingStatus.StatusCode -eq 0) {
        $true
    }
    else
    {
        $false
    }
} # END Get-PingStatus 

################### 
##### GLOBALS ##### 
################### 
 
# Change the keyword to an OS search term such as Server
$Filter = 'OperatingSystem -like "*Server*"'
# get all computers from Active Directory matching the defined keword
# $ServerList = Get-ADComputer -Properties Name -Filter $Filter | Select Name | Sort-Object -Property Name
$ServerList = Get-ADComputer -Properties Name -Filter $Filter | Select Name | Sort-Object -Property Name
$OutputFile = "E:\inetpub\wwwroot\tssessions.contoso.com\default.htm" 
 
# Get domain name, date and time for report title 
$DomainName = (Get-ADDomain).NetBIOSName  
$Time = Get-Date -Format t 
$CurrDate = Get-Date -UFormat "%D" 

# Info for footer
$ServerTotal = ($ServerList).count

# Option to create transcript - change to $true to turn on.
$CreateTranscript = $false

# Option to send email - change to $true to turn on 
$SendEmail = $false
 
# SMTP Settings  
$smtpServer = "smtp.contoso.com" 
$smtpFrom = "ts_sessions@contoso.com" 
$smtpTo = "user@contoso.com" 
$messageSubject = "$DomainName TS Sessions" 

###############
##### PRE #####
###############

# Start Transcript if $CreateTranscript variable above is set to $true.
if($CreateTranscript)
{
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
if( -not (Test-Path ($scriptDir + "\Transcripts"))){New-Item -ItemType Directory -Path ($scriptDir + "\Transcripts")}
Start-Transcript -Path ($scriptDir + "\Transcripts\{0:yyyyMMdd}_Log.txt"  -f $(get-date)) -Append
}
 
# Import modules - AD and PSTS which contains Get-TSSession 
Import-Module ActiveDirectory 
Import-Module PSTerminalServices 

################ 
##### MAIN ##### 
################ 

$HTML = '<style type="text/css"> 
#TSHead body {font: normal small sans-serif;}
#TSHead table {border-collapse: collapse; width: 100%; background-color:#F5F5F5;}
#TSHead th {font: normal small sans-serif;text-align:left;padding-top:5px;padding-bottom:4px;background-color:#7FB1B3;}
#TSHead th, td {font: normal small sans-serif; padding: 0.25rem;text-align: left;border: 1px solid #FFFFFF;}
#TSHead tbody tr:nth-child(odd) {background: #D3D3D3;}
    </Style>' 

# Report Header
$Header = "<H2 align=center><font face=Arial>$DomainName Terminal Server Sessions as of $Time on $CurrDate</font></H2>" 
# Report Footer
$Footer = "<H4 align=center><font face=Arial>$ServerTotal servers were returned from Active Directory based on the filter: $Filter.</font></H4>"
 
$HTML += "<HTML><BODY><script src=sorttable.js></script><Table border=1 cellpadding=0 cellspacing=0 width=100% id=TSHead class=sortable>
        <TR> 
            <TH><B>Server</B></TH> 
            <TH><B>User Name</B></TH> 
            <TH><B>Client Name</B></TD> 
            <TH><B>Client IP</B></TH> 
            <TH><B>Session State</B></TH> 
            <TH><B>Session Name</B></TH> 
            <TH><B>Login Time</B></TH> 
            <TH><B>Last Input Time</B></TH>
        </TR>
        " 
 
ForEach ($ServerName in $ServerList.Name) 
{
If (Get-PingStatus $ServerName)
    {
    Try{
    $TSSessions = Get-TSSession -ComputerName $ServerName -ErrorAction SilentlyContinue | Select UserAccount,ClientName,ClientIPAddress,State,WindowStationName,LastInputTime,LoginTime
    }
    Catch{
    }
    }
# Sessions where the username is blank and ICA (Citrix) sessions are excluded from the results 
# To see every session, change the line below to ForEach($Session in $TSSessions) 
# To include ICA sessions, change it to ForEach($Session in ($TSSessions | WHERE {$_.UserAccount -ne $null})) 
ForEach($Session in ($TSSessions | WHERE {$_.UserAccount -ne $null -AND $_.WindowStationName -notlike "*ICA*"})) 
    {         
                $HTML += "<TR> 
                    <TD>$($ServerName)</TD>
                    <TD>$($Session.UserAccount.ToString().ToUpper())</TD>  
                    <TD>$($Session.ClientName)</TD> 
                    <TD>$(($Session.ClientIPAddress).IPAddressToString)</TD> 
                    <TD>$($Session.State)</TD> 
                    <TD>$($Session.WindowStationName)</TD> 
                    <TD>$($Session.LoginTime)</TD> 
                    <TD>$($Session.LastInputTime)</TD> 
                </TR>" 
    }
} 
 
$HTML += "<H2></Table></BODY></HTML>" 
$Header + $HTML + $Footer | Out-File $OutputFile 
 
# Send email if $SendEmail variable above is set to $true 
if($SendEmail) 
{ 
$message = New-Object System.Net.Mail.MailMessage $smtpfrom, $smtpto 
$message.Subject = $messageSubject 
$message.IsBodyHTML = $true 
 
$message.Body = $OutputFile | ConvertTo-HTML -Head $HTML 
 
$smtp = New-Object Net.Mail.SmtpClient($smtpServer) 
$smtp.Send($message)   
} 