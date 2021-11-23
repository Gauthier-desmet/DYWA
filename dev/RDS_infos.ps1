Get-PSSession | Remove-PSSession
# nom des machines
$rds = "rds01.iemn.fr"
# Params UD
Import-Module UniversalDashboard
Import-module RemoteDesktop
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
$page_infoRDSmonitor = New-UDPage -Name "Remote Desktop Infos" -Icon desktop -Content {
New-UdGrid -BackgroundColor '#333' -FontColor '#fff' -Title "Serveurs RDS" -Headers @("Nom du serveur") -Properties @("Server") -AutoRefresh -RefreshInterval 600 -Endpoint {
       Get-RDServer -ConnectionBroker $rds | Select Server | Out-UDGridData
}####### fin liste des serveurs applications
New-UDLayout -Columns 2 -Content{
New-UdGrid -BackgroundColor '#333' -Title "Applications RDS" -FontColor '#fff' -Headers @("Nom du serveur", "Dossier") -Properties @("DisplayName", "FilePath") -AutoRefresh -RefreshInterval 600 -Endpoint {
       Get-RDRemoteApp -ConnectionBroker $rds -CollectionName "IEMN" | Select DisplayName,FilePath | Out-UDGridData
}####### fin liste des serveurs applications
New-UdGrid -BackgroundColor '#333' -Title "Utilisateurs connectés" -FontColor '#fff' -Headers @("Nom de l'utilisateur", "Nom du Serveur Hôte") -Properties @("UserName", "HostServer") -AutoRefresh -RefreshInterval 600 -Endpoint {
       Get-RDUserSession -ConnectionBroker $rds | Select UserName,HostServer | Out-UDGridData
}####### fin liste des connexions
New-UdGrid -BackgroundColor '#333' -Title "Certificats" -FontColor '#fff' -Headers @("Rôle", "Etât", "Expire le") -Properties @("Role", "Level", "ExpiresOn") -AutoRefresh -RefreshInterval 600 -Endpoint {
       Get-RDCertificate -ConnectionBroker $rds | Select Role,Level,ExpiresOn | Out-UDGridData
}####### fin liste des serveurs applications
}#fin udlayout
}#fin page

$iemn_dashboard = New-UDDashboard -Title "$titre" -NavBarColor '#333' -BackgroundColor '#333' -Footer $Footer -Pages @($page_Accueil, $page_infoRDSmonitor)
Start-UDDashboard -Port 8081 -Dashboard $iemn_dashboard -AutoReload # Je lance la tâche sur le port 8080 avec le nom de variable ci-dessus avec l'option d'actualisation des datas.