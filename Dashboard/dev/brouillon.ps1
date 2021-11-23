 Get-ADReplicationConnection -Filter * (a mettre dans AD infos)
 Get-Process -ComputerName melinda | Get-Random -Count 10
  -BackgroundColor "#80962F23" -HoverBackgroundColor "#80962F23"
$WDSPrint = Get-printer -ComputerName iemn-printers.iemn.fr | select Name 
ForEach($item in $WDSPrint)
{Get-PrintJob -ComputerName iemn-printers.iemn.fr -PrinterName $item.Name}
Get-WsusServer -Name wsus.iemn.fr -PortNumber 8530 | Select Name
Get-WsusServer -Name wsus.iemn.fr -PortNumber 8530 | Invoke-WsusServerCleanup -CleanupObsoleteComputers -CleanupObsoleteUpdates -CleanupUnneededContentFiles -CompressUpdates -DeclineExpiredUpdates  -DeclineSupersededUpdates 
Get-WsusServer -Name wsus.iemn.fr -PortNumber 8530 | Get-WsusUpdate -Classification All -Approval Unapproved -Status FailedOrNeeded | Approve-WsusUpdate -Action Install -TargetGroupName "All Computers"

Get-StorageJob -StorageSubsystem (Get-StorageSubSystem -FriendlyName "*Storage*") # Santé du disque
Get-VolumeCorruptionCount -DriveLetter C #Disk erreur smart
Get-StorageSubSystem -Model "*Windows Storage*" | Get-StorageHealthSetting

# WDS Trying
# A revoir (30/01/2019)
$password = ConvertTo-SecureString "St4rW4rs*" -AsPlainText -Force
$user = "IEMN\Administrateur"
$cred = New-Object System.Management.Automation.PSCredential ($user,$password)
    $sWDS=new-PSsession -ComputerName $WDS -Authentication Credssp -Credential $cred
New-UdGrid -Title "Images de Boot" -Headers @("Architecture", "Etât", "Langue", "Description") -Properties @("Architecture", "Enabled", "DefaultLanguage", "Description") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Invoke-Command -Session $sWDS -ScriptBlock {Get-WdsBootImage} | Select Architecture,Enabled,DefaultLanguage,Description | Out-UDGridData
}####### fin liste des images de boot
    $sWDS2=new-PSsession -ComputerName $WDS -Credential $cred
New-UdGrid -Title "OS Disponibles" -Headers @("Nom de l'image", "Architecture", "Version", "Langue par défaut", "Date de mise en ligne", "Groupe d'images", "Famille de produit") -Properties @("ImageName", "Architecture", "Version", "DefaultLanguage", "CreationTime", "ImageGroup", "ProductFamily") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Invoke-Command -Session $sWDS2 -ScriptBlock {Get-WdsInstallImage} | Select ImageName,Architecture,Version,DefaultLanguage,CreationTime,ImageGroup,ProductFamily | Out-UDGridData
}####### fin liste des OS installables
    $sWDS3=new-PSsession -ComputerName $WDS -Credential $cred
New-UdGrid -Title "Groupes d'images" -Headers @("Nom du groupe") -Properties @("Name") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Invoke-Command -Session $sWDS3 -ScriptBlock {Get-WdsInstallImageGroup} | Select Name | Out-UDGridData
}####### fin liste des OS installables

# ADs
Get-GPO -Domain iemn.fr -All | foreach-object { if($_ | Get-GPPermission -TargetName "IEMN\Admins du domaine" -TargetType Group -ErrorAction SilentlyContinue) {$_.DisplayName,$_.GpoStatus}}
# Clustering
Get-ClusterGroup -Name sin-city.iemn.fr | Get-ClusterResource
Get-Cluster -Name sin-city.iemn.fr | Format-List -Property *
Get-Cluster -Name sin-city.iemn.fr | Get-ClusterGroup | Get-ClusterResource
Get-VM -ComputerName marv.iemn.fr | where State -EQ "Running" | Select Name,CPUUsage
# kill sessions
query process * | where {$_.UTILISATEUR -notlike "inconnu"} | Format-Table
Get-CimClass -ClassName win32_operatingSystem | Select CimClassMethods -ExpandProperty CimClassMethods
gwmi win32_operatingSystem
qwinsta /server:rds01.iemn.fr
Import-Module PSTerminalServices
Get-TSCurrentSession
Get-ADComputer -Properties Name,OperatingSystem -Filter {OperatingSystem -like "*Server*" -AND Name -notlike "*XenApp-34*"} | Select Name,OperatingSystem 
Import-Module GetServerTSSessions
Get-TSSession
if (Get-PingStatus tux.iemn.fr) { Write-Host "je suis prêt! Lock & Load" } else {Write-Host "loupé faut appuyer sur le bouton power"}
Get-RemoteAccess -ComputerName rds01.iemn.fr
#Sessions
function Get-TSSessions {
    param(
        $ComputerName = "rds01.iemn.fr"
    )

    qwinsta /server:$ComputerName |
    #Parse output
    ForEach-Object {
        $_.Trim() -replace "\s+","," -replace "D‚co","Déco" -replace "11","Actif"
    } |
    #Convert to objects
    ConvertFrom-Csv
}
Get-TSSessions -ComputerName "rds01.iemn.fr" | ft -AutoSize SESSION,UTILISATEUR,ID
#fin sessions
Get-NetAdapter | Where {$_.Name -like "*Ethernet*"} 

$vmconf = Get-VM -ComputerName (Get-ClusterNode -Cluster sin-city.iemn.fr) | select Name 
ForEach($item in $vmconf)
{Get-VMNetworkAdapter -ComputerName (Get-ClusterNode -Cluster sin-city.iemn.fr) -VMName $item.Name |select VMName,SwitchName,MacAddress,IPAddresses}

New-UdGrid -Title “Déploiemenrs récents” -Headers @(“Date”, “Ordinateur”, “Pourcentage”,
“Étape en cours”, “Status”) -Properties @(“Date”, “Computer Name”, “Percent Complete”,
“Step Name”, “Deployment Status”) -AutoRefresh -RefreshInterval 60 -Endpoint { $Alldatas
| Out-UDGridData }  

(Get-Printer -ComputerName cooper.iemn.fr | Where {$_.Name -like "SafeQ*"}).count
(Get-Printer -ComputerName iemn-printers.iemn.fr | Where {$_.Name -like "*SafeQ" -or $_.Name -like "SFC*"}).count
Get-ADUser -Filter * -Properties * | Select Name,AccountExpirationDate | Where {$_.AccountExpirationDate -notlike $null}