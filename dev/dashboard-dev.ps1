# nom des machines
$monitor = "Cerberus" # Nom de l'hote powershell$monitor = "Cerberus" # Nom de l'hote powershell
$ActiveDirectoryMaster = "melinda" # Active Directory Master
$ADRODC ="logan.iemn.fr" # Active Directory en Read Only
$ADSlave = "cooper.iemn.fr"
$CA = "winvirt.iemn.fr" # Authorité de certification
$Node1 = "sin.iemn.fr" # Hyper-V Node 1
$Node2 = "city.iemn.fr" # Hyper-V Node 2
$Node3 = "marv.iemn.fr" # Hyper-V Node 3
$Hyperviseur = "sin-city.iemn.fr"#Hyperviseur
$WDS = "tux.iemn.fr" # WDS
$WSUS = "wsus.iemn.fr" #WSUS
$intranet = "sharepoint.iemn.fr" # ShrePoint
$rds = "rds01.iemn.fr"#Remote Desktop Server
$WPS = "iemn-printers.iemn.fr" # PXE 
$Ysoft = "safeq.iemn.fr" #Serveur d'impression
$wapt = "wapt.iemn.fr" #wapt
$kaspersky = "kasc.iemn.fr" # Serveur KES
$urbackup = "ares.iemn.fr" # serveur urbackup
function Get-TSSessions {
    param(
        $ComputerName = "localhost"
    )

    qwinsta /server:$ComputerName |
    #Parse output
    ForEach-Object {
        $_.Trim() -replace "\s+","," -replace "D‚co","Déco" -replace "11","Actif"
    } |
    #Convert to objects
    ConvertFrom-Csv
}
# Params UD
# modules
Import-Module UniversalDashboard
#colors
$css = "style.css"
#font
$fontcolor = '#FFF'
# fond
$wallcolor = '#333'
$bgcolor = '#333'
#Dash
$titre = "GYOWM - Get Your Own Windows Manager"
$nom_organisation = "IEMN"
$Theme = New-UDTheme -Name "Basic" -Definition @{
  UDDashboard = @{
      backgroundColor = "rgb(51,51,51)" 
      FontColor = "rgb(255,255,255)"
  }
  UDCard = @{
      backgroundColor = "rgb(51,51,51)" 
      FontColor = "rgb(255,255,255)"
  }
  UDPage = @{
      backgroundColor = "rgb(51,51,51)" 
      FontColor = "rgb(255,255,255)"
  }
  UDGrid = @{
      backgroundColor = "rgb(51,51,51)" 
      FontColor = "rgb(255,255,255)"
  }
  UDCollapsible = @{
      backgroundColor = "rgb(51,51,51)" 
      FontColor = "rgb(255,255,255)"
  }
  UDCollapsibleItem = @{
      backgroundColor = "rgb(51,51,51)" 
      FontColor = "rgb(255,255,255)"
  }
  UDChart = @{
      backgroundColor = "rgb(51,51,51)" 
      FontColor = "rgb(255,255,255)"
      ChartBackgroundColor = "rgb(100,149,237)"
      ChartBorderColor = "rgb(204,204,204)"
  }
  UDCounter = @{
      backgroundColor = "rgb(51,51,51)" 
      FontColor = "rgb(255,255,255)"
  }
  UDParagraph = @{ 
      backgroundColor = "rgb(51,51,51)" 
      FontColor = "rgb(255,255,255)"
  }
  UDTextbox = @{
      FontColor = "rgb(255,255,255)"
      color = "rgb(255,255,255)" 
  }
  UDMonitor = @{
      backgroundColor = "rgb(51,51,51)" 
      FontColor = "rgba(255,255,255,0)"
  }
  UDButton = @{
      backgroundColor = "rgb(51,51,51)" 
      FontColor = "rgba(255,255,255,0)"
  }
  '.btn, .btn-large' = @{
      background = 'cornflowerblue'
  }
  '.btn:hover, .btn-large:hover' = @{
      background = '#ccc'
      color = '#333'
  }
}
$Link = New-UDLink -Text 'de Smet Gauthier' -Url 'https://desmet-gauthier.fr'
$Footer = New-UDFooter -Copyright 'IEMN - CNRS UMR 8520' -Links $Link
$date = Get-Date -format "dd/MM/yyyy HH:mm:ss"
# Pages
$page_Accueil = New-UDPage -Name "Accueil" -Icon home -AutoRefresh $true -RefreshInterval 60 -Content{
New-UDCard -Title "Date et Heure Forêt IEMN" -Content {
    New-UDParagraph -Text "$date" -Color "#fff"
    New-UdGrid -Title "Liste des Serveurs Windows (hors VM's O.S client, thor, ares, ...)" -Headers @("Nom", "O.S") -Properties @("Name", "OperatingSystem") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-ADComputer -Properties Name,OperatingSystem -Filter {OperatingSystem -like "*Server*" -AND Name -notlike "*XenApp-34*"} | Select Name,OperatingSystem  | Out-UDGridData
}####### fin udgrid
}#fin udCard
New-UDCard -BackgroundColor $wallcolor -FontColor $fontcolor -Title "Liens DEV utiles" -Content{
New-UDParagraph -Content{
New-UDLink -Text "Sur le domaine IEMN.FR, le ntp retourne la date suivante: $date" -Url "#"}
New-UDParagraph -Content{
New-UDLink -Text "module Git AD" -Url "https://github.com/pldmgg/PUDAdminCenterPrototype"
}# fin ud paragraph
New-UDParagraph -Content{
New-UDLink -Text "DashBoard MarketPlace" -Url "https://marketplace.universaldashboard.io/Dashboard/"
}# fin ud paragraph
}# fin udcard1
New-UDCard -BackgroundColor $wallcolor -FontColor $fontcolor -Title "Les Services Web Windows" -Content{
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
$page_status = New-UDPage -Name "Up or Down" -Icon battery -AutoRefresh $true -RefreshInterval 30 -Content {
    $listeserv = Get-ADComputer -Properties Name -Filter {OperatingSystem -like "*Server*" -AND Name -notlike "*XenApp-34*"} | Select Name
    Foreach($item in $listeserv){if (Get-PingStatus $item.name) {New-UDParagraph -Color "#fff" -Text "$item je suis prêt! Lock & Load" } else {New-UDParagraph -Text "$item loupé faut appuyer sur le bouton power"}}
} # fin page ping
$page_ActiveDirectory =New-UDPage -Name "Active Directories Perfs" -Icon address_book -AutoRefresh $true -RefreshInterval 60 -Content{
New-UDCard -Title "Date et Heure Active Directory IEMN" -Text "$date"
New-UDCollapsible -BackgroundColor "#333" -FontColor "#FFF" -Items {  
 New-UDCollapsible -Items  {
  New-UDCollapsibleItem -BackgroundColor "#333" -FontColor "#FFF" -Title "Active Directory Master ($ActiveDirectoryMaster)" -Icon vcard -Content {
   New-UDLayout -Columns 2 -Content { 
    New-UdMonitor -Title "CPU (% du temps processeur)" -Type Line -DataPointHistory 20 -RefreshInterval 5 -ChartBackgroundColor 'cornflowerblue' -ChartBorderColor 'white' -FontColor "#88FFFFFF"  -Endpoint {
     Get-Counter '\processeur(_total)\% temps processeur' -ComputerName $ActiveDirectoryMaster -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
}### utilisation cpu
    New-UdMonitor -Title "Mémoire (% mémoire utilisée)" -Type Line -DataPointHistory 20 -RefreshInterval 5  -ChartBackgroundColor 'cornflowerblue' -ChartBorderColor 'white' -FontColor "#88FFFFFF" -Endpoint {
     Get-Counter "\mémoire\pourcentage d’octets dédiés utilisés" -ComputerName $ActiveDirectoryMaster -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
}### accès memoire
    New-UdMonitor -Title "Disque(s) (% activité du disque)" -Type Line -DataPointHistory 20 -RefreshInterval 5 -ChartBackgroundColor 'cornflowerblue' -ChartBorderColor 'white' -FontColor "#88FFFFFF"  -Endpoint {
     Get-Counter "\disque physique(_total)\pourcentage du temps disque" -ComputerName $ActiveDirectoryMaster -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
} # activité du disque 
    New-UdMonitor -Title "Ethernet (Mo/s)" -Type Line -DataPointHistory 20 -RefreshInterval 5 -ChartBackgroundColor 'cornflowerblue' -ChartBorderColor 'white' -FontColor "#88FFFFFF"  -Endpoint {
     Get-Counter '\IPv4\Datagrammes reçus/s' -ComputerName $ActiveDirectoryMaster -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
}### utilisation Lan
    New-UDChart -Title "Poids par Processus" -Type Doughnut -RefreshInterval 5 -Endpoint {  
    Get-Process -ComputerName $ActiveDirectoryMaster | ForEach-Object { [PSCustomObject]@{ Name = $_.Name; Threads = $_.Threads.Count } } | Out-UDChartData -DataProperty "Threads" -LabelProperty "Name"  
} -Options @{  
     legend = @{  
         display = $false  
     }  
   }# Threads par procéssus
    New-UdChart -Title "Espace disques" -Type Bar -AutoRefresh -Endpoint {
   Get-CimInstance -ClassName Win32_LogicalDisk -ComputerName $ActiveDirectoryMaster | ForEach-Object {
          [PSCustomObject]@{ DeviceId = $_.DeviceID;
                        Size = [Math]::Round($_.Size / 1GB, 2);
                        FreeSpace = [Math]::Round($_.FreeSpace / 1GB, 2); } } | Out-UDChartData -LabelProperty "DeviceID" -Dataset @(
       New-UdChartDataset -DataProperty "Size" -Label "Taille" -BackgroundColor "cornflowerblue" -HoverBackgroundColor "cornflowerblue"
       New-UdChartDataset -DataProperty "FreeSpace" -Label "Espace Libre" -BackgroundColor "lightgreen" -HoverBackgroundColor "lightgreen"
   )
} ###### fin charts espace disque 
    New-UdChart -Title "TOP 10 Consommateurs de mémoire" -Type Bar -RefreshInterval 5 -Endpoint {
      Get-Process -ComputerName $ActiveDirectoryMaster | Get-Random -Count 10 |  Out-UDChartData -LabelProperty "Name" -Dataset @(
           $ds1 = New-UdChartDataset -DataProperty "VirtualMemorySize" -Label "Conso" -BackgroundColor "#806495ed" -HoverBackgroundColor "#80FFFFFF" -HoverBorderColor "#80FFFFFF" -BorderColor "#80FFFFFF"
           $ds1.type = 'line'
           $ds2 = New-UdChartDataset -DataProperty "PeakVirtualMemorySize" -Label "Pics" -BackgroundColor "#80333333" -HoverBackgroundColor "#80333333" -HoverBorderColor "#80FFFFFF"-BorderColor "#FFFFFF"
           $ds2.type = 'line'
          # $ds1
           $ds2
       )
}###### fin consommation mémoire
    New-UdChart -Title "Nombre de séssions connectées." -Type Bar -AutoRefresh -Endpoint {
  Get-CimInstance -ClassName Win32_PerfFormattedData_LocalSessionManager_TerminalServices -ComputerName $ActiveDirectoryMaster | Out-UDChartData -LabelProperty "PSComputerName" -Dataset @(
       New-UdChartDataset -DataProperty "ActiveSessions" -Label "Actives." -BackgroundColor "lightgreen" -HoverBackgroundColor "lightgreen"
       New-UdChartDataset -DataProperty "InactiveSessions" -Label "Inactives." -BackgroundColor "#ec7331" -HoverBackgroundColor "#ec7331"
   )
} -Options @{
    scales = @{
        xAxes = @(
            @{
                stacked = $true
            }
        )
        yAxes = @(
            @{
                stacked = $true
            }
        )
    }
}###### fin charts séssions
    New-UdGrid -Title "Applis en cours" -Headers @("Nom", "I/O Ko.") -Properties @("Name", "WS") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-Process -ComputerName $ActiveDirectoryMaster | Select Name,WS | Out-UDGridData
}####### fin applis en cours
    New-UdGrid -Title "Services en cours" -Headers @("Nom", "Description") -Properties @("Name", "DisplayName") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-Service -ComputerName $ActiveDirectoryMaster | Where-Object {$_.Status -eq "Running"} | Select Name,DisplayName | Out-UDGridData
}####### fin services
    New-UdGrid -Title "Dernières séssions connectées" -Headers @("Date", "Nom") -Properties @("TimeCreated", "Message") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-WinEvent  -ComputerName $ActiveDirectoryMaster -FilterHashTable @{ LogName = "Microsoft-Windows-TerminalServices-LocalSessionManager/Operational"; ID = 21,25 } -MaxEvents 3 | Select-Object -Property "TimeCreated","Message" -ExpandProperty message | Out-UDGridData
}####### fin séssions connectées
    New-UdGrid -Title "Historique des mises à jour" -Headers @("Date", "Nom") -Properties @("TimeCreated", "Message") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-WinEvent -ComputerName $ActiveDirectoryMaster -FilterHashTable @{ LogName = "System"; ID = 43 } -MaxEvents 6 | Select-Object -Property "TimeCreated","Message" -ExpandProperty message | Out-UDGridData
}####### fin events maj
   
   }####### fin udlayout
  }
 }### fin AD Master
 New-UDCard -Content{
    New-UdGrid -Title "Information(s) Réseau" -Headers @("IP", "Adresse Mac", "Nom DNS", "Ordre DNS") -Properties @("IPAddress", "MACAddress", "DNSHostName", "DNSServerSearchOrder") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-CimInstance -ClassName Win32_NetworkAdapterConfiguration -Filter "IPEnabled='True'" -ComputerName $ActiveDirectoryMaster -Property * | Select-Object -Property IPAddress,MACAddress,DNSHostName,DNSServerSearchOrder | Out-UDGridData
       }####### fin applis en cours
 } #fin ip/mac
 New-UDCollapsible -Items {
  New-UDCollapsibleItem -BackgroundColor "#333" -FontColor "#FFF" -Title "Active Directory RODC ($ADRODC)" -Icon vcard -Content {
   New-UDLayout -Columns 2 -Content { 
    New-UdMonitor -Title "CPU (% processor time)" -Type Line -DataPointHistory 20 -RefreshInterval 5 -ChartBackgroundColor 'cornflowerblue' -ChartBorderColor 'white' -FontColor "#88FFFFFF"  -Endpoint {
     Get-Counter '\processeur(_total)\% temps processeur' -ComputerName $ADRODC -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
}### utilisation cpu
    New-UdMonitor -Title "Mémoire (% mémoire utilisée)" -Type Line -DataPointHistory 20 -RefreshInterval 5  -ChartBackgroundColor 'cornflowerblue' -ChartBorderColor 'white' -FontColor "#88FFFFFF" -Endpoint {
     Get-Counter "\mémoire\pourcentage d’octets dédiés utilisés" -ComputerName $ADRODC -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
}### accès memoire
    New-UdMonitor -Title "Disque(s) (% activité du disque)" -Type Line -DataPointHistory 20 -RefreshInterval 5 -ChartBackgroundColor 'cornflowerblue' -ChartBorderColor 'white' -FontColor "#88FFFFFF"  -Endpoint {
     Get-Counter "\disque physique(_total)\pourcentage du temps disque" -ComputerName $ADRODC -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
} # activité du disque
    New-UDChart -Title "Poids par Processus" -Type Doughnut -RefreshInterval 5 -Endpoint {  
    Get-Process -ComputerName $ADRODC | ForEach-Object { [PSCustomObject]@{ Name = $_.Name; Threads = $_.Threads.Count } } | Out-UDChartData -DataProperty "Threads" -LabelProperty "Name"  
} -Options @{  
     legend = @{  
         display = $false  
     }  
   }# Threads par procéssus
    New-UdChart -Title "Espace disques" -Type Bar -AutoRefresh -Endpoint {
   Get-CimInstance -ClassName Win32_LogicalDisk -ComputerName $ADRODC | ForEach-Object {
          [PSCustomObject]@{ DeviceId = $_.DeviceID;
                        Size = [Math]::Round($_.Size / 1GB, 2);
                        FreeSpace = [Math]::Round($_.FreeSpace / 1GB, 2); } } | Out-UDChartData -LabelProperty "DeviceID" -Dataset @(
       New-UdChartDataset -DataProperty "Size" -Label "Taille" -BackgroundColor "cornflowerblue" -HoverBackgroundColor "cornflowerblue"
       New-UdChartDataset -DataProperty "FreeSpace" -Label "Espace Libre" -BackgroundColor "lightgreen" -HoverBackgroundColor "lightgreen"
   )
} ###### fin charts espace disque 
    New-UdChart -Title "Consommateurs de mémoire" -Type Bar -Endpoint {
      Get-Process -ComputerName $ADRODC | Get-Random -Count 10 |  Out-UDChartData -LabelProperty "Name" -Dataset @(
           $ds1 = New-UdChartDataset -DataProperty "VirtualMemorySize" -Label "Taille" -BackgroundColor "#80962F23" -HoverBackgroundColor "#80962F23" 
           $ds1.type = 'bar'
           $ds2 = New-UdChartDataset -DataProperty "PeakVirtualMemorySize" -Label "Espace libre" -BackgroundColor "#806495ed" -HoverBackgroundColor "#80FFFFFF" -HoverBorderColor "#80FFFFFF"
           $ds2.type = 'line'
           $ds1
           $ds2
       )
}###### fin consommation mémoire
    New-UdChart -Title "Nombre de séssions connectées." -Type Bar -AutoRefresh -Endpoint {
  Get-CimInstance -ClassName Win32_PerfFormattedData_LocalSessionManager_TerminalServices -ComputerName $ADRODC | Out-UDChartData -LabelProperty "PSComputerName" -Dataset @(
       New-UdChartDataset -DataProperty "ActiveSessions" -Label "Actives." -BackgroundColor "lightgreen" -HoverBackgroundColor "lightgreen"
       New-UdChartDataset -DataProperty "InactiveSessions" -Label "Inactives." -BackgroundColor "#333333" -HoverBackgroundColor "#333333"
   )
} -Options @{
    scales = @{
        xAxes = @(
            @{
                stacked = $true
            }
        )
        yAxes = @(
            @{
                stacked = $true
            }
        )
    }
}###### fin charts séssions
    New-UdGrid -Title "Applis en cours" -Headers @("Nom", "I/O Ko.") -Properties @("Name", "WS") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-Process -ComputerName $ADRODC | Select Name,WS | Out-UDGridData
}####### fin applis en cours
    New-UdGrid -Title "Services en cours" -Headers @("Nom", "Description") -Properties @("Name", "DisplayName") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-Service -ComputerName $ADRODC | Where-Object {$_.Status -eq "Running"} | Select Name,DisplayName | Out-UDGridData
}####### fin services
    New-UdGrid -Title "Dernières séssions connectées" -Headers @("Date", "Nom") -Properties @("TimeCreated", "Message") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-WinEvent  -ComputerName $ADRODC -FilterHashTable @{ LogName = "Microsoft-Windows-TerminalServices-LocalSessionManager/Operational"; ID = 21,25 } -MaxEvents 3 | Select-Object -Property "TimeCreated","Message" -ExpandProperty message | Out-UDGridData
}####### fin séssions connectées
    New-UdGrid -Title "Historique des mises à jour" -Headers @("Date", "Nom") -Properties @("TimeCreated", "Message") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-WinEvent -ComputerName $ADRODC -FilterHashTable @{ LogName = "System"; ID = 43 } -MaxEvents 6 | Select-Object -Property "TimeCreated","Message" -ExpandProperty message | Out-UDGridData
}####### fin events maj
   }####### fin udlayout
  }
 }### fin AD RODC
 New-UDCard -Content{
    New-UdGrid -Title "Information(s) Réseau" -Headers @("IP", "Adresse Mac", "Nom DNS", "Ordre DNS") -Properties @("IPAddress", "MACAddress", "DNSHostName", "DNSServerSearchOrder") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-CimInstance -ClassName Win32_NetworkAdapterConfiguration -Filter "IPEnabled='True'" -ComputerName $ADRODC -Property * | 
Select-Object -Property IPAddress,MACAddress,DNSHostName,DNSServerSearchOrder | Out-UDGridData
}####### fin applis en cours
 } #fin ip/mac
 New-UDCollapsible -Items {
  New-UDCollapsibleItem -BackgroundColor "#333" -FontColor "#FFF" -Title "Active Directory Slave ($ADSlave)" -Icon vcard -Content {
   New-UDLayout -Columns 2 -Content { 
    New-UdMonitor -Title "CPU (% processor time)" -Type Line -DataPointHistory 20 -RefreshInterval 5 -ChartBackgroundColor 'cornflowerblue' -ChartBorderColor 'white' -FontColor "#88FFFFFF"  -Endpoint {
     Get-Counter '\processeur(_total)\% temps processeur' -ComputerName $ADSlave -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
}### utilisation cpu
    New-UdMonitor -Title "Mémoire (% mémoire utilisée)" -Type Line -DataPointHistory 20 -RefreshInterval 5  -ChartBackgroundColor 'cornflowerblue' -ChartBorderColor 'white' -FontColor "#88FFFFFF" -Endpoint {
     Get-Counter "\mémoire\pourcentage d’octets dédiés utilisés" -ComputerName $ADSlave -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
}### accès memoire
    New-UdMonitor -Title "Disque(s) (% activité du disque)" -Type Line -DataPointHistory 20 -RefreshInterval 5 -Endpoint {
     Get-Counter "\disque physique(_total)\pourcentage du temps disque" -ComputerName $ADSlave -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
} # activité du disque
    New-UDChart -Title "Poids par Processus" -Type Doughnut -RefreshInterval 5 -Endpoint {  
    Get-Process -ComputerName $ADSlave | ForEach-Object { [PSCustomObject]@{ Name = $_.Name; Threads = $_.Threads.Count } } | Out-UDChartData -DataProperty "Threads" -LabelProperty "Name"  
} -Options @{  
     legend = @{  
         display = $false  
     }  
   }# Threads par procéssus
    New-UdChart -Title "Espace disques" -Type Bar -AutoRefresh -Endpoint {
   Get-CimInstance -ClassName Win32_LogicalDisk -ComputerName $ADSlave | ForEach-Object {
          [PSCustomObject]@{ DeviceId = $_.DeviceID;
                        Size = [Math]::Round($_.Size / 1GB, 2);
                        FreeSpace = [Math]::Round($_.FreeSpace / 1GB, 2); } } | Out-UDChartData -LabelProperty "DeviceID" -Dataset @(
       New-UdChartDataset -DataProperty "Size" -Label "Taille" -BackgroundColor "cornflowerblue" -HoverBackgroundColor "cornflowerblue"
       New-UdChartDataset -DataProperty "FreeSpace" -Label "Espace Libre" -BackgroundColor "lightgreen" -HoverBackgroundColor "lightgreen"
   )
} ###### fin charts espace disque 
    New-UdChart -Title "Consommateurs de mémoire" -Type Bar -Endpoint {
      Get-Process -ComputerName $ADSlave | Get-Random -Count 10 |  Out-UDChartData -LabelProperty "Name" -Dataset @(
           $ds1 = New-UdChartDataset -DataProperty "VirtualMemorySize" -Label "Taille" -BackgroundColor "#80962F23" -HoverBackgroundColor "#80962F23" 
           $ds1.type = 'bar'
           $ds2 = New-UdChartDataset -DataProperty "PeakVirtualMemorySize" -Label "Espace libre" -BackgroundColor "#806495ed" -HoverBackgroundColor "#80FFFFFF" -HoverBorderColor "#80FFFFFF"
           $ds2.type = 'line'
           $ds1
           $ds2
       )
}###### fin consommation mémoire
    New-UdChart -Title "Nombre de séssions connectées." -Type Bar -AutoRefresh -Endpoint {
  Get-CimInstance -ClassName Win32_PerfFormattedData_LocalSessionManager_TerminalServices -ComputerName $ADSlave | Out-UDChartData -LabelProperty "PSComputerName" -Dataset @(
       New-UdChartDataset -DataProperty "ActiveSessions" -Label "Actives." -BackgroundColor "lightgreen" -HoverBackgroundColor "lightgreen"
       New-UdChartDataset -DataProperty "InactiveSessions" -Label "Inactives." -BackgroundColor "#333333" -HoverBackgroundColor "#333333"
   )
} -Options @{
    scales = @{
        xAxes = @(
            @{
                stacked = $true
            }
        )
        yAxes = @(
            @{
                stacked = $true
            }
        )
    }
}###### fin charts séssions
    New-UdGrid -Title "Applis en cours" -Headers @("Nom", "I/O Ko.") -Properties @("Name", "WS") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-Process -ComputerName $ADSlave | Select Name,WS | Out-UDGridData
}####### fin applis en cours
    New-UdGrid -Title "Services en cours" -Headers @("Nom", "Description") -Properties @("Name", "DisplayName") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-Service -ComputerName $ADSlave | Where-Object {$_.Status -eq "Running"} | Select Name,DisplayName | Out-UDGridData
}####### fin services
    New-UdGrid -Title "Dernières séssions connectées" -Headers @("Date", "Nom") -Properties @("TimeCreated", "Message") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-WinEvent  -ComputerName $ADSlave -FilterHashTable @{ LogName = "Microsoft-Windows-TerminalServices-LocalSessionManager/Operational"; ID = 21,25 } -MaxEvents 3 | Select-Object -Property "TimeCreated","Message" -ExpandProperty message | Out-UDGridData
}####### fin séssions connectées
    New-UdGrid -Title "Historique des mises à jour" -Headers @("Date", "Nom") -Properties @("TimeCreated", "Message") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-WinEvent -ComputerName $ADSlave -FilterHashTable @{ LogName = "System"; ID = 43 } -MaxEvents 6 | Select-Object -Property "TimeCreated","Message" -ExpandProperty message | Out-UDGridData
}####### fin events maj
   }####### fin udlayout
  }
 }### fin AD Slave
 New-UDCard -Content{
    New-UdGrid -Title "Information(s) Réseau" -Headers @("IP", "Adresse Mac", "Nom DNS", "Ordre DNS") -Properties @("IPAddress", "MACAddress", "DNSHostName", "DNSServerSearchOrder") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-CimInstance -ClassName Win32_NetworkAdapterConfiguration -Filter "IPEnabled='True'" -ComputerName $ADSlave -Property * | 
Select-Object -Property IPAddress,MACAddress,DNSHostName,DNSServerSearchOrder | Out-UDGridData
}####### fin applis en cours
 } #fin ip/mac
 }
 }# fin page ADS
$page_CA = New-UDPage -Name "Authorité de Certification" -Icon certificate -Content {New-UDCollapsible -BackgroundColor "#333" -FontColor "#FFF" -Items {  
 New-UDCollapsible -BackgroundColor "#333" -FontColor "#FFF" -Items {
    New-UDCollapsibleItem -BackgroundColor "#333" -FontColor "#FFF" -Title "Authorité de Certification ($CA)" -Icon certificate -Content {
   New-UDLayout -Columns 2 -Content { 
       ### temps CPU
   New-UdMonitor -Title "CPU (% processor time)" -Type Line -DataPointHistory 20 -RefreshInterval 5 -ChartBackgroundColor 'cornflowerblue' -ChartBorderColor 'white' -FontColor "#88FFFFFF" -Endpoint {
     Get-Counter '\processeur(_total)\% temps processeur' -ComputerName $CA -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
}
   ### mem usage
   New-UdMonitor -Title "Mémoire (% mémoire utilisée)" -Type Line -DataPointHistory 20 -RefreshInterval 5 -ChartBackgroundColor 'cornflowerblue' -ChartBorderColor 'white' -FontColor "#88FFFFFF" -Endpoint {
     Get-Counter "\mémoire\pourcentage d’octets dédiés utilisés" -ComputerName $CA -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
}
   ### disk access
   New-UdMonitor -Title "Disque(s) (% activité du disque)" -Type Line -DataPointHistory 20 -RefreshInterval 5 -ChartBackgroundColor 'cornflowerblue' -ChartBorderColor 'white' -FontColor "#88FFFFFF" -Endpoint {
     Get-Counter "\disque physique(_total)\pourcentage du temps disque" -ComputerName $CA -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
}
    # processus en 
    # processus en cours (circle)
    New-UDChart -Title "Poids par Processus" -Type Doughnut -RefreshInterval 5 -Endpoint {  
    Get-Process -ComputerName $CA | ForEach-Object { [PSCustomObject]@{ Name = $_.Name; Threads = $_.Threads.Count } } | Out-UDChartData -DataProperty "Threads" -LabelProperty "Name"  
} -Options @{  
     legend = @{  
         display = $false  
     }  
   }
   # batons
  New-UdChart -Title "Espace disques" -Type Bar -AutoRefresh -Endpoint {
  Get-CimInstance -ClassName Win32_LogicalDisk -ComputerName $CA | ForEach-Object {
          [PSCustomObject]@{ DeviceId = $_.DeviceID;
                        Size = [Math]::Round($_.Size / 1GB, 2);
                        FreeSpace = [Math]::Round($_.FreeSpace / 1GB, 2); } } | Out-UDChartData -LabelProperty "DeviceID" -Dataset @(
       New-UdChartDataset -DataProperty "Size" -Label "Taille" -BackgroundColor "cornflowerblue" -HoverBackgroundColor "cornflowerblue"
       New-UdChartDataset -DataProperty "FreeSpace" -Label "Espace Libre" -BackgroundColor "lightgreen" -HoverBackgroundColor "lightgreen"
   )
}
###### fin charts 
 New-UdChart -Title "Consommateurs de mémoire" -Type Bar -Endpoint {
      Get-Process -ComputerName $CA | Get-Random -Count 10 |  Out-UDChartData -LabelProperty "Name" -Dataset @(
           $ds1 = New-UdChartDataset -DataProperty "VirtualMemorySize" -Label "Taille" -BackgroundColor "#80962F23" -HoverBackgroundColor "#80962F23" 
           $ds1.type = 'bar'
           $ds2 = New-UdChartDataset -DataProperty "PeakVirtualMemorySize" -Label "Espace libre" -BackgroundColor "#806495ed" -HoverBackgroundColor "#80FFFFFF" -HoverBorderColor "#80FFFFFF"
           $ds2.type = 'line'
           $ds1
           $ds2
       )
}
###### fin mémoire
  New-UdChart -Title "Nombre de séssions connectées." -Type Bar -AutoRefresh -Endpoint {
  Get-CimInstance -ClassName Win32_PerfFormattedData_LocalSessionManager_TerminalServices -ComputerName $CA | Out-UDChartData -LabelProperty "PSComputerName" -Dataset @(
       New-UdChartDataset -DataProperty "ActiveSessions" -Label "Actives." -BackgroundColor "lightgreen" -HoverBackgroundColor "lightgreen"
       New-UdChartDataset -DataProperty "InactiveSessions" -Label "Inactives." -BackgroundColor "#333333" -HoverBackgroundColor "#333333"
   )
} -Options @{
    scales = @{
        xAxes = @(
            @{
                stacked = $true
            }
        )
        yAxes = @(
            @{
                stacked = $true
            }
        )
    }
}###### fin charts séssions
New-UdGrid -Title "Process en cours" -Headers @("Nom", "Description") -Properties @("Name", "Description") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-CimInstance -ClassName Win32_Process -ComputerName $CA | Select Name,Description | Out-UDGridData
}####### fin Share
New-UdGrid -Title "Partages" -Headers @("Nom", "Description") -Properties @("Name", "Description") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-CimInstance -ClassName Win32_Share -ComputerName $CA | Select Name,Description | Out-UDGridData
}####### fin Share
New-UdGrid -Title "Services en cours" -Headers @("Nom", "Status", "Description") -Properties @("Name", "Status", "DisplayName") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-Service -ComputerName $CA | Where-Object {$_.Status -eq "Running"} | Select Name,Status,DisplayName | Out-UDGridData
}####### fin services
New-UdGrid -Title "Sessions connectées" -Headers @("Date", "Nom") -Properties @("TimeCreated", "Message") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-WinEvent  -ComputerName $CA -FilterHashTable @{ LogName = "Microsoft-Windows-TerminalServices-LocalSessionManager/Operational"; ID = 21,25 } -MaxEvents 5 | Select-Object -Property "TimeCreated","Message" -ExpandProperty message | Out-UDGridData
}####### fin 
New-UdGrid -Title "Sessions déconnectées" -Headers @("Date", "Nom") -Properties @("TimeCreated", "Message") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-WinEvent -ComputerName $CA -FilterHashTable @{ LogName = "Microsoft-Windows-TerminalServices-LocalSessionManager/Operational"; ID = 24,23 } -MaxEvents 5 | Select-Object -Property "TimeCreated","Message" -ExpandProperty message | Out-UDGridData
}####### fin eventsSessionDown
New-UdGrid -Title "Historique des mises à jour" -Headers @("Date", "Nom") -Properties @("TimeCreated", "Message") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-WinEvent -ComputerName $CA -FilterHashTable @{ LogName = "System"; ID = 43 } -MaxEvents 5 | Select-Object -Property "TimeCreated","Message" -ExpandProperty message | Out-UDGridData
}####### fin events maj
}####### fin udlayout

 }
 }####fin CA
 New-UDCard -Content{
    New-UdGrid -Title "Information(s) Réseau" -Headers @("IP", "Adresse Mac", "Nom DNS", "Ordre DNS") -Properties @("IPAddress", "MACAddress", "DNSHostName", "DNSServerSearchOrder") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-CimInstance -ClassName Win32_NetworkAdapterConfiguration -Filter "IPEnabled='True'" -ComputerName $CA -Property * | 
Select-Object -Property IPAddress,MACAddress,DNSHostName,DNSServerSearchOrder | Out-UDGridData
}####### fin applis en cours
 } #fin ip/mac
 }
 }# fin page CA
$page_Hyperv = New-UDPage -Name "Cluster Hyper-V" -Icon windows -Content {New-UDCollapsible -BackgroundColor "#333" -FontColor "#FFF" -Items {  
 New-UDCollapsible -BackgroundColor "#333" -FontColor "#FFF" -Items {
  New-UDCollapsibleItem -BackgroundColor "#333" -FontColor "#FFF" -Title "Noeud 1 ($Node1)" -Icon windows -Content {
   New-UDLayout -Columns 2 -Content { 
    New-UdMonitor -Title "CPU (% processor time)" -Type Line -DataPointHistory 20 -RefreshInterval 5 -ChartBackgroundColor 'cornflowerblue' -ChartBorderColor 'white' -FontColor "#88FFFFFF" -Endpoint {
     Get-Counter '\processeur(_total)\% temps processeur' -ComputerName $Node1 -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
}### utilisation cpu
    New-UdMonitor -Title "Mémoire (% mémoire utilisée)" -Type Line -DataPointHistory 20 -RefreshInterval 5 -ChartBackgroundColor 'cornflowerblue' -ChartBorderColor 'white' -FontColor "#88FFFFFF" -Endpoint {
     Get-Counter "\mémoire\pourcentage d’octets dédiés utilisés" -ComputerName $Node1 -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
}### accès memoire
    New-UdMonitor -Title "Disque(s) (% activité du disque)" -Type Line -DataPointHistory 20 -RefreshInterval 5 -ChartBackgroundColor 'cornflowerblue' -ChartBorderColor 'white' -FontColor "#88FFFFFF" -Endpoint {
     Get-Counter "\disque physique(_total)\pourcentage du temps disque" -ComputerName $Node1 -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
} # activité du disque    
New-UdMonitor -Title "Ethernet (Mo/s)" -Type Line -DataPointHistory 20 -RefreshInterval 5 -ChartBackgroundColor 'cornflowerblue' -ChartBorderColor 'white' -FontColor "#88FFFFFF"  -Endpoint {
     Get-Counter '\IPv4\Datagrammes reçus/s' -ComputerName $Node1 -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
}### utilisation Lan
    New-UDChart -Title "Poids par Processus" -Type Doughnut -RefreshInterval 5 -Endpoint {  
    Get-Process -ComputerName $Node1 | ForEach-Object { [PSCustomObject]@{ Name = $_.Name; Threads = $_.Threads.Count } } | Out-UDChartData -DataProperty "Threads" -LabelProperty "Name"  
} -Options @{  
     legend = @{  
         display = $false  
     }  
   }# Threads par procéssus
    New-UdChart -Title "Espace disques" -Type Bar -AutoRefresh -Endpoint {
   Get-CimInstance -ClassName Win32_LogicalDisk -ComputerName $Node1 | ForEach-Object {
          [PSCustomObject]@{ DeviceId = $_.DeviceID;
                        Size = [Math]::Round($_.Size / 1GB, 2);
                        FreeSpace = [Math]::Round($_.FreeSpace / 1GB, 2); } } | Out-UDChartData -LabelProperty "DeviceID" -Dataset @(
       New-UdChartDataset -DataProperty "Size" -Label "Taille" -BackgroundColor "cornflowerblue" -HoverBackgroundColor "cornflowerblue"
       New-UdChartDataset -DataProperty "FreeSpace" -Label "Espace Libre" -BackgroundColor "lightgreen" -HoverBackgroundColor "lightgreen"
   )
} ###### fin charts espace disque 
    New-UdChart -Title "Consommateurs de mémoire" -Type Bar -Endpoint {
      Get-Process -ComputerName $Node1 | Get-Random -Count 10 |  Out-UDChartData -LabelProperty "Name" -Dataset @(
           $ds1 = New-UdChartDataset -DataProperty "VirtualMemorySize" -Label "Taille" -BackgroundColor "#80962F23" -HoverBackgroundColor "#80962F23" 
           $ds1.type = 'bar'
           $ds2 = New-UdChartDataset -DataProperty "PeakVirtualMemorySize" -Label "Espace libre" -BackgroundColor "#806495ed" -HoverBackgroundColor "#80FFFFFF" -HoverBorderColor "#80FFFFFF"
           $ds2.type = 'line'
           $ds1
           $ds2
       )
}###### fin consommation mémoire
    New-UdChart -Title "Nombre de séssions connectées." -Type Bar -AutoRefresh -Endpoint {
  Get-CimInstance -ClassName Win32_PerfFormattedData_LocalSessionManager_TerminalServices -ComputerName $Node1 | Out-UDChartData -LabelProperty "PSComputerName" -Dataset @(
       New-UdChartDataset -DataProperty "ActiveSessions" -Label "Actives." -BackgroundColor "lightgreen" -HoverBackgroundColor "lightgreen"
       New-UdChartDataset -DataProperty "InactiveSessions" -Label "Inactives." -BackgroundColor "#333333" -HoverBackgroundColor "#333333"
   )
} -Options @{
    scales = @{
        xAxes = @(
            @{
                stacked = $true
            }
        )
        yAxes = @(
            @{
                stacked = $true
            }
        )
    }
}###### fin charts séssions
    New-UdGrid -Title "Applis en cours" -Headers @("Nom", "I/O Ko.") -Properties @("Name", "WS") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-Process -ComputerName $Node1 | Select Name,WS | Out-UDGridData
}####### fin applis en cours
    New-UdGrid -Title "Services en cours" -Headers @("Nom", "Description") -Properties @("Name", "DisplayName") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-Service -ComputerName $Node1 | Where-Object {$_.Status -eq "Running"} | Select Name,DisplayName | Out-UDGridData
}####### fin services
    New-UdGrid -Title "Dernières séssions connectées" -Headers @("Date", "Nom") -Properties @("TimeCreated", "Message") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-WinEvent  -ComputerName $Node1 -FilterHashTable @{ LogName = "Microsoft-Windows-TerminalServices-LocalSessionManager/Operational"; ID = 21,25 } -MaxEvents 3 | Select-Object -Property "TimeCreated","Message" -ExpandProperty message | Out-UDGridData
}####### fin séssions connectées
    New-UdGrid -Title "Historique des mises à jour" -Headers @("Date", "Nom") -Properties @("TimeCreated", "Message") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-WinEvent -ComputerName $Node1 -FilterHashTable @{ LogName = "System"; ID = 43 } -MaxEvents 6 | Select-Object -Property "TimeCreated","Message" -ExpandProperty message | Out-UDGridData
}####### fin events maj
   }####### fin udlayout
  }
 }### fin Noeud1
 New-UDCard -Content{
    New-UdGrid -Title "Information(s) Réseau" -Headers @("IP", "Adresse Mac", "Nom DNS", "Ordre DNS") -Properties @("IPAddress", "MACAddress", "DNSHostName", "DNSServerSearchOrder") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-CimInstance -ClassName Win32_NetworkAdapterConfiguration -Filter "IPEnabled='True'" -ComputerName $Node1 -Property * | 
Select-Object -Property IPAddress,MACAddress,DNSHostName,DNSServerSearchOrder | Out-UDGridData
}####### fin applis en cours
 } #fin ip/mac
 New-UDCollapsible -BackgroundColor "#333" -FontColor "#FFF" -Items {
  New-UDCollapsibleItem -BackgroundColor "#333" -FontColor "#FFF" -Title "Noeud 2 ($Node2)" -Icon windows -Content {
   New-UDLayout -Columns 2 -Content { 
    New-UdMonitor -Title "CPU (% processor time)" -Type Line -DataPointHistory 20 -RefreshInterval 5 -ChartBackgroundColor 'cornflowerblue' -ChartBorderColor 'white' -FontColor "#88FFFFFF" -Endpoint {
     Get-Counter '\processeur(_total)\% temps processeur' -ComputerName $Node2 -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
}### utilisation cpu
    New-UdMonitor -Title "Mémoire (% mémoire utilisée)" -Type Line -DataPointHistory 20 -RefreshInterval 5 -ChartBackgroundColor 'cornflowerblue' -ChartBorderColor 'white' -FontColor "#88FFFFFF" -Endpoint {
     Get-Counter "\mémoire\pourcentage d’octets dédiés utilisés" -ComputerName $Node2 -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
}### accès memoire
    New-UdMonitor -Title "Disque(s) (% activité du disque)" -Type Line -DataPointHistory 20 -ChartBackgroundColor 'cornflowerblue' -ChartBorderColor 'white' -FontColor "#88FFFFFF" -RefreshInterval 5 -Endpoint {
     Get-Counter "\disque physique(_total)\pourcentage du temps disque" -ComputerName $Node2 -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
} # activité du disque
    New-UdMonitor -Title "Ethernet (Mo/s)" -Type Line -DataPointHistory 20 -RefreshInterval 5 -ChartBackgroundColor 'cornflowerblue' -ChartBorderColor 'white' -FontColor "#88FFFFFF"  -Endpoint {
     Get-Counter '\IPv4\Datagrammes reçus/s' -ComputerName $Node2 -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
}### utilisation Lan
    New-UDChart -Title "Poids par Processus" -Type Doughnut -RefreshInterval 5 -Endpoint {  
    Get-Process -ComputerName $Node2 | ForEach-Object { [PSCustomObject]@{ Name = $_.Name; Threads = $_.Threads.Count } } | Out-UDChartData -DataProperty "Threads" -LabelProperty "Name"  
} -Options @{  
     legend = @{  
         display = $false  
     }  
   }# Threads par procéssus
    New-UdChart -Title "Espace disques" -Type Bar -AutoRefresh -Endpoint {
   Get-CimInstance -ClassName Win32_LogicalDisk -ComputerName $Node2 | ForEach-Object {
          [PSCustomObject]@{ DeviceId = $_.DeviceID;
                        Size = [Math]::Round($_.Size / 1GB, 2);
                        FreeSpace = [Math]::Round($_.FreeSpace / 1GB, 2); } } | Out-UDChartData -LabelProperty "DeviceID" -Dataset @(
       New-UdChartDataset -DataProperty "Size" -Label "Taille" -BackgroundColor "cornflowerblue" -HoverBackgroundColor "cornflowerblue"
       New-UdChartDataset -DataProperty "FreeSpace" -Label "Espace Libre" -BackgroundColor "lightgreen" -HoverBackgroundColor "lightgreen"
   )
} ###### fin charts espace disque 
    New-UdChart -Title "Consommateurs de mémoire" -Type Bar -Endpoint {
      Get-Process -ComputerName $Node2 | Get-Random -Count 10 |  Out-UDChartData -LabelProperty "Name" -Dataset @(
           $ds1 = New-UdChartDataset -DataProperty "VirtualMemorySize" -Label "Taille" -BackgroundColor "#80962F23" -HoverBackgroundColor "#80962F23" 
           $ds1.type = 'bar'
           $ds2 = New-UdChartDataset -DataProperty "PeakVirtualMemorySize" -Label "Espace libre" -BackgroundColor "#806495ed" -HoverBackgroundColor "#80FFFFFF" -HoverBorderColor "#80FFFFFF"
           $ds2.type = 'line'
           $ds1
           $ds2
       )
}###### fin consommation mémoire
    New-UdChart -Title "Nombre de séssions connectées." -Type Bar -AutoRefresh -Endpoint {
  Get-CimInstance -ClassName Win32_PerfFormattedData_LocalSessionManager_TerminalServices -ComputerName $Node2 | Out-UDChartData -LabelProperty "PSComputerName" -Dataset @(
       New-UdChartDataset -DataProperty "ActiveSessions" -Label "Actives." -BackgroundColor "lightgreen" -HoverBackgroundColor "lightgreen"
       New-UdChartDataset -DataProperty "InactiveSessions" -Label "Inactives." -BackgroundColor "#333333" -HoverBackgroundColor "#333333"
   )
} -Options @{
    scales = @{
        xAxes = @(
            @{
                stacked = $true
            }
        )
        yAxes = @(
            @{
                stacked = $true
            }
        )
    }
}###### fin charts séssions
    New-UdGrid -Title "Applis en cours" -Headers @("Nom", "I/O Ko.") -Properties @("Name", "WS") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-Process -ComputerName $Node2 | Select Name,WS | Out-UDGridData
}####### fin applis en cours
    New-UdGrid -Title "Services en cours" -Headers @("Nom", "Description") -Properties @("Name", "DisplayName") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-Service -ComputerName $Node2 | Where-Object {$_.Status -eq "Running"} | Select Name,DisplayName | Out-UDGridData
}####### fin services
    New-UdGrid -Title "Dernières séssions connectées" -Headers @("Date", "Nom") -Properties @("TimeCreated", "Message") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-WinEvent  -ComputerName $Node2 -FilterHashTable @{ LogName = "Microsoft-Windows-TerminalServices-LocalSessionManager/Operational"; ID = 21,25 } -MaxEvents 3 | Select-Object -Property "TimeCreated","Message" -ExpandProperty message | Out-UDGridData
}####### fin séssions connectées
    New-UdGrid -Title "Historique des mises à jour" -Headers @("Date", "Nom") -Properties @("TimeCreated", "Message") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-WinEvent -ComputerName $Node2 -FilterHashTable @{ LogName = "System"; ID = 43 } -MaxEvents 6 | Select-Object -Property "TimeCreated","Message" -ExpandProperty message | Out-UDGridData
}####### fin events maj
   }####### fin udlayout
  }
 }### fin Noeud2
 New-UDCard -Content{
    New-UdGrid -Title "Information(s) Réseau" -Headers @("IP", "Adresse Mac", "Nom DNS", "Ordre DNS") -Properties @("IPAddress", "MACAddress", "DNSHostName", "DNSServerSearchOrder") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-CimInstance -ClassName Win32_NetworkAdapterConfiguration -Filter "IPEnabled='True'" -ComputerName $Node2 -Property * | 
Select-Object -Property IPAddress,MACAddress,DNSHostName,DNSServerSearchOrder | Out-UDGridData
}####### fin applis en cours
 } #fin ip/mac
 New-UDCollapsible -BackgroundColor "#333" -FontColor "#FFF" -Items {
  New-UDCollapsibleItem -BackgroundColor "#333" -FontColor "#FFF" -Title "Noeud 3 ($Node3)" -Icon windows -Content {
   New-UDLayout -Columns 2 -Content { 
    New-UdMonitor -Title "CPU (% processor time)" -Type Line -DataPointHistory 20 -RefreshInterval 5 -ChartBackgroundColor 'cornflowerblue' -ChartBorderColor 'white' -FontColor "#88FFFFFF" -Endpoint {
     Get-Counter '\processeur(_total)\% temps processeur' -ComputerName $Node3 -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
}### utilisation cpu
    New-UdMonitor -Title "Mémoire (% mémoire utilisée)" -Type Line -DataPointHistory 20 -RefreshInterval 5 -ChartBackgroundColor 'cornflowerblue' -ChartBorderColor 'white' -FontColor "#88FFFFFF" -Endpoint {
     Get-Counter "\mémoire\pourcentage d’octets dédiés utilisés" -ComputerName $Node3 -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
}### accès memoire
    New-UdMonitor -Title "Disque(s) (% activité du disque)" -Type Line -DataPointHistory 20 -RefreshInterval 5 -ChartBackgroundColor 'cornflowerblue' -ChartBorderColor 'white' -FontColor "#88FFFFFF" -Endpoint {
     Get-Counter "\disque physique(_total)\pourcentage du temps disque" -ComputerName $Node3 -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
} # activité du disque
    New-UdMonitor -Title "Ethernet (Mo/s)" -Type Line -DataPointHistory 20 -RefreshInterval 5 -ChartBackgroundColor 'cornflowerblue' -ChartBorderColor 'white' -FontColor "#88FFFFFF"  -Endpoint {
     Get-Counter '\IPv4\Datagrammes reçus/s' -ComputerName $Node3 -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
}### utilisation Lan
    New-UDChart -Title "Poids par Processus" -Type Doughnut -RefreshInterval 5 -Endpoint {  
    Get-Process -ComputerName $Node3 | ForEach-Object { [PSCustomObject]@{ Name = $_.Name; Threads = $_.Threads.Count } } | Out-UDChartData -DataProperty "Threads" -LabelProperty "Name"  
} -Options @{  
     legend = @{  
         display = $false  
     }  
   }# Threads par procéssus
    New-UdChart -Title "Espace disques" -Type Bar -AutoRefresh -Endpoint {
   Get-CimInstance -ClassName Win32_LogicalDisk -ComputerName $Node3 | ForEach-Object {
          [PSCustomObject]@{ DeviceId = $_.DeviceID;
                        Size = [Math]::Round($_.Size / 1GB, 2);
                        FreeSpace = [Math]::Round($_.FreeSpace / 1GB, 2); } } | Out-UDChartData -LabelProperty "DeviceID" -Dataset @(
       New-UdChartDataset -DataProperty "Size" -Label "Taille" -BackgroundColor "cornflowerblue" -HoverBackgroundColor "cornflowerblue"
       New-UdChartDataset -DataProperty "FreeSpace" -Label "Espace Libre" -BackgroundColor "lightgreen" -HoverBackgroundColor "lightgreen"
   )
} ###### fin charts espace disque 
    New-UdChart -Title "Consommateurs de mémoire" -Type Bar -Endpoint {
      Get-Process -ComputerName $Node3 | Get-Random -Count 10 |  Out-UDChartData -LabelProperty "Name" -Dataset @(
           $ds1 = New-UdChartDataset -DataProperty "VirtualMemorySize" -Label "Taille" -BackgroundColor "#80962F23" -HoverBackgroundColor "#80962F23" 
           $ds1.type = 'bar'
           $ds2 = New-UdChartDataset -DataProperty "PeakVirtualMemorySize" -Label "Espace libre" -BackgroundColor "#806495ed" -HoverBackgroundColor "#80FFFFFF" -HoverBorderColor "#80FFFFFF"
           $ds2.type = 'line'
           $ds1
           $ds2
       )
}###### fin consommation mémoire
    New-UdChart -Title "Nombre de séssions connectées." -Type Bar -AutoRefresh -Endpoint {
  Get-CimInstance -ClassName Win32_PerfFormattedData_LocalSessionManager_TerminalServices -ComputerName $Node3 | Out-UDChartData -LabelProperty "PSComputerName" -Dataset @(
       New-UdChartDataset -DataProperty "ActiveSessions" -Label "Actives." -BackgroundColor "lightgreen" -HoverBackgroundColor "lightgreen"
       New-UdChartDataset -DataProperty "InactiveSessions" -Label "Inactives." -BackgroundColor "#333333" -HoverBackgroundColor "#333333"
   )
} -Options @{
    scales = @{
        xAxes = @(
            @{
                stacked = $true
            }
        )
        yAxes = @(
            @{
                stacked = $true
            }
        )
    }
}###### fin charts séssions
    New-UdGrid -Title "Applis en cours" -Headers @("Nom", "I/O Ko.") -Properties @("Name", "WS") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-Process -ComputerName $Node3 | Select Name,WS | Out-UDGridData
}####### fin applis en cours
    New-UdGrid -Title "Services en cours" -Headers @("Nom", "Description") -Properties @("Name", "DisplayName") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-Service -ComputerName $Node3 | Where-Object {$_.Status -eq "Running"} | Select Name,DisplayName | Out-UDGridData
}####### fin services
    New-UdGrid -Title "Dernières séssions connectées" -Headers @("Date", "Nom") -Properties @("TimeCreated", "Message") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-WinEvent  -ComputerName $Node3 -FilterHashTable @{ LogName = "Microsoft-Windows-TerminalServices-LocalSessionManager/Operational"; ID = 21,25 } -MaxEvents 3 | Select-Object -Property "TimeCreated","Message" -ExpandProperty message | Out-UDGridData
}####### fin séssions connectées
    New-UdGrid -Title "Historique des mises à jour" -Headers @("Date", "Nom") -Properties @("TimeCreated", "Message") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-WinEvent -ComputerName $Node3 -FilterHashTable @{ LogName = "System"; ID = 43 } -MaxEvents 6 | Select-Object -Property "TimeCreated","Message" -ExpandProperty message | Out-UDGridData
}####### fin events maj
   }####### fin udlayout
  }
 }### fin noeud3
 New-UDCard -Content{
    New-UdGrid -Title "Information(s) Réseau" -Headers @("IP", "Adresse Mac", "Nom DNS", "Ordre DNS") -Properties @("IPAddress", "MACAddress", "DNSHostName", "DNSServerSearchOrder") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-CimInstance -ClassName Win32_NetworkAdapterConfiguration -Filter "IPEnabled='True'" -ComputerName $Node3 -Property * | 
Select-Object -Property IPAddress,MACAddress,DNSHostName,DNSServerSearchOrder | Out-UDGridData
}####### fin applis en cours
 } #fin ip/mac
 }
 }# fin page Hyperviseurs
$page_intranet = New-UDPage -Name "SharePoint Services" -Icon cloud -Content {New-UDCollapsible -BackgroundColor "#333" -FontColor "#FFF" -Items {  
 New-UDCollapsible -BackgroundColor "#333" -FontColor "#FFF" -Items {
    New-UDCollapsibleItem -BackgroundColor "#333" -FontColor "#FFF" -Title "Intranet ($intranet)" -Icon cloud -Content {
   New-UDLayout -Columns 2 -Content { 
       ### temps CPU
   New-UdMonitor -Title "CPU (% processor time)" -Type Line -DataPointHistory 20 -RefreshInterval 5 -ChartBackgroundColor 'cornflowerblue' -ChartBorderColor 'white' -FontColor "#88FFFFFF" -Endpoint {
     Get-Counter '\processeur(_total)\% temps processeur' -ComputerName $intranet -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
}
   ### mem usage
   New-UdMonitor -Title "Mémoire (% mémoire utilisée)" -Type Line -DataPointHistory 20 -RefreshInterval 5 -ChartBackgroundColor 'cornflowerblue' -ChartBorderColor 'white' -FontColor "#88FFFFFF" -Endpoint {
     Get-Counter "\mémoire\pourcentage d’octets dédiés utilisés" -ComputerName $intranet -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
}
   ### disk access
   New-UdMonitor -Title "Disque(s) (% activité du disque)" -Type Line -DataPointHistory 20 -RefreshInterval 5 -ChartBackgroundColor 'cornflowerblue' -ChartBorderColor 'white' -FontColor "#88FFFFFF" -Endpoint {
     Get-Counter "\disque physique(_total)\pourcentage du temps disque" -ComputerName $intranet -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
}
    # processus en 
    # processus en cours (circle)
    New-UDChart -Title "Poids par Processus" -Type Doughnut -RefreshInterval 5 -Endpoint {  
    Get-Process -ComputerName $intranet | ForEach-Object { [PSCustomObject]@{ Name = $_.Name; Threads = $_.Threads.Count } } | Out-UDChartData -DataProperty "Threads" -LabelProperty "Name"  
} -Options @{  
     legend = @{  
         display = $false  
     }  
   }
   # batons
  New-UdChart -Title "Espace disques" -Type Bar -AutoRefresh -Endpoint {
  Get-CimInstance -ClassName Win32_LogicalDisk -ComputerName $intranet | ForEach-Object {
          [PSCustomObject]@{ DeviceId = $_.DeviceID;
                        Size = [Math]::Round($_.Size / 1GB, 2);
                        FreeSpace = [Math]::Round($_.FreeSpace / 1GB, 2); } } | Out-UDChartData -LabelProperty "DeviceID" -Dataset @(
       New-UdChartDataset -DataProperty "Size" -Label "Taille" -BackgroundColor "cornflowerblue" -HoverBackgroundColor "cornflowerblue"
       New-UdChartDataset -DataProperty "FreeSpace" -Label "Espace Libre" -BackgroundColor "lightgreen" -HoverBackgroundColor "lightgreen"
   )
}
###### fin charts 
 New-UdChart -Title "Consommateurs de mémoire" -Type Bar -Endpoint {
      Get-Process -ComputerName $intranet | Get-Random -Count 10 |  Out-UDChartData -LabelProperty "Name" -Dataset @(
           $ds1 = New-UdChartDataset -DataProperty "VirtualMemorySize" -Label "Taille" -BackgroundColor "#80962F23" -HoverBackgroundColor "#80962F23" 
           $ds1.type = 'bar'
           $ds2 = New-UdChartDataset -DataProperty "PeakVirtualMemorySize" -Label "Espace libre" -BackgroundColor "#806495ed" -HoverBackgroundColor "#80FFFFFF" -HoverBorderColor "#80FFFFFF"
           $ds2.type = 'line'
           $ds1
           $ds2
       )
}
###### fin mémoire
  New-UdChart -Title "Nombre de séssions connectées." -Type Bar -AutoRefresh -Endpoint {
  Get-CimInstance -ClassName Win32_PerfFormattedData_LocalSessionManager_TerminalServices -ComputerName $intranet | Out-UDChartData -LabelProperty "PSComputerName" -Dataset @(
       New-UdChartDataset -DataProperty "ActiveSessions" -Label "Actives." -BackgroundColor "lightgreen" -HoverBackgroundColor "lightgreen"
       New-UdChartDataset -DataProperty "InactiveSessions" -Label "Inactives." -BackgroundColor "#333333" -HoverBackgroundColor "#333333"
   )
} -Options @{
    scales = @{
        xAxes = @(
            @{
                stacked = $true
            }
        )
        yAxes = @(
            @{
                stacked = $true
            }
        )
    }
}###### fin charts séssions
New-UdGrid -Title "Process en cours" -Headers @("Nom", "Description") -Properties @("Name", "Description") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-CimInstance -ClassName Win32_Process -ComputerName $intranet | Select Name,Description | Out-UDGridData
}####### fin Share
New-UdGrid -Title "Partages" -Headers @("Nom", "Description") -Properties @("Name", "Description") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-CimInstance -ClassName Win32_Share -ComputerName $intranet | Select Name,Description | Out-UDGridData
}####### fin Share
New-UdGrid -Title "Services en cours" -Headers @("Nom", "Status", "Description") -Properties @("Name", "Status", "DisplayName") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-Service -ComputerName $intranet | Where-Object {$_.Status -eq "Running"} | Select Name,Status,DisplayName | Out-UDGridData
}####### fin services
New-UdGrid -Title "Sessions connectées" -Headers @("Date", "Nom") -Properties @("TimeCreated", "Message") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-WinEvent  -ComputerName $intranet -FilterHashTable @{ LogName = "Microsoft-Windows-TerminalServices-LocalSessionManager/Operational"; ID = 21,25 } -MaxEvents 5 | Select-Object -Property "TimeCreated","Message" -ExpandProperty message | Out-UDGridData
}####### fin 
New-UdGrid -Title "Sessions déconnectées" -Headers @("Date", "Nom") -Properties @("TimeCreated", "Message") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-WinEvent -ComputerName $intranet -FilterHashTable @{ LogName = "Microsoft-Windows-TerminalServices-LocalSessionManager/Operational"; ID = 24,23 } -MaxEvents 5 | Select-Object -Property "TimeCreated","Message" -ExpandProperty message | Out-UDGridData
}####### fin eventsSessionDown
New-UdGrid -Title "Historique des mises à jour" -Headers @("Date", "Nom") -Properties @("TimeCreated", "Message") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-WinEvent -ComputerName $intranet -FilterHashTable @{ LogName = "System"; ID = 43 } -MaxEvents 5 | Select-Object -Property "TimeCreated","Message" -ExpandProperty message | Out-UDGridData
}####### fin events maj
}####### fin udlayout

 }
 }####fin Remote Desktop Serveur
 New-UDCard -Content{
    New-UdGrid -Title "Information(s) Réseau" -Headers @("IP", "Adresse Mac", "Nom DNS", "Ordre DNS") -Properties @("IPAddress", "MACAddress", "DNSHostName", "DNSServerSearchOrder") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-CimInstance -ClassName Win32_NetworkAdapterConfiguration -Filter "IPEnabled='True'" -ComputerName $intranet -Property * | 
Select-Object -Property IPAddress,MACAddress,DNSHostName,DNSServerSearchOrder | Out-UDGridData
}####### fin applis en cours
 } #fin ip/mac
 }
 }# fin page SharePoint
$page_monitor = New-UDPage -Name "Monitor" -Icon dashboard -Content {New-UDCollapsible -BackgroundColor "#333" -FontColor "#FFF" -Items {
    New-UDCollapsibleItem -BackgroundColor "#333" -FontColor "#FFF" -Title "$monitor - DashMonitor" -Icon dashboard -Content {
   New-UDLayout -Columns 2 -Content { 
   ### temps CPU
   New-UdMonitor -Title "CPU (% processor time)" -Type Line -DataPointHistory 20 -RefreshInterval 5 -ChartBackgroundColor '#80FF6B63' -ChartBorderColor '#FFFF6B63'  -Endpoint {
     Get-Counter '\processeur(_total)\% temps processeur' -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
}
   ### mem usage
   New-UdMonitor -Title "Memoire (% memoire utilisé)" -Type Line -DataPointHistory 20 -RefreshInterval 5 -ChartBackgroundColor '#80FF6B63' -ChartBorderColor '#FFFF6B63'  -Endpoint {
     Get-Counter "\mémoire\pourcentage d’octets dédiés utilisés" -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
}
   ### disk access
   New-UdMonitor -Title "disque (% activité du disque)" -Type Line -DataPointHistory 20 -RefreshInterval 5 -ChartBackgroundColor '#80FF6B63' -ChartBorderColor '#FFFF6B63'  -Endpoint {
     Get-Counter "\disque physique(_total)\pourcentage du temps disque" -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
}
    # processus en 
    # processus en cours (circle)
    New-UDChart -Title "Poids par Processus" -Type Doughnut -RefreshInterval 5 -Endpoint {  
    Get-Process | ForEach-Object { [PSCustomObject]@{ Name = $_.Name; Threads = $_.Threads.Count } } | Out-UDChartData -DataProperty "Threads" -LabelProperty "Name"  
} -Options @{  
     legend = @{  
         display = $false  
     }  
   }
   # batons
  New-UdChart -Title "Espace disques" -Type Bar -AutoRefresh -Endpoint {
  Get-CimInstance -ClassName Win32_LogicalDisk | ForEach-Object {
          [PSCustomObject]@{ DeviceId = $_.DeviceID;
                        Size = [Math]::Round($_.Size / 1GB, 2);
                        FreeSpace = [Math]::Round($_.FreeSpace / 1GB, 2); } } | Out-UDChartData -LabelProperty "DeviceID" -Dataset @(
       New-UdChartDataset -DataProperty "Size" -Label "Taille" -BackgroundColor "#80cc0000" -HoverBackgroundColor "#80cc0000"
       New-UdChartDataset -DataProperty "FreeSpace" -Label "Espace Libre" -BackgroundColor "#800066cc" -HoverBackgroundColor "#800066cc"
   )
}
###### fin charts 
 New-UdChart -Title "consommateurs de mémoire virtuelle" -Type Bar -Endpoint {
      Get-Process | Get-Random -Count 10 |  Out-UDChartData -LabelProperty "Name" -Dataset @(
           $ds1 = New-UdChartDataset -DataProperty "VirtualMemorySize" -Label "Taille" -BackgroundColor "#80962F23" -HoverBackgroundColor "#80962F23" 
           $ds1.type = 'bar'
           $ds2 = New-UdChartDataset -DataProperty "PeakVirtualMemorySize" -Label "Espace libre" -BackgroundColor "#806495ed" -HoverBackgroundColor "#80FFFFFF" -HoverBorderColor "#80FFFFFF"
           $ds2.type = 'line'
           $ds1
           $ds2
       )
}
###### fin mémoire
New-UdGrid -Title "Applis en cours" -Headers @("Nom", "ID", "Working Set", "CPU") -Properties @("Name", "Id", "WorkingSet", "CPU") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-Process | Select Name,ID,WorkingSet,CPU | Out-UDGridData
}
####### fin tableau1
New-UdGrid -Title "Partages" -Headers @("Nom", "Sante", "Status", "Adresse du serveur") -Properties @("Name", "HealthStatus", "OperationalStatus") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-Fileshare | Select Name,HealthStatus,OperationalStatus | Out-UDGridData
}
####### fin tableau
New-UdGrid -Title "Services en cours" -Headers @("Nom", "Status", "Description") -Properties @("Name", "Status", "DisplayName") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-Service | Where-Object {$_.Status -eq "Running"} | Select Name,Status,DisplayName | Out-UDGridData
}
####### fin services

}
####### fin udlayout

 }####fin monitor (local)}
 New-UDCard -Content{
 New-UDTextbox -Label "IP/MAC" -Value "194.57.171.184 / D4-AE-52-CC-2F-21"
 }
 }
 }# fin monitor
$page_rds = New-UDPage -Name "Remote Desktop Services" -Icon desktop -Content {New-UDCollapsible -BackgroundColor "#333" -FontColor "#FFF" -Items {  
 New-UDCollapsible -BackgroundColor "#333" -FontColor "#FFF" -Items {
    New-UDCollapsibleItem -BackgroundColor "#333" -FontColor "#FFF" -Title "Remote Desktop Server ($rds)" -Icon desktop -Content {
   New-UDLayout -Columns 2 -Content { 
       ### temps CPU
   New-UdMonitor -Title "CPU (% processor time)" -Type Line -DataPointHistory 20 -RefreshInterval 5 -ChartBackgroundColor 'cornflowerblue' -ChartBorderColor 'white' -FontColor "#88FFFFFF" -Endpoint {
     Get-Counter '\processeur(_total)\% temps processeur' -ComputerName $rds -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
}
   ### mem usage
   New-UdMonitor -Title "Mémoire (% mémoire utilisée)" -Type Line -DataPointHistory 20 -RefreshInterval 5 -ChartBackgroundColor 'cornflowerblue' -ChartBorderColor 'white' -FontColor "#88FFFFFF" -Endpoint {
     Get-Counter "\mémoire\pourcentage d’octets dédiés utilisés" -ComputerName $rds -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
}
   ### disk access
   New-UdMonitor -Title "Disque(s) (% activité du disque)" -Type Line -DataPointHistory 20 -RefreshInterval 5 -ChartBackgroundColor 'cornflowerblue' -ChartBorderColor 'white' -FontColor "#88FFFFFF" -Endpoint {
     Get-Counter "\disque physique(_total)\pourcentage du temps disque" -ComputerName $rds -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
}
    # processus en 
    # processus en cours (circle)
    New-UDChart -Title "Poids par Processus" -Type Doughnut -RefreshInterval 5 -Endpoint {  
    Get-Process -ComputerName $rds | ForEach-Object { [PSCustomObject]@{ Name = $_.Name; Threads = $_.Threads.Count } } | Out-UDChartData -DataProperty "Threads" -LabelProperty "Name"  
} -Options @{  
     legend = @{  
         display = $false  
     }  
   }
   # batons
  New-UdChart -Title "Espace disques" -Type Bar -AutoRefresh -Endpoint {
  Get-CimInstance -ClassName Win32_LogicalDisk -ComputerName $rds | ForEach-Object {
          [PSCustomObject]@{ DeviceId = $_.DeviceID;
                        Size = [Math]::Round($_.Size / 1GB, 2);
                        FreeSpace = [Math]::Round($_.FreeSpace / 1GB, 2); } } | Out-UDChartData -LabelProperty "DeviceID" -Dataset @(
       New-UdChartDataset -DataProperty "Size" -Label "Taille" -BackgroundColor "cornflowerblue" -HoverBackgroundColor "cornflowerblue"
       New-UdChartDataset -DataProperty "FreeSpace" -Label "Espace Libre" -BackgroundColor "lightgreen" -HoverBackgroundColor "lightgreen"
   )
}
###### fin charts 
 New-UdChart -Title "Consommateurs de mémoire" -Type Bar -Endpoint {
      Get-Process -ComputerName $rds | Get-Random -Count 10 |  Out-UDChartData -LabelProperty "Name" -Dataset @(
           $ds1 = New-UdChartDataset -DataProperty "VirtualMemorySize" -Label "Taille" -BackgroundColor "#80962F23" -HoverBackgroundColor "#80962F23" 
           $ds1.type = 'bar'
           $ds2 = New-UdChartDataset -DataProperty "PeakVirtualMemorySize" -Label "Espace libre" -BackgroundColor "#806495ed" -HoverBackgroundColor "#80FFFFFF" -HoverBorderColor "#80FFFFFF"
           $ds2.type = 'line'
           $ds1
           $ds2
       )
}
###### fin mémoire
  New-UdChart -Title "Nombre de séssions connectées." -Type Bar -AutoRefresh -Endpoint {
  Get-CimInstance -ClassName Win32_PerfFormattedData_LocalSessionManager_TerminalServices -ComputerName $rds | Out-UDChartData -LabelProperty "PSComputerName" -Dataset @(
       New-UdChartDataset -DataProperty "ActiveSessions" -Label "Actives." -BackgroundColor "lightgreen" -HoverBackgroundColor "lightgreen"
       New-UdChartDataset -DataProperty "InactiveSessions" -Label "Inactives." -BackgroundColor "#ec7331" -HoverBackgroundColor "#ec7331"
   )
} -Options @{
    scales = @{
        xAxes = @(
            @{
                stacked = $true
            }
        )
        yAxes = @(
            @{
                stacked = $true
            }
        )
    }
}###### fin charts séssions
New-UdGrid -Title "Process en cours" -Headers @("Nom", "Description") -Properties @("Name", "Description") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-CimInstance -ClassName Win32_Process -ComputerName $rds | Select Name,Description | Out-UDGridData
}####### fin Share
New-UdGrid -Title "Partages" -Headers @("Nom", "Description") -Properties @("Name", "Description") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-CimInstance -ClassName Win32_Share -ComputerName $rds | Select Name,Description | Out-UDGridData
}####### fin Share
New-UdGrid -Title "Services en cours" -Headers @("Nom", "Status", "Description") -Properties @("Name", "Status", "DisplayName") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-Service -ComputerName $rds | Where-Object {$_.Status -eq "Running"} | Select Name,Status,DisplayName | Out-UDGridData
}####### fin services
New-UdGrid -Title "Sessions connectées" -Headers @("Date", "Nom") -Properties @("TimeCreated", "Message") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-WinEvent  -ComputerName $rds -FilterHashTable @{ LogName = "Microsoft-Windows-TerminalServices-LocalSessionManager/Operational"; ID = 21,25 } -MaxEvents 5 | Select-Object -Property "TimeCreated","Message" -ExpandProperty message | Out-UDGridData
}####### fin 
New-UdGrid -Title "Sessions déconnectées" -Headers @("Date", "Nom") -Properties @("TimeCreated", "Message") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-WinEvent -ComputerName $rds -FilterHashTable @{ LogName = "Microsoft-Windows-TerminalServices-LocalSessionManager/Operational"; ID = 24,23 } -MaxEvents 5 | Select-Object -Property "TimeCreated","Message" -ExpandProperty message | Out-UDGridData
}####### fin eventsSessionDown
New-UdGrid -Title "Historique des mises à jour" -Headers @("Date", "Nom") -Properties @("TimeCreated", "Message") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-WinEvent -ComputerName $rds -FilterHashTable @{ LogName = "System"; ID = 43 } -MaxEvents 5 | Select-Object -Property "TimeCreated","Message" -ExpandProperty message | Out-UDGridData
}####### fin events maj
}####### fin udlayout

 }
 }####fin Remote Desktop Serveur
 New-UDCard -Content{
    New-UdGrid -Title "Information(s) Réseau" -Headers @("IP", "Adresse Mac", "Nom DNS", "Ordre DNS") -Properties @("IPAddress", "MACAddress", "DNSHostName", "DNSServerSearchOrder") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-CimInstance -ClassName Win32_NetworkAdapterConfiguration -Filter "IPEnabled='True'" -ComputerName $rds -Property * | 
Select-Object -Property IPAddress,MACAddress,DNSHostName,DNSServerSearchOrder | Out-UDGridData
}####### fin applis en cours
 } #fin ip/mac
 }
 }# fin page RDS
$page_WSUS = New-UDPage -Name "WS Update Services" -Icon calendar -Content {New-UDCollapsible -BackgroundColor "#333" -FontColor "#FFF" -Items {  
 New-UDCollapsible -BackgroundColor "#333" -FontColor "#FFF" -Items {
    New-UDCollapsibleItem -BackgroundColor "#333" -FontColor "#FFF" -Title "Windows Server Update Services ($WSUS)" -Icon calendar -Content {
   New-UDLayout -Columns 2 -Content { 
       ### temps CPU
   New-UdMonitor -Title "CPU (% processor time)" -Type Line -DataPointHistory 20 -RefreshInterval 5 -ChartBackgroundColor 'cornflowerblue' -ChartBorderColor 'white' -FontColor "#88FFFFFF" -Endpoint {
     Get-Counter '\processeur(_total)\% temps processeur' -ComputerName $WSUS -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
}
   ### mem usage
   New-UdMonitor -Title "Mémoire (% mémoire utilisée)" -Type Line -DataPointHistory 20 -RefreshInterval 5 -ChartBackgroundColor 'cornflowerblue' -ChartBorderColor 'white' -FontColor "#88FFFFFF" -Endpoint {
     Get-Counter "\mémoire\pourcentage d’octets dédiés utilisés" -ComputerName $WSUS -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
}
   ### disk access
   New-UdMonitor -Title "Disque(s) (% activité du disque)" -Type Line -DataPointHistory 20 -RefreshInterval 5 -ChartBackgroundColor 'cornflowerblue' -ChartBorderColor 'white' -FontColor "#88FFFFFF" -Endpoint {
     Get-Counter "\disque physique(_total)\pourcentage du temps disque" -ComputerName $WSUS -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
}
    # processus en 
    # processus en cours (circle)
    New-UDChart -Title "Poids par Processus" -Type Doughnut -RefreshInterval 5 -Endpoint {  
    Get-Process -ComputerName $WSUS | ForEach-Object { [PSCustomObject]@{ Name = $_.Name; Threads = $_.Threads.Count } } | Out-UDChartData -DataProperty "Threads" -LabelProperty "Name"  
} -Options @{  
     legend = @{  
         display = $false  
     }  
   }
   # batons
  New-UdChart -Title "Espace disques" -Type Bar -AutoRefresh -Endpoint {
  Get-CimInstance -ClassName Win32_LogicalDisk -ComputerName $WSUS | ForEach-Object {
          [PSCustomObject]@{ DeviceId = $_.DeviceID;
                        Size = [Math]::Round($_.Size / 1GB, 2);
                        FreeSpace = [Math]::Round($_.FreeSpace / 1GB, 2); } } | Out-UDChartData -LabelProperty "DeviceID" -Dataset @(
       New-UdChartDataset -DataProperty "Size" -Label "Taille" -BackgroundColor "cornflowerblue" -HoverBackgroundColor "cornflowerblue"
       New-UdChartDataset -DataProperty "FreeSpace" -Label "Espace Libre" -BackgroundColor "lightgreen" -HoverBackgroundColor "lightgreen"
   )
}
###### fin charts 
 New-UdChart -Title "Consommateurs de mémoire" -Type Bar -Endpoint {
      Get-Process -ComputerName $WSUS | Get-Random -Count 10 |  Out-UDChartData -LabelProperty "Name" -Dataset @(
           $ds1 = New-UdChartDataset -DataProperty "VirtualMemorySize" -Label "Taille" -BackgroundColor "#80962F23" -HoverBackgroundColor "#80962F23" 
           $ds1.type = 'bar'
           $ds2 = New-UdChartDataset -DataProperty "PeakVirtualMemorySize" -Label "Espace libre" -BackgroundColor "#806495ed" -HoverBackgroundColor "#80FFFFFF" -HoverBorderColor "#80FFFFFF"
           $ds2.type = 'line'
           $ds1
           $ds2
       )
}
###### fin mémoire
  New-UdChart -Title "Nombre de séssions connectées." -Type Bar -AutoRefresh -Endpoint {
  Get-CimInstance -ClassName Win32_PerfFormattedData_LocalSessionManager_TerminalServices -ComputerName $WSUS | Out-UDChartData -LabelProperty "PSComputerName" -Dataset @(
       New-UdChartDataset -DataProperty "ActiveSessions" -Label "Actives." -BackgroundColor "lightgreen" -HoverBackgroundColor "lightgreen"
       New-UdChartDataset -DataProperty "InactiveSessions" -Label "Inactives." -BackgroundColor "#333333" -HoverBackgroundColor "#333333"
   )
} -Options @{
    scales = @{
        xAxes = @(
            @{
                stacked = $true
            }
        )
        yAxes = @(
            @{
                stacked = $true
            }
        )
    }
}###### fin charts séssions
New-UdGrid -Title "Process en cours" -Headers @("Nom", "Description") -Properties @("Name", "Description") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-CimInstance -ClassName Win32_Process -ComputerName $WSUS | Select Name,Description | Out-UDGridData
}####### fin Share
New-UdGrid -Title "Partages" -Headers @("Nom", "Description") -Properties @("Name", "Description") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-CimInstance -ClassName Win32_Share -ComputerName $WSUS | Select Name,Description | Out-UDGridData
}####### fin Share
New-UdGrid -Title "Services en cours" -Headers @("Nom", "Status", "Description") -Properties @("Name", "Status", "DisplayName") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-Service -ComputerName $WSUS | Where-Object {$_.Status -eq "Running"} | Select Name,Status,DisplayName | Out-UDGridData
}####### fin services
New-UdGrid -Title "Sessions connectées" -Headers @("Date", "Nom") -Properties @("TimeCreated", "Message") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-WinEvent  -ComputerName $WSUS -FilterHashTable @{ LogName = "Microsoft-Windows-TerminalServices-LocalSessionManager/Operational"; ID = 21,25 } -MaxEvents 5 | Select-Object -Property "TimeCreated","Message" -ExpandProperty message | Out-UDGridData
}####### fin 
New-UdGrid -Title "Sessions déconnectées" -Headers @("Date", "Nom") -Properties @("TimeCreated", "Message") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-WinEvent -ComputerName $WSUS -FilterHashTable @{ LogName = "Microsoft-Windows-TerminalServices-LocalSessionManager/Operational"; ID = 24,23 } -MaxEvents 5 | Select-Object -Property "TimeCreated","Message" -ExpandProperty message | Out-UDGridData
}####### fin eventsSessionDown
New-UdGrid -Title "Historique des mises à jour" -Headers @("Date", "Nom") -Properties @("TimeCreated", "Message") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-WinEvent -ComputerName $WSUS -FilterHashTable @{ LogName = "System"; ID = 43 } -MaxEvents 5 | Select-Object -Property "TimeCreated","Message" -ExpandProperty message | Out-UDGridData
}####### fin events maj
}####### fin udlayout

 }
 }####fin CA
 New-UDCard -Content{
    New-UdGrid -Title "Information(s) Réseau" -Headers @("IP", "Adresse Mac", "Nom DNS", "Ordre DNS") -Properties @("IPAddress", "MACAddress", "DNSHostName", "DNSServerSearchOrder") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-CimInstance -ClassName Win32_NetworkAdapterConfiguration -Filter "IPEnabled='True'" -ComputerName $WSUS -Property * | 
Select-Object -Property IPAddress,MACAddress,DNSHostName,DNSServerSearchOrder | Out-UDGridData
}####### fin applis en cours
 } #fin ip/mac
 }
 }# fin page WSUS
$page_WDS = New-UDPage -Name "Win Deployment Server" -Icon server -Content {New-UDCollapsible -BackgroundColor "#333" -FontColor "#FFF" -Items {  
 New-UDCollapsible -BackgroundColor "#333" -FontColor "#FFF" -Items {
    New-UDCollapsibleItem -BackgroundColor "#333" -FontColor "#FFF" -Title "Windows Deployment Server ($WDS)" -Icon server -Content {
   New-UDLayout -Columns 2 -Content { 
       ### temps CPU
   New-UdMonitor -Title "CPU (% processor time)" -Type Line -DataPointHistory 20 -RefreshInterval 5 -ChartBackgroundColor 'cornflowerblue' -ChartBorderColor 'white' -FontColor "#88FFFFFF" -Endpoint {
     Get-Counter '\processeur(_total)\% temps processeur' -ComputerName $WDS -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
}
   ### mem usage
   New-UdMonitor -Title "Mémoire (% mémoire utilisée)" -Type Line -DataPointHistory 20 -RefreshInterval 5 -ChartBackgroundColor 'cornflowerblue' -ChartBorderColor 'white' -FontColor "#88FFFFFF" -Endpoint {
     Get-Counter "\mémoire\pourcentage d’octets dédiés utilisés" -ComputerName $WDS -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
}
   ### disk access
   New-UdMonitor -Title "Disque(s) (% activité du disque)" -Type Line -DataPointHistory 20 -RefreshInterval 5 -ChartBackgroundColor 'cornflowerblue' -ChartBorderColor 'white' -FontColor "#88FFFFFF" -Endpoint {
     Get-Counter "\disque physique(_total)\pourcentage du temps disque" -ComputerName $WDS -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
}
    # processus en 
    # processus en cours (circle)
    New-UDChart -Title "Poids par Processus" -Type Doughnut -RefreshInterval 5 -Endpoint {  
    Get-Process -ComputerName $WDS | ForEach-Object { [PSCustomObject]@{ Name = $_.Name; Threads = $_.Threads.Count } } | Out-UDChartData -DataProperty "Threads" -LabelProperty "Name"  
} -Options @{  
     legend = @{  
         display = $false  
     }  
   }
   # batons
  New-UdChart -Title "Espace disques" -Type Bar -AutoRefresh -Endpoint {
  Get-CimInstance -ClassName Win32_LogicalDisk -ComputerName $WDS | ForEach-Object {
          [PSCustomObject]@{ DeviceId = $_.DeviceID;
                        Size = [Math]::Round($_.Size / 1GB, 2);
                        FreeSpace = [Math]::Round($_.FreeSpace / 1GB, 2); } } | Out-UDChartData -LabelProperty "DeviceID" -Dataset @(
       New-UdChartDataset -DataProperty "Size" -Label "Taille" -BackgroundColor "cornflowerblue" -HoverBackgroundColor "cornflowerblue"
       New-UdChartDataset -DataProperty "FreeSpace" -Label "Espace Libre" -BackgroundColor "lightgreen" -HoverBackgroundColor "lightgreen"
   )
}
###### fin charts 
 New-UdChart -Title "Consommateurs de mémoire" -Type Bar -Endpoint {
      Get-Process -ComputerName $WDS | Get-Random -Count 10 |  Out-UDChartData -LabelProperty "Name" -Dataset @(
           $ds1 = New-UdChartDataset -DataProperty "VirtualMemorySize" -Label "Taille" -BackgroundColor "#80962F23" -HoverBackgroundColor "#80962F23" 
           $ds1.type = 'bar'
           $ds2 = New-UdChartDataset -DataProperty "PeakVirtualMemorySize" -Label "Espace libre" -BackgroundColor "#806495ed" -HoverBackgroundColor "#80FFFFFF" -HoverBorderColor "#80FFFFFF"
           $ds2.type = 'line'
           $ds1
           $ds2
       )
}
###### fin mémoire
  New-UdChart -Title "Nombre de séssions connectées." -Type Bar -AutoRefresh -Endpoint {
  Get-CimInstance -ClassName Win32_PerfFormattedData_LocalSessionManager_TerminalServices -ComputerName $WDS | Out-UDChartData -LabelProperty "PSComputerName" -Dataset @(
       New-UdChartDataset -DataProperty "ActiveSessions" -Label "Actives." -BackgroundColor "lightgreen" -HoverBackgroundColor "lightgreen"
       New-UdChartDataset -DataProperty "InactiveSessions" -Label "Inactives." -BackgroundColor "#333333" -HoverBackgroundColor "#333333"
   )
} -Options @{
    scales = @{
        xAxes = @(
            @{
                stacked = $true
            }
        )
        yAxes = @(
            @{
                stacked = $true
            }
        )
    }
}###### fin charts séssions
New-UdGrid -Title "Process en cours" -Headers @("Nom", "Description") -Properties @("Name", "Description") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-CimInstance -ClassName Win32_Process -ComputerName $WDS | Select Name,Description | Out-UDGridData
}####### fin Share
New-UdGrid -Title "Partages" -Headers @("Nom", "Description") -Properties @("Name", "Description") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-CimInstance -ClassName Win32_Share -ComputerName $WDS | Select Name,Description | Out-UDGridData
}####### fin Share
New-UdGrid -Title "Services en cours" -Headers @("Nom", "Status", "Description") -Properties @("Name", "Status", "DisplayName") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-Service -ComputerName $WDS | Where-Object {$_.Status -eq "Running"} | Select Name,Status,DisplayName | Out-UDGridData
}####### fin services
New-UdGrid -Title "Sessions connectées" -Headers @("Date", "Nom") -Properties @("TimeCreated", "Message") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-WinEvent  -ComputerName $WDS -FilterHashTable @{ LogName = "Microsoft-Windows-TerminalServices-LocalSessionManager/Operational"; ID = 21,25 } -MaxEvents 5 | Select-Object -Property "TimeCreated","Message" -ExpandProperty message | Out-UDGridData
}####### fin 
New-UdGrid -Title "Sessions déconnectées" -Headers @("Date", "Nom") -Properties @("TimeCreated", "Message") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-WinEvent -ComputerName $WDS -FilterHashTable @{ LogName = "Microsoft-Windows-TerminalServices-LocalSessionManager/Operational"; ID = 24,23 } -MaxEvents 5 | Select-Object -Property "TimeCreated","Message" -ExpandProperty message | Out-UDGridData
}####### fin eventsSessionDown
New-UdGrid -Title "Historique des mises à jour" -Headers @("Date", "Nom") -Properties @("TimeCreated", "Message") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-WinEvent -ComputerName $WDS -FilterHashTable @{ LogName = "System"; ID = 43 } -MaxEvents 5 | Select-Object -Property "TimeCreated","Message" -ExpandProperty message | Out-UDGridData
}####### fin events maj
}####### fin udlayout

 }
 }####fin CA
 New-UDCard -Content{
    New-UdGrid -Title "Information(s) Réseau" -Headers @("IP", "Adresse Mac", "Nom DNS", "Ordre DNS") -Properties @("IPAddress", "MACAddress", "DNSHostName", "DNSServerSearchOrder") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-CimInstance -ClassName Win32_NetworkAdapterConfiguration -Filter "IPEnabled='True'" -ComputerName $WDS -Property * | 
Select-Object -Property IPAddress,MACAddress,DNSHostName,DNSServerSearchOrder | Out-UDGridData
}####### fin applis en cours
 } #fin ip/mac
 }
 }# fin page WDS
$page_WPS = New-UDPage -Name "Win Printers Server" -Icon print -Content {New-UDCollapsible -BackgroundColor "#333" -FontColor "#FFF" -Items {  
 New-UDCollapsible -BackgroundColor "#333" -FontColor "#FFF" -Items {
    New-UDCollapsibleItem -BackgroundColor "#333" -FontColor "#FFF" -Title "Windows Printers Server ($WPS)" -Icon print -Content {
   New-UDLayout -Columns 2 -Content { 
       ### temps CPU
   New-UdMonitor -Title "CPU (% processor time)" -Type Line -DataPointHistory 20 -RefreshInterval 5 -ChartBackgroundColor 'cornflowerblue' -ChartBorderColor 'white' -FontColor "#88FFFFFF" -Endpoint {
     Get-Counter '\processeur(_total)\% temps processeur' -ComputerName $WPS -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
}
   ### mem usage
   New-UdMonitor -Title "Mémoire (% mémoire utilisée)" -Type Line -DataPointHistory 20 -RefreshInterval 5 -ChartBackgroundColor 'cornflowerblue' -ChartBorderColor 'white' -FontColor "#88FFFFFF" -Endpoint {
     Get-Counter "\mémoire\pourcentage d’octets dédiés utilisés" -ComputerName $WPS -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
}
   ### disk access
   New-UdMonitor -Title "Disque(s) (% activité du disque)" -Type Line -DataPointHistory 20 -RefreshInterval 5 -ChartBackgroundColor 'cornflowerblue' -ChartBorderColor 'white' -FontColor "#88FFFFFF" -Endpoint {
     Get-Counter "\disque physique(_total)\pourcentage du temps disque" -ComputerName $WPS -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
}
    # processus en 
    # processus en cours (circle)
    New-UDChart -Title "Poids par Processus" -Type Doughnut -RefreshInterval 5 -Endpoint {  
    Get-Process -ComputerName $WPS | ForEach-Object { [PSCustomObject]@{ Name = $_.Name; Threads = $_.Threads.Count } } | Out-UDChartData -DataProperty "Threads" -LabelProperty "Name"  
} -Options @{  
     legend = @{  
         display = $false  
     }  
   }
   # batons
  New-UdChart -Title "Espace disques" -Type Bar -AutoRefresh -Endpoint {
  Get-CimInstance -ClassName Win32_LogicalDisk -ComputerName $WPS | ForEach-Object {
          [PSCustomObject]@{ DeviceId = $_.DeviceID;
                        Size = [Math]::Round($_.Size / 1GB, 2);
                        FreeSpace = [Math]::Round($_.FreeSpace / 1GB, 2); } } | Out-UDChartData -LabelProperty "DeviceID" -Dataset @(
       New-UdChartDataset -DataProperty "Size" -Label "Taille" -BackgroundColor "cornflowerblue" -HoverBackgroundColor "cornflowerblue"
       New-UdChartDataset -DataProperty "FreeSpace" -Label "Espace Libre" -BackgroundColor "lightgreen" -HoverBackgroundColor "lightgreen"
   )
}
###### fin charts 
 New-UdChart -Title "Consommateurs de mémoire" -Type Bar -Endpoint {
      Get-Process -ComputerName $WPS | Get-Random -Count 10 |  Out-UDChartData -LabelProperty "Name" -Dataset @(
           $ds1 = New-UdChartDataset -DataProperty "VirtualMemorySize" -Label "Taille" -BackgroundColor "#80962F23" -HoverBackgroundColor "#80962F23" 
           $ds1.type = 'bar'
           $ds2 = New-UdChartDataset -DataProperty "PeakVirtualMemorySize" -Label "Espace libre" -BackgroundColor "#806495ed" -HoverBackgroundColor "#80FFFFFF" -HoverBorderColor "#80FFFFFF"
           $ds2.type = 'line'
           $ds1
           $ds2
       )
}
###### fin mémoire
  New-UdChart -Title "Nombre de séssions connectées." -Type Bar -AutoRefresh -Endpoint {
  Get-CimInstance -ClassName Win32_PerfFormattedData_LocalSessionManager_TerminalServices -ComputerName $WPS | Out-UDChartData -LabelProperty "PSComputerName" -Dataset @(
       New-UdChartDataset -DataProperty "ActiveSessions" -Label "Actives." -BackgroundColor "lightgreen" -HoverBackgroundColor "lightgreen"
       New-UdChartDataset -DataProperty "InactiveSessions" -Label "Inactives." -BackgroundColor "#333333" -HoverBackgroundColor "#333333"
   )
} -Options @{
    scales = @{
        xAxes = @(
            @{
                stacked = $true
            }
        )
        yAxes = @(
            @{
                stacked = $true
            }
        )
    }
}###### fin charts séssions
New-UdGrid -Title "Process en cours" -Headers @("Nom", "Description") -Properties @("Name", "Description") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-CimInstance -ClassName Win32_Process -ComputerName $WPS | Select Name,Description | Out-UDGridData
}####### fin Share
New-UdGrid -Title "Partages" -Headers @("Nom", "Description") -Properties @("Name", "Description") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-CimInstance -ClassName Win32_Share -ComputerName $WPS | Select Name,Description | Out-UDGridData
}####### fin Share
New-UdGrid -Title "Services en cours" -Headers @("Nom", "Status", "Description") -Properties @("Name", "Status", "DisplayName") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-Service -ComputerName $WPS | Where-Object {$_.Status -eq "Running"} | Select Name,Status,DisplayName | Out-UDGridData
}####### fin services
New-UdGrid -Title "Sessions connectées" -Headers @("Date", "Nom") -Properties @("TimeCreated", "Message") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-WinEvent  -ComputerName $WPS -FilterHashTable @{ LogName = "Microsoft-Windows-TerminalServices-LocalSessionManager/Operational"; ID = 21,25 } -MaxEvents 5 | Select-Object -Property "TimeCreated","Message" -ExpandProperty message | Out-UDGridData
}####### fin 
New-UdGrid -Title "Sessions déconnectées" -Headers @("Date", "Nom") -Properties @("TimeCreated", "Message") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-WinEvent -ComputerName $WPS -FilterHashTable @{ LogName = "Microsoft-Windows-TerminalServices-LocalSessionManager/Operational"; ID = 24,23 } -MaxEvents 5 | Select-Object -Property "TimeCreated","Message" -ExpandProperty message | Out-UDGridData
}####### fin eventsSessionDown
New-UdGrid -Title "Historique des mises à jour" -Headers @("Date", "Nom") -Properties @("TimeCreated", "Message") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-WinEvent -ComputerName $WPS -FilterHashTable @{ LogName = "System"; ID = 43 } -MaxEvents 5 | Select-Object -Property "TimeCreated","Message" -ExpandProperty message | Out-UDGridData
}####### fin events maj
}####### fin udlayout

 }
 }####fin CA
 New-UDCard -Content{
    New-UdGrid -Title "Information(s) Réseau" -Headers @("IP", "Adresse Mac", "Nom DNS", "Ordre DNS") -Properties @("IPAddress", "MACAddress", "DNSHostName", "DNSServerSearchOrder") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-CimInstance -ClassName Win32_NetworkAdapterConfiguration -Filter "IPEnabled='True'" -ComputerName $WPS -Property * | 
Select-Object -Property IPAddress,MACAddress,DNSHostName,DNSServerSearchOrder | Out-UDGridData
}####### fin applis en cours
 } #fin ip/mac
 }
 }# fin page WPS
$page_Ysoft = New-UDPage -Name "YSoft SafeQ" -Icon print -Content {
New-UDCollapsible -BackgroundColor "#333" -FontColor "#FFF" -Items {  
 New-UDCollapsible -BackgroundColor "#333" -FontColor "#FFF" -Items {
    New-UDCollapsibleItem -BackgroundColor "#333" -FontColor "#FFF" -Title "YSoft SafeQ ($YSoft)" -Icon print -Content {
   New-UDLayout -Columns 2 -Content { 
       ### temps CPU
   New-UdMonitor -Title "CPU (% processor time)" -Type Line -DataPointHistory 20 -RefreshInterval 5 -ChartBackgroundColor 'cornflowerblue' -ChartBorderColor 'white' -FontColor "#88FFFFFF" -Endpoint {
     Get-Counter '\processeur(_total)\% temps processeur' -ComputerName $YSoft -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
}
   ### mem usage
   New-UdMonitor -Title "Mémoire (% mémoire utilisée)" -Type Line -DataPointHistory 20 -RefreshInterval 5 -ChartBackgroundColor 'cornflowerblue' -ChartBorderColor 'white' -FontColor "#88FFFFFF" -Endpoint {
     Get-Counter "\mémoire\pourcentage d’octets dédiés utilisés" -ComputerName $YSoft -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
}
   ### disk access
   New-UdMonitor -Title "Disque(s) (% activité du disque)" -Type Line -DataPointHistory 20 -RefreshInterval 5 -ChartBackgroundColor 'cornflowerblue' -ChartBorderColor 'white' -FontColor "#88FFFFFF" -Endpoint {
     Get-Counter "\disque physique(_total)\pourcentage du temps disque" -ComputerName $YSoft -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
}
    # processus en 
    # processus en cours (circle)
    New-UDChart -Title "Poids par Processus" -Type Doughnut -RefreshInterval 5 -Endpoint {  
    Get-Process -ComputerName $YSoft | ForEach-Object { [PSCustomObject]@{ Name = $_.Name; Threads = $_.Threads.Count } } | Out-UDChartData -DataProperty "Threads" -LabelProperty "Name"  
} -Options @{  
     legend = @{  
         display = $false  
     }  
   }
   # batons
  New-UdChart -Title "Espace disques" -Type Bar -AutoRefresh -Endpoint {
  Get-CimInstance -ClassName Win32_LogicalDisk -ComputerName $YSoft | ForEach-Object {
          [PSCustomObject]@{ DeviceId = $_.DeviceID;
                        Size = [Math]::Round($_.Size / 1GB, 2);
                        FreeSpace = [Math]::Round($_.FreeSpace / 1GB, 2); } } | Out-UDChartData -LabelProperty "DeviceID" -Dataset @(
       New-UdChartDataset -DataProperty "Size" -Label "Taille" -BackgroundColor "cornflowerblue" -HoverBackgroundColor "cornflowerblue"
       New-UdChartDataset -DataProperty "FreeSpace" -Label "Espace Libre" -BackgroundColor "lightgreen" -HoverBackgroundColor "lightgreen"
   )
}
###### fin charts 
 New-UdChart -Title "Consommateurs de mémoire" -Type Bar -Endpoint {
      Get-Process -ComputerName $YSoft | Get-Random -Count 10 |  Out-UDChartData -LabelProperty "Name" -Dataset @(
           $ds1 = New-UdChartDataset -DataProperty "VirtualMemorySize" -Label "Taille" -BackgroundColor "#80962F23" -HoverBackgroundColor "#80962F23" 
           $ds1.type = 'bar'
           $ds2 = New-UdChartDataset -DataProperty "PeakVirtualMemorySize" -Label "Espace libre" -BackgroundColor "#806495ed" -HoverBackgroundColor "#80FFFFFF" -HoverBorderColor "#80FFFFFF"
           $ds2.type = 'line'
           $ds1
           $ds2
       )
}
###### fin mémoire
  New-UdChart -Title "Nombre de séssions connectées." -Type Bar -AutoRefresh -Endpoint {
  Get-CimInstance -ClassName Win32_PerfFormattedData_LocalSessionManager_TerminalServices -ComputerName $YSoft | Out-UDChartData -LabelProperty "PSComputerName" -Dataset @(
       New-UdChartDataset -DataProperty "ActiveSessions" -Label "Actives." -BackgroundColor "lightgreen" -HoverBackgroundColor "lightgreen"
       New-UdChartDataset -DataProperty "InactiveSessions" -Label "Inactives." -BackgroundColor "#333333" -HoverBackgroundColor "#333333"
   )
} -Options @{
    scales = @{
        xAxes = @(
            @{
                stacked = $true
            }
        )
        yAxes = @(
            @{
                stacked = $true
            }
        )
    }
}###### fin charts séssions
New-UdGrid -Title "Process en cours" -Headers @("Nom", "Description") -Properties @("Name", "Description") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-CimInstance -ClassName Win32_Process -ComputerName $YSoft | Select Name,Description | Out-UDGridData
}####### fin Share
New-UdGrid -Title "Partages" -Headers @("Nom", "Description") -Properties @("Name", "Description") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-CimInstance -ClassName Win32_Share -ComputerName $YSoft | Select Name,Description | Out-UDGridData
}####### fin Share
New-UdGrid -Title "Services en cours" -Headers @("Nom", "Description") -Properties @("Name", "DisplayName") -DefaultSortDescending -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-Service -ComputerName $YSoft | Where-Object {$_.Status -eq "Running"} | Select Name,DisplayName | Out-UDGridData
}####### fin services
New-UdGrid -Title "Sessions connectées" -Headers @("Date", "Nom") -Properties @("TimeCreated", "Message") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-WinEvent  -ComputerName $YSoft -FilterHashTable @{ LogName = "Microsoft-Windows-TerminalServices-LocalSessionManager/Operational"; ID = 21,25 } -MaxEvents 5 | Select-Object -Property "TimeCreated","Message" -ExpandProperty message | Out-UDGridData
}####### fin 
New-UdGrid -Title "Sessions déconnectées" -Headers @("Date", "Nom") -Properties @("TimeCreated", "Message") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-WinEvent -ComputerName $YSoft -FilterHashTable @{ LogName = "Microsoft-Windows-TerminalServices-LocalSessionManager/Operational"; ID = 24,23 } -MaxEvents 5 | Select-Object -Property "TimeCreated","Message" -ExpandProperty message | Out-UDGridData
}####### fin eventsSessionDown
}####### fin udlayout

 }
 }####fin CA
 New-UDCard -Content{
    New-UdGrid -Title "Information(s) Réseau" -Headers @("IP", "Adresse Mac", "Nom DNS", "Ordre DNS") -Properties @("IPAddress", "MACAddress", "DNSHostName", "DNSServerSearchOrder") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-CimInstance -ClassName Win32_NetworkAdapterConfiguration -Filter "IPEnabled='True'" -ComputerName $YSoft -Property * | 
Select-Object -Property IPAddress,MACAddress,DNSHostName,DNSServerSearchOrder | Out-UDGridData
}####### fin applis en cours
 } #fin ip/mac
 }
 }# fin page SafeQ
$page_wapt = New-UDPage -Name "GYOA - WapT" -Icon apple -Content {
New-UDCard -Title "Date et Heure" -Text "$date"
New-UDCollapsible -BackgroundColor "#333" -FontColor "#FFF" -Items {  
 New-UDCollapsible -Items  {
  New-UDCollapsibleItem -BackgroundColor "#333" -FontColor "#FFF" -Title "Get Your Own Application ($wapt)" -Icon apple -Content {
   New-UDLayout -Columns 2 -Content { 
    New-UdMonitor -Title "CPU (% du temps processeur)" -Type Line -DataPointHistory 20 -RefreshInterval 5 -ChartBackgroundColor 'cornflowerblue' -ChartBorderColor 'white' -FontColor "#88FFFFFF"  -Endpoint {
     Get-Counter '\processeur(_total)\% temps processeur' -ComputerName $wapt -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
}### utilisation cpu
    New-UdMonitor -Title "Mémoire (% mémoire utilisée)" -Type Line -DataPointHistory 20 -RefreshInterval 5  -ChartBackgroundColor 'cornflowerblue' -ChartBorderColor 'white' -FontColor "#88FFFFFF" -Endpoint {
     Get-Counter "\mémoire\pourcentage d’octets dédiés utilisés" -ComputerName $wapt -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
}### accès memoire
    New-UdMonitor -Title "Disque(s) (% activité du disque)" -Type Line -DataPointHistory 20 -RefreshInterval 5 -ChartBackgroundColor 'cornflowerblue' -ChartBorderColor 'white' -FontColor "#88FFFFFF"  -Endpoint {
     Get-Counter "\disque physique(_total)\pourcentage du temps disque" -ComputerName $wapt -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
} # activité du disque 
    New-UdMonitor -Title "Ethernet (Mo/s)" -Type Line -DataPointHistory 20 -RefreshInterval 5 -ChartBackgroundColor 'cornflowerblue' -ChartBorderColor 'white' -FontColor "#88FFFFFF"  -Endpoint {
     Get-Counter '\IPv4\Datagrammes reçus/s' -ComputerName $wapt -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
}### utilisation Lan
    New-UDChart -Title "Poids par Processus" -Type Doughnut -RefreshInterval 5 -Endpoint {  
    Get-Process -ComputerName $wapt | ForEach-Object { [PSCustomObject]@{ Name = $_.Name; Threads = $_.Threads.Count } } | Out-UDChartData -DataProperty "Threads" -LabelProperty "Name"  
} -Options @{  
     legend = @{  
         display = $false  
     }  
   }# Threads par procéssus
    New-UdChart -Title "Espace disques" -Type Bar -AutoRefresh -Endpoint {
   Get-CimInstance -ClassName Win32_LogicalDisk -ComputerName $wapt | ForEach-Object {
          [PSCustomObject]@{ DeviceId = $_.DeviceID;
                        Size = [Math]::Round($_.Size / 1GB, 2);
                        FreeSpace = [Math]::Round($_.FreeSpace / 1GB, 2); } } | Out-UDChartData -LabelProperty "DeviceID" -Dataset @(
       New-UdChartDataset -DataProperty "Size" -Label "Taille" -BackgroundColor "cornflowerblue" -HoverBackgroundColor "cornflowerblue"
       New-UdChartDataset -DataProperty "FreeSpace" -Label "Espace Libre" -BackgroundColor "lightgreen" -HoverBackgroundColor "lightgreen"
   )
} ###### fin charts espace disque 
    New-UdChart -Title "TOP 10 Consommateurs de mémoire" -Type Bar -RefreshInterval 5 -Endpoint {
      Get-Process -ComputerName $wapt | Get-Random -Count 10 |  Out-UDChartData -LabelProperty "Name" -Dataset @(
           $ds1 = New-UdChartDataset -DataProperty "VirtualMemorySize" -Label "Conso" -BackgroundColor "#806495ed" -HoverBackgroundColor "#80FFFFFF" -HoverBorderColor "#80FFFFFF" -BorderColor "#80FFFFFF"
           $ds1.type = 'line'
           $ds2 = New-UdChartDataset -DataProperty "PeakVirtualMemorySize" -Label "Pics" -BackgroundColor "#80333333" -HoverBackgroundColor "#80333333" -HoverBorderColor "#80FFFFFF"-BorderColor "#FFFFFF"
           $ds2.type = 'line'
          # $ds1
           $ds2
       )
}###### fin consommation mémoire
    New-UdChart -Title "Nombre de séssions connectées." -Type Bar -AutoRefresh -Endpoint {
  Get-CimInstance -ClassName Win32_PerfFormattedData_LocalSessionManager_TerminalServices -ComputerName $wapt | Out-UDChartData -LabelProperty "PSComputerName" -Dataset @(
       New-UdChartDataset -DataProperty "ActiveSessions" -Label "Actives." -BackgroundColor "lightgreen" -HoverBackgroundColor "lightgreen"
       New-UdChartDataset -DataProperty "InactiveSessions" -Label "Inactives." -BackgroundColor "cornflowerblue" -HoverBackgroundColor "cornflowerblue"
   )
} -Options @{
    scales = @{
        xAxes = @(
            @{
                stacked = $true
            }
        )
        yAxes = @(
            @{
                stacked = $true
            }
        )
    }
}###### fin charts séssions
    New-UdGrid -Title "Applis en cours" -Headers @("Nom", "I/O Ko.") -Properties @("Name", "WS") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-Process -ComputerName $wapt | Select Name,WS | Out-UDGridData
}####### fin applis en cours
    New-UdGrid -Title "Services en cours" -Headers @("Nom", "Description") -Properties @("Name", "DisplayName") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-Service -ComputerName $wapt | Where-Object {$_.Status -eq "Running"} | Select Name,DisplayName | Out-UDGridData
}####### fin services
    New-UdGrid -Title "Dernières séssions connectées" -Headers @("Date", "Nom") -Properties @("TimeCreated", "Message") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-WinEvent  -ComputerName $wapt -FilterHashTable @{ LogName = "Microsoft-Windows-TerminalServices-LocalSessionManager/Operational"; ID = 21,25 } -MaxEvents 3 | Select-Object -Property "TimeCreated","Message" -ExpandProperty message | Out-UDGridData
}####### fin séssions connectées
    New-UdGrid -Title "Historique des mises à jour" -Headers @("Date", "Nom") -Properties @("TimeCreated", "Message") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-WinEvent -ComputerName $wapt -FilterHashTable @{ LogName = "System"; ID = 43 } -MaxEvents 6 | Select-Object -Property "TimeCreated","Message" -ExpandProperty message | Out-UDGridData
}####### fin events maj
    New-UdGrid -Title "Historique KES" -Headers @("Date", "Nom") -Properties @("TimeCreated", "Message") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-WinEvent -ComputerName $wapt -FilterHashTable  @{ LogName = "Kaspersky Security"; ID = 6755 } -MaxEvents 1 | Select-Object -Property "TimeCreated","Message" -ExpandProperty message | Out-UDGridData
}####### fin kasc ad events
   }####### fin udlayout
  }
 }### fin AD Master
 New-UDCard -Content{
    New-UdGrid -Title "Information(s) Réseau" -Headers @("IP", "Adresse Mac", "Nom DNS", "Ordre DNS") -Properties @("IPAddress", "MACAddress", "DNSHostName", "DNSServerSearchOrder") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-CimInstance -ClassName Win32_NetworkAdapterConfiguration -Filter "IPEnabled='True'" -ComputerName $wapt -Property * | 
Select-Object -Property IPAddress,MACAddress,DNSHostName,DNSServerSearchOrder | Out-UDGridData
}####### fin applis en cours
 } #fin ip/mac
 }
}#fin de page wapt
$page_kasc = New-UDPage -Name "Kaspersky EndPoint Server" -Icon bug -Content {
New-UDCard -Title "Date et Heure" -Text "$date"
New-UDCollapsible -BackgroundColor "#333" -FontColor "#FFF" -Items {  
 New-UDCollapsible -Items  {
  New-UDCollapsibleItem -BackgroundColor "#333" -FontColor "#FFF" -Title "Kaspersky EndPoint Server ($kaspersky)" -Icon bug -Content {
   New-UDLayout -Columns 2 -Content { 
    New-UdMonitor -Title "CPU (% du temps processeur)" -Type Line -DataPointHistory 20 -RefreshInterval 5 -ChartBackgroundColor 'cornflowerblue' -ChartBorderColor 'white' -FontColor "#88FFFFFF"  -Endpoint {
     Get-Counter '\processeur(_total)\% temps processeur' -ComputerName $kaspersky -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
}### utilisation cpu
    New-UdMonitor -Title "Mémoire (% mémoire utilisée)" -Type Line -DataPointHistory 20 -RefreshInterval 5  -ChartBackgroundColor 'cornflowerblue' -ChartBorderColor 'white' -FontColor "#88FFFFFF" -Endpoint {
     Get-Counter "\mémoire\pourcentage d’octets dédiés utilisés" -ComputerName $kaspersky -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
}### accès memoire
    New-UdMonitor -Title "Disque(s) (% activité du disque)" -Type Line -DataPointHistory 20 -RefreshInterval 5 -ChartBackgroundColor 'cornflowerblue' -ChartBorderColor 'white' -FontColor "#88FFFFFF"  -Endpoint {
     Get-Counter "\disque physique(_total)\pourcentage du temps disque" -ComputerName $kaspersky -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
} # activité du disque 
    New-UdMonitor -Title "Ethernet (Mo/s)" -Type Line -DataPointHistory 20 -RefreshInterval 5 -ChartBackgroundColor 'cornflowerblue' -ChartBorderColor 'white' -FontColor "#88FFFFFF"  -Endpoint {
     Get-Counter '\IPv4\Datagrammes reçus/s' -ComputerName $kaspersky -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
}### utilisation Lan
    New-UDChart -Title "Poids par Processus" -Type Doughnut -RefreshInterval 5 -Endpoint {  
    Get-Process -ComputerName $kaspersky | ForEach-Object { [PSCustomObject]@{ Name = $_.Name; Threads = $_.Threads.Count } } | Out-UDChartData -DataProperty "Threads" -LabelProperty "Name"  
} -Options @{  
     legend = @{  
         display = $false  
     }  
   }# Threads par procéssus
    New-UdChart -Title "Espace disques" -Type Bar -AutoRefresh -Endpoint {
   Get-CimInstance -ClassName Win32_LogicalDisk -ComputerName $kaspersky | ForEach-Object {
          [PSCustomObject]@{ DeviceId = $_.DeviceID;
                        Size = [Math]::Round($_.Size / 1GB, 2);
                        FreeSpace = [Math]::Round($_.FreeSpace / 1GB, 2); } } | Out-UDChartData -LabelProperty "DeviceID" -Dataset @(
       New-UdChartDataset -DataProperty "Size" -Label "Taille" -BackgroundColor "cornflowerblue" -HoverBackgroundColor "cornflowerblue"
       New-UdChartDataset -DataProperty "FreeSpace" -Label "Espace Libre" -BackgroundColor "lightgreen" -HoverBackgroundColor "lightgreen"
   )
} ###### fin charts espace disque 
    New-UdChart -Title "TOP 10 Consommateurs de mémoire" -Type Bar -RefreshInterval 5 -Endpoint {
      Get-Process -ComputerName $kaspersky | Get-Random -Count 10 |  Out-UDChartData -LabelProperty "Name" -Dataset @(
           $ds1 = New-UdChartDataset -DataProperty "VirtualMemorySize" -Label "Conso" -BackgroundColor "#806495ed" -HoverBackgroundColor "#80FFFFFF" -HoverBorderColor "#80FFFFFF" -BorderColor "#80FFFFFF"
           $ds1.type = 'line'
           $ds2 = New-UdChartDataset -DataProperty "PeakVirtualMemorySize" -Label "Pics" -BackgroundColor "#80333333" -HoverBackgroundColor "#80333333" -HoverBorderColor "#80FFFFFF"-BorderColor "#FFFFFF"
           $ds2.type = 'line'
          # $ds1
           $ds2
       )
}###### fin consommation mémoire
    New-UdChart -Title "Nombre de séssions connectées." -Type Bar -AutoRefresh -Endpoint {
  Get-CimInstance -ClassName Win32_PerfFormattedData_LocalSessionManager_TerminalServices -ComputerName $kaspersky | Out-UDChartData -LabelProperty "PSComputerName" -Dataset @(
       New-UdChartDataset -DataProperty "ActiveSessions" -Label "Actives." -BackgroundColor "lightgreen" -HoverBackgroundColor "lightgreen"
       New-UdChartDataset -DataProperty "InactiveSessions" -Label "Inactives." -BackgroundColor "cornflowerblue" -HoverBackgroundColor "cornflowerblue"
   )
} -Options @{
    scales = @{
        xAxes = @(
            @{
                stacked = $true
            }
        )
        yAxes = @(
            @{
                stacked = $true
            }
        )
    }
}###### fin charts séssions
    New-UdGrid -Title "Applis en cours" -Headers @("Nom", "I/O Ko.") -Properties @("Name", "WS") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-Process -ComputerName $kaspersky | Select Name,WS | Out-UDGridData
}####### fin applis en cours
    New-UdGrid -Title "Services en cours" -Headers @("Nom", "Description") -Properties @("Name", "DisplayName") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-Service -ComputerName $kaspersky | Where-Object {$_.Status -eq "Running"} | Select Name,DisplayName | Out-UDGridData
}####### fin services
    New-UdGrid -Title "Dernières séssions connectées" -Headers @("Date", "Nom") -Properties @("TimeCreated", "Message") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-WinEvent  -ComputerName $kaspersky -FilterHashTable @{ LogName = "Microsoft-Windows-TerminalServices-LocalSessionManager/Operational"; ID = 21,25 } -MaxEvents 3 | Select-Object -Property "TimeCreated","Message" -ExpandProperty message | Out-UDGridData
}####### fin séssions connectées
    New-UdGrid -Title "Historique des mises à jour" -Headers @("Date", "Nom") -Properties @("TimeCreated", "Message") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-WinEvent -ComputerName $kaspersky -FilterHashTable @{ LogName = "System"; ID = 43 } -MaxEvents 6 | Select-Object -Property "TimeCreated","Message" -ExpandProperty message | Out-UDGridData
}####### fin events maj
    New-UdGrid -Title "Historique KES" -Headers @("Date", "Nom") -Properties @("TimeCreated", "Message") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-WinEvent -ComputerName $kaspersky -FilterHashTable  @{ LogName = "Kaspersky Security"; ID = 6755 } -MaxEvents 1 | Select-Object -Property "TimeCreated","Message" -ExpandProperty message | Out-UDGridData
}####### fin kasc ad events
   }####### fin udlayout
  }
 }### fin AD Master
 New-UDCard -Content{
    New-UdGrid -Title "Information(s) Réseau" -Headers @("IP", "Adresse Mac", "Nom DNS", "Ordre DNS") -Properties @("IPAddress", "MACAddress", "DNSHostName", "DNSServerSearchOrder") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-CimInstance -ClassName Win32_NetworkAdapterConfiguration -Filter "IPEnabled='True'" -ComputerName $kaspersky -Property * | 
Select-Object -Property IPAddress,MACAddress,DNSHostName,DNSServerSearchOrder | Out-UDGridData
}####### fin applis en cours
 } #fin ip/mac
 }
}#fin de page kasc
$page_urbackup = New-UDPage -Name "UrBackup" -Icon save -Content {
New-UDCard -Title "Date et Heure" -Text "$date"
New-UDCollapsible -BackgroundColor "#333" -FontColor "#FFF" -Items {  
 New-UDCollapsible -Items  {
  New-UDCollapsibleItem -BackgroundColor "#333" -FontColor "#FFF" -Title "UrBackup ($urbackup)" -Icon save -Content {
   New-UDLayout -Columns 2 -Content { 
    New-UdMonitor -Title "CPU (% du temps processeur)" -Type Line -DataPointHistory 20 -RefreshInterval 5 -ChartBackgroundColor 'cornflowerblue' -ChartBorderColor 'white' -FontColor "#88FFFFFF"  -Endpoint {
     Get-Counter '\processeur(_total)\% temps processeur' -ComputerName $urbackup -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
}### utilisation cpu
    New-UdMonitor -Title "Mémoire (% mémoire utilisée)" -Type Line -DataPointHistory 20 -RefreshInterval 5  -ChartBackgroundColor 'cornflowerblue' -ChartBorderColor 'white' -FontColor "#88FFFFFF" -Endpoint {
     Get-Counter "\mémoire\pourcentage d’octets dédiés utilisés" -ComputerName $urbackup -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
}### accès memoire
    New-UdMonitor -Title "Disque(s) (% activité du disque)" -Type Line -DataPointHistory 20 -RefreshInterval 5 -ChartBackgroundColor 'cornflowerblue' -ChartBorderColor 'white' -FontColor "#88FFFFFF"  -Endpoint {
     Get-Counter "\disque physique(_total)\pourcentage du temps disque" -ComputerName $urbackup -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
} # activité du disque 
    New-UdMonitor -Title "Ethernet (Mo/s)" -Type Line -DataPointHistory 20 -RefreshInterval 5 -ChartBackgroundColor 'cornflowerblue' -ChartBorderColor 'white' -FontColor "#88FFFFFF"  -Endpoint {
     Get-Counter '\IPv4\Datagrammes reçus/s' -ComputerName $urbackup -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
}### utilisation Lan
    New-UDChart -Title "Poids par Processus" -Type Doughnut -RefreshInterval 5 -Endpoint {  
    Get-Process -ComputerName $urbackup | ForEach-Object { [PSCustomObject]@{ Name = $_.Name; Threads = $_.Threads.Count } } | Out-UDChartData -DataProperty "Threads" -LabelProperty "Name"  
} -Options @{  
     legend = @{  
         display = $false  
     }  
   }# Threads par procéssus
    New-UdChart -Title "Espace disques" -Type Bar -AutoRefresh -Endpoint {
   Get-CimInstance -ClassName Win32_LogicalDisk -ComputerName $urbackup | ForEach-Object {
          [PSCustomObject]@{ DeviceId = $_.DeviceID;
                        Size = [Math]::Round($_.Size / 1GB, 2);
                        FreeSpace = [Math]::Round($_.FreeSpace / 1GB, 2); } } | Out-UDChartData -LabelProperty "DeviceID" -Dataset @(
       New-UdChartDataset -DataProperty "Size" -Label "Taille" -BackgroundColor "cornflowerblue" -HoverBackgroundColor "cornflowerblue"
       New-UdChartDataset -DataProperty "FreeSpace" -Label "Espace Libre" -BackgroundColor "lightgreen" -HoverBackgroundColor "lightgreen"
   )
} ###### fin charts espace disque 
    New-UdChart -Title "TOP 10 Consommateurs de mémoire" -Type Bar -RefreshInterval 5 -Endpoint {
      Get-Process -ComputerName $urbackup | Get-Random -Count 10 |  Out-UDChartData -LabelProperty "Name" -Dataset @(
           $ds1 = New-UdChartDataset -DataProperty "VirtualMemorySize" -Label "Conso" -BackgroundColor "#806495ed" -HoverBackgroundColor "#80FFFFFF" -HoverBorderColor "#80FFFFFF" -BorderColor "#80FFFFFF"
           $ds1.type = 'line'
           $ds2 = New-UdChartDataset -DataProperty "PeakVirtualMemorySize" -Label "Pics" -BackgroundColor "#80333333" -HoverBackgroundColor "#80333333" -HoverBorderColor "#80FFFFFF"-BorderColor "#FFFFFF"
           $ds2.type = 'line'
          # $ds1
           $ds2
       )
}###### fin consommation mémoire
    New-UdChart -Title "Nombre de séssions connectées." -Type Bar -AutoRefresh -Endpoint {
  Get-CimInstance -ClassName Win32_PerfFormattedData_LocalSessionManager_TerminalServices -ComputerName $urbackup | Out-UDChartData -LabelProperty "PSComputerName" -Dataset @(
       New-UdChartDataset -DataProperty "ActiveSessions" -Label "Actives." -BackgroundColor "lightgreen" -HoverBackgroundColor "lightgreen"
       New-UdChartDataset -DataProperty "InactiveSessions" -Label "Inactives." -BackgroundColor "cornflowerblue" -HoverBackgroundColor "cornflowerblue"
   )
} -Options @{
    scales = @{
        xAxes = @(
            @{
                stacked = $true
            }
        )
        yAxes = @(
            @{
                stacked = $true
            }
        )
    }
}###### fin charts séssions
    New-UdGrid -Title "Applis en cours" -Headers @("Nom", "I/O Ko.") -Properties @("Name", "WS") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-Process -ComputerName $urbackup | Select Name,WS | Out-UDGridData
}####### fin applis en cours
    New-UdGrid -Title "Services en cours" -Headers @("Nom", "Description") -Properties @("Name", "DisplayName") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-Service -ComputerName $urbackup | Where-Object {$_.Status -eq "Running"} | Select Name,DisplayName | Out-UDGridData
}####### fin services
    New-UdGrid -Title "Dernières séssions connectées" -Headers @("Date", "Nom") -Properties @("TimeCreated", "Message") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-WinEvent  -ComputerName $urbackup -FilterHashTable @{ LogName = "Microsoft-Windows-TerminalServices-LocalSessionManager/Operational"; ID = 21,25 } -MaxEvents 3 | Select-Object -Property "TimeCreated","Message" -ExpandProperty message | Out-UDGridData
}####### fin séssions connectées
    New-UdGrid -Title "Historique des mises à jour" -Headers @("Date", "Nom") -Properties @("TimeCreated", "Message") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-WinEvent -ComputerName $urbackup -FilterHashTable @{ LogName = "System"; ID = 43 } -MaxEvents 6 | Select-Object -Property "TimeCreated","Message" -ExpandProperty message | Out-UDGridData
}####### fin events maj
    New-UdGrid -Title "Historique KES" -Headers @("Date", "Nom") -Properties @("TimeCreated", "Message") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-WinEvent -ComputerName $urbackup -FilterHashTable  @{ LogName = "Kaspersky Security"; ID = 6755 } -MaxEvents 1 | Select-Object -Property "TimeCreated","Message" -ExpandProperty message | Out-UDGridData
}####### fin kasc ad events
   }####### fin udlayout
  }
 }### fin AD Master
 New-UDCard -Content{
    New-UdGrid -Title "Information(s) Réseau" -Headers @("IP", "Adresse Mac", "Nom DNS", "Ordre DNS") -Properties @("IPAddress", "MACAddress", "DNSHostName", "DNSServerSearchOrder") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-CimInstance -ClassName Win32_NetworkAdapterConfiguration -Filter "IPEnabled='True'" -ComputerName $urbackup -Property * | 
Select-Object -Property IPAddress,MACAddress,DNSHostName,DNSServerSearchOrder | Out-UDGridData
}####### fin applis en cours
 } #fin ip/mac
 }
}#fin de page urbackup
$page_Bitlocker = New-UDPage -Name "BitLocker & TPM" -Icon user_secret -Content {
    New-UdGrid -BackgroundColor '#333' -Title "Info Sécu" -FontColor '#fff' -Headers @("Name", "Recovery Passwd", "GUID") -Properties @("DistinguishedName","msfve-recoverypassword", "ObjectGUID") -AutoRefresh -RefreshInterval 600 -Endpoint {
        Get-ADObject -Server melinda.iemn.fr -Filter {objectclass -eq 'msFVE-RecoveryInformation'} -Properties * | Select DistinguishedName,msfve-recoverypassword,ObjectGUID | Out-UDGridData
    }
}#fin page bitlocker
$page_infoADmonitor = New-UDPage -Name "Active Directories Infos" -Icon address_book -Content {
New-UdGrid -Title "Forêt IEMN" -Headers @("Maître du domaine", "Niveau Fonctionnel", "Catalogue global", "Domaines") -Properties @("DomainNamingMaster", "ForestMode", "GlobalCatalogs", "Domains") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-ADForest | Select DomainNamingMaster,ForestMode,GlobalCatalogs,Domains | Out-UDGridData
}####### fin liste des comptes de Forêt AD
$users = (Get-ADUser -Filter * | Where-Object ObjectClass -eq "user" ).count
$users2 = (Get-ADUser -Filter * | Where-Object Enabled -like "False" ).count
$users3 = (Get-ADUser -Filter * | Where-Object Enabled -like "True" ).count
New-UDCard -Title "Infos Utilisateurs" -Content{
New-UDLayout -Columns 3 -Content {
New-UDCounter -BackgroundColor "lightgreen" -Title "Utilisateurs actifs" -Endpoint {$users3}
New-UDCounter -BackgroundColor "#ec7331" -Title "Utilisateurs inactifs" -Endpoint {$users2}
New-UDCounter -Title "Utilisateurs, total" -Endpoint {$users}
}
}#fin infos users
New-UdGrid -Title "Utilisateurs" -Headers @("Nom d'utilisateur", "UID", "Actif") -Properties @("UserPrincipalName", "SamAccountName", "Enabled") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-ADUser -Filter * -SearchBase "CN=Users,DC=iemn,DC=fr" | Select UserPrincipalName,SamAccountName,Enabled | Out-UDGridData
}####### fin liste des comptes de users AD
New-UdGrid -Title "Comptes de services" -Headers @("Nom d'utilisateur", "Actif") -Properties @("SamAccountName", "Enabled") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-ADServiceAccount  -Filter * | Select SamAccountName,Enabled | Out-UDGridData
}####### fin liste des comptes de services
New-UdGrid -Title "Information Mot de passe et Filers_Profiles" -Headers @("Nom d'utilisateur", "Dernière connexion", "Dernier Changement de Passwd", "Filer Profil") -Properties @("Name", "LastLogonDate", "PasswordLastSet", "HomeDrive") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-ADUser -Filter * -SearchBase "CN=Users,DC=iemn,DC=fr" -Properties * | Select Name,LastLogonDate,PasswordLastSet,HomeDrive | Out-UDGridData
}####### fin liste des comptes de users AD
New-UdGrid -Title "Postes clients sous AD" -Headers @("Noms DNS AD", "SamAccountName") -Properties @("DNSHostName", "SamAccountName") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-ADComputer  -Filter * -SearchBase "CN=Computers,DC=iemn,DC=fr" | Select DNSHostName,SamAccountName | Out-UDGridData
}####### fin liste des pc sous AD
$groups3 = Get-ADOrganizationalUnit -Filter * -Properties *
$groups2 = Get-ADGroup -Filter *
$groups1 = (Get-ADGroup -Filter * | Where-Object ObjectClass -like "group" ).count
New-UDCard -Title "Infos Groupes" -Content{
New-UDLayout -Columns 3 -Content {
New-UdGrid -Title "liste des groupes d'organisation" -Headers @("UO", "Type") -Properties @("CanonicalName", "DistinguishedName") -AutoRefresh -RefreshInterval 600 -Endpoint {
       $groups3 | Select CanonicalName,DistinguishedName | Out-UDGridData}
New-UdGrid -Title "liste des groupes" -Headers @("Nom du groupe", "Type") -Properties @("SamAccountName", "GroupCategory") -AutoRefresh -RefreshInterval 600 -Endpoint {
       $groups2 | Select SamAccountName,GroupCategory | Out-UDGridData}
New-UDCard -Title "Nombre total de groupes" -Content{
New-UDParagraph -Color "#FFF" -Content {$groups1}
}
}#fin udlayout
}#fin groups
New-UdGrid -Title "GPO IEMN.FR" -Headers @("Nom de la GPO", "Domaine" ,"Propriètaire", "Status") -Properties @("DisplayName", "DomainName", "Owner", "GpoStatus") -DefaultSortDescending -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-GPO -All -Domain iemn.fr -Server 194.57.171.186 | Select DisplayName,DomainName,Owner,GpoStatus | Out-UDGridData
}####### fin liste des serveurs applications 
New-UdGrid -Title "Certificats AD" -Headers @("Date", "Nom") -Properties @("TimeCreated", "Message") -DefaultSortDescending -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-WinEvent -ComputerName 194.57.171.186 -FilterHashTable @{ LogName = "Active Directory Web Services"; ID = 1401 } -MaxEvents 1 | Select-Object -Property "TimeCreated","Message" -ExpandProperty message | Sort-Object -Property @{Expression={$_.TimeCreated}; Ascending=$false} | Out-UDGridData
}####### fin events certAD
New-UdGrid -Title "Etât des catalogues AD" -Headers @("Date", "Nom") -Properties @("TimeCreated", "Message") -DefaultSortDescending -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-WinEvent -ComputerName 194.57.171.186 -FilterHashTable  @{ LogName = "Directory Service"; ID = 1869 } -MaxEvents 1 | Select-Object -Property "TimeCreated","Message" -ExpandProperty message | Out-UDGridData
}####### fin catalog ad events
New-UdGrid -Title "AD Cohérence" -Headers @("Etat") -Properties @("Message") -DefaultSortDescending -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-WinEvent -ComputerName 194.57.171.186 -FilterHashTable @{ LogName = "Directory Service"; ID = 1104 } -MaxEvents 3 | Select-Object "Message" -ExpandProperty message | Out-UDGridData
}####### fin coherence ad
New-UdGrid -Title "Evénements DNS" -Headers @("Date", "Nom") -Properties @("TimeCreated", "Message") -DefaultSortDescending -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-WinEvent -ComputerName 194.57.171.186 -FilterHashTable @{ LogName = "DNS Server"; ID = 4,2,769 } -MaxEvents 2 | Select-Object -Property "TimeCreated","Message" -ExpandProperty message | Sort-Object -Property @{Expression={$_.TimeCreated}; Descending=$true} | Out-UDGridData
}####### fin events dns
New-UdGrid -Title "Historique des réplications AD" -Headers @("Date", "Nom") -Properties @("TimeCreated", "Message") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-WinEvent -ComputerName 194.57.171.186 -FilterHashTable  @{ LogName = "Directory Service"; ID = 1083 } -MaxEvents 3 | Select-Object -Property "TimeCreated","Message" -ExpandProperty message | Out-UDGridData
}####### fin repl ad events
New-UdGrid -Title "Historique KES" -Headers @("Date", "Nom") -Properties @("TimeCreated", "Message") -DefaultSortDescending -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-WinEvent -ComputerName 194.57.171.186 -FilterHashTable  @{ LogName = "Kaspersky Security"; ID = 6755 } -MaxEvents 1 | Select-Object -Property "TimeCreated","Message" -ExpandProperty message | Out-UDGridData
}####### fin kasc ad events
New-UdGrid -Title "Erreurs de réplications" -Headers @("Date", "Nom") -Properties @("TimeCreated", "Message") -DefaultSortDescending -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-WinEvent -ComputerName 194.57.171.186 -FilterHashTable  @{ LogName = "Directory Service"; ID = 1308 } -MaxEvents 3 | Select-Object -Property "TimeCreated","Message" -ExpandProperty message | Out-UDGridData
}####### fin Erreurs de repl ad events
}# fin page ad infos 
$page_infoclustmonitor = New-UDPage -Name "Cluster Hyper-V Infos" -Icon windows -Content {
New-UdGrid -BackgroundColor '#333' -FontColor '#fff' -Title "Cluster Hyper-V" -Headers @("Nom du serveur") -Properties @("Name") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-Cluster -Name $Hyperviseur | Select Name | Out-UDGridData
}####### fin liste des serveurs applications
New-UdCard -Title "VMs up et Utilisation CPU(%) par Noeuds" -Content {
New-UDLayout -Columns 2 -Content{
New-UdChart -Title $Node1 -Type bar -AutoRefresh -Endpoint {
   Get-VM -ComputerName $Node1 | where State -EQ "Running" | Select Name,CPUUsage | Out-UDChartData -LabelProperty "Name" -Dataset @(
       New-UdChartDataset -DataProperty "Name" -Label "Nom de VM" -BackgroundColor "#333" -HoverBackgroundColor "#333"
       New-UdChartDataset -DataProperty "CPUUsage" -Label "Utilisation du CPU" -BackgroundColor "cornflowerblue" -HoverBackgroundColor "cornflowerblue"
   )
} ###### fin charts VM Node1
New-UdChart -Title $Node2 -Type bar -AutoRefresh -Endpoint {
   Get-VM -ComputerName $Node2 | where State -EQ "Running" | Select Name,CPUUsage | Out-UDChartData -LabelProperty "Name" -Dataset @(
       New-UdChartDataset -DataProperty "Name" -Label "Nom de VM" -BackgroundColor "#333" -HoverBackgroundColor "#333"
       New-UdChartDataset -DataProperty "CPUUsage" -Label "Utilisation du CPU" -BackgroundColor "cornflowerblue" -HoverBackgroundColor "cornflowerblue"
   )
} ###### fin charts VM Node2
New-UdChart -Title $Node3 -Type bar -AutoRefresh -Endpoint {
   Get-VM -ComputerName $Node3 | where State -EQ "Running" | Select Name,CPUUsage | Out-UDChartData -LabelProperty "Name" -Dataset @(
       New-UdChartDataset -DataProperty "Name" -Label "Nom de VM" -BackgroundColor "#333" -HoverBackgroundColor "#333"
       New-UdChartDataset -DataProperty "CPUUsage" -Label "Utilisation du CPU" -BackgroundColor "cornflowerblue" -HoverBackgroundColor "cornflowerblue"
   )
} ###### fin charts VM Node3
} # fin layout
}# fin card
New-UDLayout -Columns 4 -Content{
New-UdGrid -Title "Noeuds Hyper-V" -Headers @("Nom", "ID", "State") -Properties @("Name", "ID", "State") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-ClusterNode -Cluster  $Hyperviseur | Select Name,ID,State | Out-UDGridData
}####### fin liste des serveurs applications
New-UdGrid -Title "LciServ VSAN Hyper-V" -Headers @("Nom", "State") -Properties @("Name", "State") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-ClusterResource -Cluster $Hyperviseur -Name "Serveur de fichiers (\\lciserv2)" | Select Name,State | Out-UDGridData
}####### fin liste des serveurs applications
New-UdGrid -Title "Quorum Noeuds Hyper-V" -Headers @("Nom", "Status") -Properties @("Name", "State") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-ClusterResource -Cluster $Hyperviseur -Name "Quorum" | Select Name,State | Out-UDGridData
}####### fin liste des serveurs applications
New-UdGrid -Title "VLAN Noeuds Hyper-V" -Headers @("Nom", "Status") -Properties @("Name", "State") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-ClusterResource -Cluster $Hyperviseur | where ResourceType -EQ "IP Address" | where Name -NotLike "sin-city" | Select Name,State | Out-UDGridData
       }####### fin liste des serveurs applications
} # fin layout
New-UDLayout -Columns 2 -Content{
New-UdGrid -BackgroundColor '#333' -FontColor '#fff' -Title "Liste des VMs Hyper-V" -Headers @("Nom de la VM", "Etât") -Properties @("Name", "State") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-Cluster –Name $Hyperviseur | Get-ClusterGroup | Select Name,State | Out-UDGridData
}####### fin liste des vms
New-UdGrid -BackgroundColor '#333' -FontColor '#fff' -Title "Liste des Rôles Hyper-V" -Headers @("Nom de la VM", "Etât") -Properties @("Name", "State") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-Cluster –Name $Hyperviseur | Get-ClusterGroup | Get-ClusterResource | Select Name,State | Out-UDGridData
}####### fin liste des vms
} # fin layout
New-UdGrid -BackgroundColor '#333' -FontColor '#fff' -Title "Détails des VMs Hyper-V" -Headers @("Nom de la VM", "Etât", "Utilisation CPU %", "Mémoire Allouée", "Version Hyper-V") -Properties @("Name", "Status", "CPUUsage", "MemoryAssigned", "Version") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-VM –ComputerName (Get-ClusterNode –Cluster $Hyperviseur) | Select Name,Status,CPUUsage,MemoryAssigned,Version | Out-UDGridData
}####### fin liste des vms
New-UdGrid -BackgroundColor '#333' -FontColor '#fff' -Title "Détails Réseau des VMs Hyper-V" -Headers @("Nom de la VM", "Nom du VSwitch", "Adresse MAC") -Properties @("VMName", "SwitchName", "MacAddress") -AutoRefresh -RefreshInterval 10 -Endpoint {
$vmconf = Get-VM -ComputerName (Get-ClusterNode -Cluster sin-city.iemn.fr) | select Name 
ForEach($itemvmconf in $vmconf)
{Get-VMNetworkAdapter -ComputerName (Get-ClusterNode -Cluster sin-city.iemn.fr) -VMName $itemvmconf.Name | select VMName,SwitchName,MacAddress | Out-UDGridData} 
}####### fin liste confs réseau des vms
}#fin page
$page_infoRDSmonitor = New-UDPage -Name "Remote Desktop Infos" -Icon desktop -Content {
New-UdGrid -BackgroundColor '#333' -FontColor '#fff' -Title "Serveurs RDS" -Headers @("Nom du serveur") -Properties @("Server") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-RDServer -ConnectionBroker $rds | Select Server | Out-UDGridData
}####### fin liste des serveurs applications
New-UDLayout -Columns 2 -Content{
New-UdGrid -BackgroundColor '#333' -Title "Applications RDS" -FontColor '#fff' -Headers @("Nom du serveur", "Dossier") -Properties @("DisplayName", "FilePath") -AutoRefresh -RefreshInterval 600 -Endpoint {
       Get-RDRemoteApp -ConnectionBroker $rds -CollectionName "IEMN" | Select DisplayName,FilePath | Out-UDGridData
}####### fin liste des serveurs applications
New-UdGrid -BackgroundColor '#333' -Title "Utilisateurs connectés" -FontColor '#fff' -Headers @("Nom de l'utilisateur", "Nom du Serveur Hôte") -Properties @("UserName", "HostServer") -AutoRefresh -RefreshInterval 600 -Endpoint {
       Get-RDUserSession -ConnectionBroker $rds | Select UserName,HostServer | Out-UDGridData
}####### fin liste des utilisateurs connectés
New-UdGrid -BackgroundColor '#333' -Title "Certificats" -FontColor '#fff' -Headers @("Rôle", "Etât", "Expire le") -Properties @("Role", "Level", "ExpiresOn") -AutoRefresh -RefreshInterval 600 -Endpoint {
       Get-RDCertificate -ConnectionBroker $rds | Select Role,Level,ExpiresOn | Out-UDGridData
}####### fin liste des certificats
}#fin udlayout
$activsessions = Get-TSSessions -ComputerName $RDS01
New-UDParagraph -Text "$activsessions" -Color "#fff"
}#fin page
$page_infoSPmonitor = New-UDPage -Name "SharePoint Infos" -Icon cloud_download -Content {
$ssp=new-PSsession -ComputerName $intranet -Name "SP1"
New-UdGrid -Title "Sites SharePoint" -Headers @("Url") -Properties @("Url") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Invoke-Command -Session $ssp -ScriptBlock {
Add-PSSnapin Microsoft.SharePoint.Powershell
Get-SPSite} | Select Url | Out-UDGridData
}####### fin liste de sites
$ssp2=new-PSsession -ComputerName $intranet -Name "SP2"
New-UdGrid -Title "Url publiques SharePoint" -Headers @("Public Url") -Properties @("PublicUrl") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Invoke-Command -Session $ssp2 -ScriptBlock {
Add-PSSnapin Microsoft.SharePoint.Powershell
Get-SPAlternateURL} | Select PublicUrl | Out-UDGridData
}
####### fin liste de url publiques
}#fin de page
$page_infoCAmonitor = New-UDPage -Name "Auth de Certification Infos" -Icon certificate -Content{
    $sCA=new-PSsession -ComputerName $CA 
New-UdGrid -Title "Modèles Certificats" -Headers @("Nom") -Properties @("Name") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Invoke-Command -Session $sCA -ScriptBlock {Get-CATemplate} | Select Name | Out-UDGridData
}####### fin liste des modeles
}#fin de page
$page_infoWDSmonitor = New-UDPage -Name "WDS Infos" -Icon server -Content{
    New-UDLayout -Columns 2 -Content{
    New-UdGrid -Title "Etât du serveur" -Headers @("Date", "Nom") -Properties @("TimeCreated", "Message") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-WinEvent -ComputerName $WDS -FilterHashTable @{ LogName = "Application"; ID = 256 } -MaxEvents 1 | Out-UDGridData
}####### fin
    New-UdChart -Title "Nombre demandes actives." -Type Line -AutoRefresh -RefreshInterval 10 -Endpoint {
  Get-CimInstance -ClassName Win32_PerfFormattedData_WDSTFTP_WDSTFTPServer -ComputerName $WDS | Out-UDChartData -LabelProperty "ActiveRequests" -Dataset @(
       New-UdChartDataset -DataProperty "ActiveRequests" -Label "Actives." -BackgroundColor "lightgreen" -HoverBackgroundColor "lightgreen"
   )
} -Options @{
    scales = @{
        xAxes = @(
            @{
                stacked = $true
            }
        )
        yAxes = @(
            @{
                stacked = $true
            }
        )
    }
}###### fin charts
    } # fin du layout
    New-UdGrid -Title "Historique des échecs de téléchargements TFTP" -Headers @("Date", "Nom") -Properties @("TimeCreated", "Message") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-WinEvent -ComputerName $WDS -FilterHashTable @{ LogName = "Microsoft-Windows-Deployment-Services-Diagnostics/Admin"; ID = 4101 } -MaxEvents 3 | Out-UDGridData
}####### fin 
}#fin de page
$page_infoWSUSmonitor = New-UDPage -Name "WSUS Infos" -Icon calendar -Content{
New-UDLayout -Columns 4 -Content{
New-UDButton -Text "Nettoyer La base WSUS" -Icon bomb -OnClick{
Get-WsusServer -Name $WSUS -PortNumber 8530 | Invoke-WsusServerCleanup -CleanupObsoleteComputers -CleanupObsoleteUpdates -CleanupUnneededContentFiles -CompressUpdates -DeclineExpiredUpdates  -DeclineSupersededUpdates
Show-UDToast -Icon mail_reply -IconColor "white" -MessageColor "#ec7331" -BackgroundColor "#ccc" -Duration 10000 -Message "Je fais le job !"  
}#fin bouton
New-UDButton -Text "Forcer les màj" -Icon chain_broken -OnClick{
Get-WsusServer -Name $WSUS -PortNumber 8530 | Get-WsusUpdate -Classification All -Approval Unapproved -Status FailedOrNeeded | Approve-WsusUpdate -Action Install -TargetGroupName "All Computers"
Show-UDToast -Icon mail_reply -IconColor "white" -MessageColor "#ec7331" -BackgroundColor "#ccc" -Duration 10000 -Message "c'est parti ! - Laisse moi le temps ;)"  
}#fin bouton
}# fin du layout
New-UdGrid -Title "Serveur WSUS" -Headers @("Name") -Properties @("Name") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-WsusServer -Name $WSUS -PortNumber 8530 | Select Name | Out-UDGridData
}####### fin liste des serveurs wsus
$sWSUS2=new-PSsession -ComputerName $WSUS -Name "Two"
$sWSUS3=new-PSsession -ComputerName $WSUS -Name "Three"
$compwsus = Invoke-Command -Session $sWSUS2 -ScriptBlock {(get-wsuscomputer | Select * | Where-Object FullDomainName -Like "*iemn*" ).count}
$compwsusfailed = Invoke-Command -Session $sWSUS3 -ScriptBlock {(get-wsuscomputer | Select * | Where-Object LastSyncResult -EQ "Failed" ).count}
New-UDLayout -Columns 2 -Content{
New-UDCounter -Title "Nombre de postes sous WSUS" -Endpoint {$compwsus}
New-UDCounter -Title "Nombre de postes sous WSUS avec erreurs" -Endpoint {$compwsusfailed}
} 
$sWSUS=new-PSsession -ComputerName $WSUS -Name "One"
New-UdGrid -Title "Postes mis à jour via WSUS" -Headers @("Nom", "OS Windows", "Modele", "Fabriquant", "Etât Der Sync") -Properties @("FullDomainName", "OSDescription", "Model", "Make", "LastSyncResult") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Invoke-Command -Session $sWSUS -ScriptBlock {get-wsuscomputer | Select *} | Out-UDGridData
}####### fin liste des images de boot
$sWSUS4=new-PSsession -ComputerName $WSUS -Name "Four"
New-UdGrid -Title "Liste de produits supportés par $WSUS" -Headers @("Nom", "Type de maj", "Date de sortie") -Properties @("Description", "Type", "ArrivalDate") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Invoke-Command -Session $sWSUS4 -ScriptBlock {Get-WsusProduct | Select -ExpandProperty Product} | Out-UDGridData
}####### fin liste des images de boot
$sWSUS5=new-PSsession -ComputerName $WSUS -Name "Five"
$productwsus = Invoke-Command -Session $sWSUS5 -ScriptBlock {(Get-WsusProduct | Select -ExpandProperty Product | Where-Object PSComputerName -EQ $WSUS ).count}
New-UDCounter -Title "Nombre de produits supportés" -Endpoint {$productwsus}
}#fin de page
$page_infoWPSmonitor = New-UDPage -Name "Win Printers Server Infos" -Icon print -Content{
New-UDLayout -Columns 2 -Content{
New-UDCard -Title "IEMN-PRINTERS" -Content{
New-UdGrid -Title "Imprimantes Partagées" -Headers @("Nom", "Drivers", "Nom du port", "partagée", "Publiée dans le catalogue") -Properties @("Name", "DriverName", "PortName", "Shared", "Published") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-Printer -ComputerName $WPS | Select Name,DriverName,PortName,Shared,Published | Out-UDGridData
}####### fin liste des imprimantes iemn-printers
New-UdGrid -Title "Configuration des imprimantes" -Headers @("Nom", "Couleur") -Properties @("PrinterName", "Color") -AutoRefresh -RefreshInterval 60 -Endpoint {
       $WPSPrint = Get-printer -ComputerName $WPS | select Name 
        ForEach($itemprint in $WPSPrint)
       {Get-PrintConfiguration -ComputerName $WPS -PrinterName $itemprint.Name | Select PrinterName,Color | Out-UDGridData} 
}####### fin liste des jobs iemn-printers
New-UdGrid -Title "Queue Job" -Headers @("Nom") -Properties @("Name") -AutoRefresh -RefreshInterval 10 -Endpoint {
        $WPSPrint2 = Get-printer -ComputerName $WPS | select Name
        ForEach($itemprint2 in $WPSPrint2)
       {Get-PrintJob -ComputerName $WPS -PrinterName $itemprint2.Name | Select Name | Out-UDGridData}
}####### fin liste des jobs iemn-printers
New-UDButton -Text "Redémarrer le spooler" -Icon recycle -OnClick{
#set your first argument as $computer 
$computer2 = "iemn-printers.iemn.fr" 
#Stop the service: 
Get-WmiObject -Class Win32_Service -Filter 'name="spooler"' -ComputerName $computer2 | Invoke-WmiMethod -Name StopService | out-null 
#Delete all items in: C:\windows\system32\spool\printers on the remote computer 
#the `$ is the escape charater to make sure powershell sees the $ as a charater rather than a variable 
Get-ChildItem "\\$computer2\C`$\windows\system32\spool\printers" | Remove-Item 
#Start the service 
Set-Service spooler -ComputerName $computer2 -status Running
Show-UDToast -Icon trash -IconColor "white" -MessageColor "#ec7331" -BackgroundColor "#ccc" -Duration 10000 -Message "On enlève les âneries et on recommence !"  
}#fin bouton reset spooler cooper
}# fin de la card
New-UDCard -Title "COOPER" -Content{
New-UdGrid -Title "Imprimantes Partagées" -Headers @("Nom", "Drivers", "Nom du port", "partagée", "Publiée dans le catalogue") -Properties @("Name", "DriverName", "PortName", "Shared", "Published") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-Printer -ComputerName $ADSlave | Select Name,DriverName,PortName,Shared,Published | Out-UDGridData
}####### fin liste des imprimantes iemn-printers
New-UdGrid -Title "Configuration des imprimantes" -Headers @("Nom", "Couleur") -Properties @("PrinterName", "Color") -AutoRefresh -RefreshInterval 60 -Endpoint {
       $ADSlavePrint = Get-printer -ComputerName $ADSlave | select Name 
        ForEach($itemprintslave in $ADSlavePrint)
       {Get-PrintConfiguration -ComputerName $ADSlave -PrinterName $itemprintslave.Name | Select PrinterName,Color | Out-UDGridData} 
}####### fin liste des jobs iemn-printers
New-UdGrid -Title "Queue Job" -Headers @("Nom") -Properties @("Name") -AutoRefresh -RefreshInterval 10 -Endpoint {
       $ADSlavePrint2 = Get-printer -ComputerName $ADSlave | select Name 
        ForEach($itemprintslave2 in $ADSlavePrint)
       {Get-PrintJob -ComputerName $ADSlave -PrinterName $itemprintslave2.Name | Select * | Out-UDGridData}
}####### fin liste des jobs iemn-printers
New-UDButton -Text "Redémarrer le spooler" -Icon recycle -OnClick{
#set your first argument as $computer 
$computer = "cooper.iemn.fr" 
#Stop the service: 
Get-WmiObject -Class Win32_Service -Filter 'name="spooler"' -ComputerName $computer | Invoke-WmiMethod -Name StopService | out-null 
#Delete all items in: C:\windows\system32\spool\printers on the remote computer 
#the `$ is the escape charater to make sure powershell sees the $ as a charater rather than a variable 
Get-ChildItem "\\$computer\C`$\windows\system32\spool\printers" | Remove-Item 
#Start the service 
Set-Service spooler -ComputerName $computer -status Running
Show-UDToast -Icon trash -IconColor "white" -MessageColor "#ec7331" -BackgroundColor "#ccc" -Duration 10000 -Message "On enlève les âneries et on recommence !"  
}#fin bouton reset spooler cooper
}# fin de la card
}#fin layout
}#fin de page

# Lancement de la DashBoard
$iemn_dashboard = New-UDDashboard -Title "$titre" -NavBarColor $bgcolor -BackgroundColor $bgcolor -Footer $Footer -Theme $Theme -Pages @($page_Accueil, $page_monitor, $page_status, $page_Hyperv, $page_infoclustmonitor, $page_ActiveDirectory, $page_infoADmonitor, $page_rds, $page_infoRDSmonitor, $page_intranet, $page_infoSPmonitor, $page_WSUS, $page_infoWSUSmonitor, $page_WDS, $page_infoWDSmonitor, $page_WPS, $page_Ysoft, $page_infoWPSmonitor, $page_CA, $page_infoCAmonitor, $page_wapt, $page_kasc, $page_urbackup, $page_Bitlocker)
Start-UDDashboard -Port 8080 -Dashboard $iemn_dashboard -AutoReload # Je lance la tâche sur le port 8080 avec le nom de variable ci-dessus avec l'option d'actualisation des datas.
Start-Sleep -Seconds 3590 # Je lance un pause pour 59min 50secs
Get-PSSession | Remove-PSSession # je kill les sessions PS a distance
Get-UDDashboard | Stop-UDDashboard #je kill l'instance pour laisser place à la future (cronjob) [contournement de la limite de 1h d'utilisation].