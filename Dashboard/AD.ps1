
$sadrodc=new-PSsession -ComputerName $ADRODC
#Set-PSSessionConfiguration -Name Microsoft.PowerShell32 –ShowSecurityDescriptorUI
#Invoke-Command -Session $sadrodc -ScriptBlock {Add-PSSnapin Quest.ActiveRoles.ADManagement;}
New-UdGrid -Title "Utilisateurs AD" -Headers @("Nom d'utilisateur", "UID", "Actif") -Properties @("UserPrincipalName", "SamAccountName", "Enabled") -AutoRefresh -RefreshInterval 600 -Endpoint {
       Invoke-Command -Session $sadrodc -ScriptBlock {Get-ADUser -Filter * -SearchBase "CN=Users,DC=iemn,DC=fr"} | Select UserPrincipalName,SamAccountName,Enabled | Out-UDGridData
}####### fin liste des comptes de users AD
$sadrodc2=new-PSsession -ComputerName $ADRODC
#Set-PSSessionConfiguration -Name Microsoft.PowerShell32 –ShowSecurityDescriptorUI
#Invoke-Command -Session $sadrodc2 -ScriptBlock {Add-PSSnapin Quest.ActiveRoles.ADManagement;}
New-UdGrid -Title "Comptes de services AD" -Headers @("Nom d'utilisateur", "Actif") -Properties @("SamAccountName", "Enabled") -AutoRefresh -RefreshInterval 600 -Endpoint {
       Invoke-Command -Session $sadrodc2 -ScriptBlock {Get-ADServiceAccount  -Filter *} | Select SamAccountName,Enabled | Out-UDGridData
}####### fin liste des comptes de services
$sadrodc3=new-PSsession -ComputerName $ADRODC
#Set-PSSessionConfiguration -Name Microsoft.PowerShell32 –ShowSecurityDescriptorUI
#Invoke-Command -Session $sadrodc3 -ScriptBlock {Add-PSSnapin Quest.ActiveRoles.ADManagement;}
New-UdGrid -Title "Postes clients sous AD" -Headers @("Noms DNS AD", "SamAccountName") -Properties @("DNSHostName", "SamAccountName") -AutoRefresh -RefreshInterval 600 -Endpoint {
       Invoke-Command -Session $sadrodc3 -ScriptBlock {Get-ADComputer  -Filter * -SearchBase "CN=Computers,DC=iemn,DC=fr"} | Select DNSHostName,SamAccountName | Out-UDGridData
}####### fin liste des pc sous AD
$sadrodc4=new-PSsession -ComputerName $ADRODC
#Set-PSSessionConfiguration -Name Microsoft.PowerShell32 –ShowSecurityDescriptorUI
#Invoke-Command -Session $sadrodc -ScriptBlock {Add-PSSnapin Quest.ActiveRoles.ADManagement;}
New-UdGrid -Title "Utilisateurs AD Passwd" -Headers @("Nom d'utilisateur", "Dernière co", "pwd last change", "Filer Profil") -Properties @("Name", "LastLogonDate", "PasswordLastSet", "HomeDrive") -AutoRefresh -RefreshInterval 600 -Endpoint {
       Invoke-Command -Session $sadrodc4 -ScriptBlock {Get-ADUser -Filter * -SearchBase "CN=Users,DC=iemn,DC=fr" -Properties *} | Select Name,LastLogonDate,PasswordLastSet,HomeDrive | Out-UDGridData
}####### fin liste des comptes de users AD
$sadrodc5=new-PSsession -ComputerName $ADRODC
#Set-PSSessionConfiguration -Name Microsoft.PowerShell32 –ShowSecurityDescriptorUI
#Invoke-Command -Session $sadrodc -ScriptBlock {Add-PSSnapin Quest.ActiveRoles.ADManagement;}
New-UdGrid -Title "Bilan Users" -Headers @("Nom d'utilisateur", "Dernière co", "pwd last change", "Filer Profil") -Properties @("Name", "LastLogonDate", "PasswordLastSet", "HomeDrive") -AutoRefresh -RefreshInterval 600 -Endpoint {
       Invoke-Command -Session $sadrodc5 -ScriptBlock {Get-ADUser -Filter * -SearchBase "CN=Users,DC=iemn,DC=fr" -Properties *} | Select Name,LastLogonDate,PasswordLastSet,HomeDrive | Out-UDGridData
}####### fin liste des comptes de users AD    

$sadrodc6=new-PSsession -ComputerName $ADRODC
$users = Invoke-Command -Session $sadrodc6 -ScriptBlock {(Get-ADUser -Filter * | Where-Object ObjectClass -eq "user" ).count}
$users2 = Invoke-Command -Session $sadrodc6 -ScriptBlock {(Get-ADUser -Filter * | Where-Object Enabled -like "False" ).count}
$users3 = Invoke-Command -Session $sadrodc6 -ScriptBlock {(Get-ADUser -Filter * | Where-Object Enabled -like "True" ).count}
New-UDCard -Title "Nombre d'utilisateurs" -Content{
New-UDLayout -Columns 3 -Content {
New-UDCounter -Title "Utilisateurs actifs" -Endpoint {$users3}
New-UDCounter -Title "Utilisateurs inactifs" -Endpoint {$users2}
New-UDCounter -Title "Utilisateurs, total" -Endpoint {$users}
}#fin udlayout
}#fin udcard


$sadrodc7=new-PSsession -ComputerName $ADRODC
$groups3 = Invoke-Command -Session $sadrodc7 -ScriptBlock {Get-ADOrganizationalUnit -Filter *}
$groups2 = Invoke-Command -Session $sadrodc7 -ScriptBlock {Get-ADOrganizationalUnit -Filter * | %{
	$_.DistinguishedName +" : " + (@(Get-ADComputer -Filter * -SearchBase $_.DistinguishedName).count)}}
$groups1 = Invoke-Command -Session $sadrodc7 -ScriptBlock {(Get-ADUser -Filter * | Where-Object Enabled -like "True" ).count}
New-UDCard -Title "Nombre d'utilisateurs" -Content{
New-UDLayout -Columns 3 -Content {
New-UDTextbox -Label "Groupes de sécurité" -value {$groups3 | Select-Object DistinguishedName}
New-UDCounter -Title "Utilisateurs inactifs" -Endpoint {$groups2}
New-UDCounter -Title "Utilisateurs, total" -Endpoint {$groups1}
}#fin udlayout
}#fin udcard
Get-PSSession | Remove-PSSession