# nom des machines
$ActiveDirectoryMaster = "melinda.iemn.fr" # Active Directory Master
$ADRODC ="logan.iemn.fr" # Active Directory en Read Only
$ADSlave = "cooper.iemn.fr"
# Params UD
Import-Module UniversalDashboard
$nom_organisation = "IEMN"
$Theme = New-UDTheme -Name "Basic" -Definition @{
  UDDashboard = @{
      BackgroundColor = "black"
      FontColor = "rgb(0, 0, 0)"
  }
}
$Link = New-UDLink -Text 'de Smet Gauthier' -Url 'https://desmet-gauthier.fr'
$Footer = New-UDFooter -Copyright 'IEMN - CNRS UMR 8520' -Links $Link
# Pages
$page_Accueil = New-UDPage -Name "Accueil" -Icon home -Content{
#New-UDImage -Height 1024 -Width 1280 -Path ".\infrawin.png"
New-UDCard -Title "Liens DEV utiles" -Content{
New-UDParagraph -Content{
New-UDLink -Text "module Git AD" -Url "https://github.com/pldmgg/PUDAdminCenterPrototype"
}# fin ud paragraph
New-UDParagraph -Content{
New-UDLink -Text "DashBoard MarketPlace" -Url "https://marketplace.universaldashboard.io/Dashboard/"
}# fin ud paragraph
}# fin udcard1
New-UDCard -Title "Les Services Web Windows" -Content{
New-UDParagraph -Content{
New-UDLink -Text "LCIRemote" -Url "https://lci-remote.iemn.fr" -Icon desktop
}#fin udparagraph Remote Control
New-UDParagraph -Content{
New-UDLink -Text "Remote Desktop Applications" -Url "https://rds01.iemn.fr/RDWeb/" -Icon desktop
}#fin udparagraph rds01
New-UDParagraph -Content{
New-UDLink -Text "iOSBackup" -Url "https://ares.iemn.fr:55414" -Icon save
}#fin udparagraph iOSBackup
New-UDParagraph -Content{
New-UDLink -Text "Authorité de certification" -Url "https://winvirt.iemn.fr/certsrv" -Icon certificate
}#fin udparagraph winvirt
New-UDParagraph -Content{
New-UDLink -Text "Kaspersky Server" -Url "https://kasc.iemn.fr" -Icon _lock
}#fin udparagraph kasc
New-UDParagraph -Content{
New-UDLink -Text "Ysoft SafeQ Server" -Url "http://safeq.iemn.fr" -Icon print
}#fin udparagraph safeq
}#fin udcard 
}#fin page Accueil
$page_infoADmonitor = New-UDPage -Name "Active Directories Infos" -Icon address_book -Content {
$sadrodc5=new-PSsession -ComputerName $ADRODC
New-UdGrid -Title "Forêt IEMN" -Headers @("Maître du domaine", "Niveau Fonctionnel", "Catalogue global", "Domaines") -Properties @("DomainNamingMaster", "ForestMode", "GlobalCatalogs", "Domains") -AutoRefresh -RefreshInterval 600 -Endpoint {
       Invoke-Command -Session $sadrodc5 -ScriptBlock {Get-ADForest} | Select DomainNamingMaster,ForestMode,GlobalCatalogs,Domains | Out-UDGridData
}####### fin liste des comptes de Forêt AD
$sadrodc6=new-PSsession -ComputerName $ADRODC
$users = Invoke-Command -Session $sadrodc6 -ScriptBlock {(Get-ADUser -Filter * | Where-Object ObjectClass -eq "user" ).count}
$users2 = Invoke-Command -Session $sadrodc6 -ScriptBlock {(Get-ADUser -Filter * | Where-Object Enabled -like "False" ).count}
$users3 = Invoke-Command -Session $sadrodc6 -ScriptBlock {(Get-ADUser -Filter * | Where-Object Enabled -like "True" ).count}
New-UDCard -Title "Infos Utilisateurs" -Content{
New-UDLayout -Columns 3 -Content {
New-UDCounter -Title "Utilisateurs actifs" -Endpoint {$users3}
New-UDCounter -Title "Utilisateurs inactifs" -Endpoint {$users2}
New-UDCounter -Title "Utilisateurs, total" -Endpoint {$users}
}
}#fin infos users
$sadrodc=new-PSsession -ComputerName $ADRODC
New-UdGrid -Title "Utilisateurs" -Headers @("Nom d'utilisateur", "UID", "Actif") -Properties @("UserPrincipalName", "SamAccountName", "Enabled") -AutoRefresh -RefreshInterval 600 -Endpoint {
       Invoke-Command -Session $sadrodc -ScriptBlock {Get-ADUser -Filter * -SearchBase "CN=Users,DC=iemn,DC=fr"} | Select UserPrincipalName,SamAccountName,Enabled | Out-UDGridData
}####### fin liste des comptes de users AD
$sadrodc2=new-PSsession -ComputerName $ADRODC
New-UdGrid -Title "Comptes de services" -Headers @("Nom d'utilisateur", "Actif") -Properties @("SamAccountName", "Enabled") -AutoRefresh -RefreshInterval 600 -Endpoint {
       Invoke-Command -Session $sadrodc2 -ScriptBlock {Get-ADServiceAccount  -Filter *} | Select SamAccountName,Enabled | Out-UDGridData
}####### fin liste des comptes de services
$sadrodc4=new-PSsession -ComputerName $ADRODC
New-UdGrid -Title "Information Mot de passe et Filers_Profiles" -Headers @("Nom d'utilisateur", "Dernière connexion", "Dernier Changement de Passwd", "Filer Profil") -Properties @("Name", "LastLogonDate", "PasswordLastSet", "HomeDrive") -AutoRefresh -RefreshInterval 600 -Endpoint {
       Invoke-Command -Session $sadrodc4 -ScriptBlock {Get-ADUser -Filter * -SearchBase "CN=Users,DC=iemn,DC=fr" -Properties *} | Select Name,LastLogonDate,PasswordLastSet,HomeDrive | Out-UDGridData
}####### fin liste des comptes de users AD
$sadrodc3=new-PSsession -ComputerName $ADRODC
New-UdGrid -Title "Postes clients sous AD" -Headers @("Noms DNS AD", "SamAccountName") -Properties @("DNSHostName", "SamAccountName") -AutoRefresh -RefreshInterval 600 -Endpoint {
       Invoke-Command -Session $sadrodc3 -ScriptBlock {Get-ADComputer  -Filter * -SearchBase "CN=Computers,DC=iemn,DC=fr"} | Select DNSHostName,SamAccountName | Out-UDGridData
}####### fin liste des pc sous AD
$sadrodc7=new-PSsession -ComputerName $ADRODC
$groups3 = Invoke-Command -Session $sadrodc7 -ScriptBlock {Get-ADOrganizationalUnit -Filter * -Properties *}
$groups2 = Invoke-Command -Session $sadrodc7 -ScriptBlock {Get-ADGroup -Filter *}
$groups1 = Invoke-Command -Session $sadrodc7 -ScriptBlock {(Get-ADGroup -Filter * | Where-Object ObjectClass -like "group" ).count}
New-UDCard -Title "Infos Groupes" -Content{
New-UDLayout -Columns 3 -Content {
New-UdGrid -Title "liste des groupes d'organisation" -Headers @("UO", "Type") -Properties @("CanonicalName", "DistinguishedName") -AutoRefresh -RefreshInterval 600 -Endpoint {
       $groups3 | Select CanonicalName,DistinguishedName | Out-UDGridData}
New-UdGrid -Title "liste des groupes" -Headers @("Nom du groupe", "Type") -Properties @("SamAccountName", "GroupCategory") -AutoRefresh -RefreshInterval 600 -Endpoint {
       $groups2 | Select SamAccountName,GroupCategory | Out-UDGridData}
New-UDCard -Title "Nombre total de groupes" -Content{
New-UDParagraph -Content {$groups1}
}
}#fin udlayout
}#fin groups
}# fin page ad infos
$iemn_dashboard = New-UDDashboard -Title "$titre" -NavBarColor '#333' -Footer $Footer -Pages @($page_Accueil, $page_infoADmonitor)
Start-UDDashboard -Port 8081 -Dashboard $iemn_dashboard -AutoReload # Je lance la tâche sur le port 8080 avec le nom de variable ci-dessus avec l'option d'actualisation des datas.