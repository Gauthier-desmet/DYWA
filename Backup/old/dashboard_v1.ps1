#install-module -Name PowershellGet -Force
#update-Module -Name PowershellGet -Force
#Remove-module -Name PowerShellGet
#Install-Module -Name UniversalDashboard -Force -AcceptLicense
#Get-UDDashboard
#Get-UDDashboard | Stop-UDDashboard
Import-Module UniversalDashboard
#Début dashboard
$nom_organisation = "IEMN"
$monitor = "Cerberus" # Nom de l'hote powershell
$ActiveDirectoryMaster = "melinda.iemn.fr" # Active Directory Master
$CA = "winvirt.iemn.fr" # Authorité de certification
$Node3 = "marv.iemn.fr" # Hyper-V Node 3
$WDS = "tux.iemn.fr" # WDS
$WSUS = "wsus.iemn.fr" #WSUS
$intranet = "sharepoint.iemn.fr"
$Theme = New-UDTheme -Name "Basic" -Definition @{
  UDDashboard = @{
      BackgroundColor = "black"
      FontColor = "rgb(0, 0, 0)"
  }
}
$Link = New-UDLink -Text 'de Smet Gauthier' -Url 'https://desmet-gauthier.fr'
$Footer = New-UDFooter -Copyright 'IEMN - CNRS UMR 8520' -Links $Link
$iemn_dashboard = New-UDDashboard -Title "$nom_organisation Windows Monitoring" -NavBarColor '#333' -NavBarFontColor 'blue' -FontColor 'Green' -Footer $Footer -Content {
New-UDLayout -Columns 2 -Content{
 New-UDCollapsible -Items {
    New-UDCollapsibleItem -Title "$monitor - DashMonitor" -Icon dashboard -Content {
   New-UDLayout -Columns 1 -Content { 
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
           $ds2 = New-UdChartDataset -DataProperty "PeakVirtualMemorySize" -Label "Espace libre" -BackgroundColor "#8014558C" -HoverBackgroundColor "#8014558C"
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

 }
 }####fin monitor (local)
 New-UDCollapsible -Items {
  New-UDCollapsibleItem -Title "Active Directory Master ($ActiveDirectoryMaster)" -Icon vcard -Content {
   New-UDLayout -Columns 1 -Content { 
    New-UdMonitor -Title "CPU (% processor time)" -Type Line -DataPointHistory 20 -RefreshInterval 5 -ChartBackgroundColor 'cornflowerblue' -ChartBorderColor 'lightgrey' -BackgroundColor "white" -FontColor "#88000000"  -Endpoint {
     Get-Counter '\processeur(_total)\% temps processeur' -ComputerName $ActiveDirectoryMaster -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
}### utilisation cpu
    New-UdMonitor -Title "Mémoire (% mémoire utilisée)" -Type Line -DataPointHistory 20 -RefreshInterval 5  -ChartBackgroundColor 'cornflowerblue' -ChartBorderColor 'lightgrey' -BackgroundColor "white" -FontColor "#88000000" -Endpoint {
     Get-Counter "\mémoire\pourcentage d’octets dédiés utilisés" -ComputerName $ActiveDirectoryMaster -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
}### accès memoire
    New-UdMonitor -Title "Disque(s) (% activité du disque)" -Type Line -DataPointHistory 20 -RefreshInterval 5 -ChartBackgroundColor 'cornflowerblue' -ChartBorderColor 'lightgrey' -BackgroundColor "white" -FontColor "#88000000"  -Endpoint {
     Get-Counter "\disque physique(_total)\pourcentage du temps disque" -ComputerName $ActiveDirectoryMaster -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
} # activité du disque
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
    New-UdChart -Title "Consommateurs de mémoire" -Type Bar -Endpoint {
      Get-Process -ComputerName $ActiveDirectoryMaster | Get-Random -Count 10 |  Out-UDChartData -LabelProperty "Name" -Dataset @(
           $ds1 = New-UdChartDataset -DataProperty "VirtualMemorySize" -Label "Taille" -BackgroundColor "#80962F23" -HoverBackgroundColor "#80962F23" 
           $ds1.type = 'bar'
           $ds2 = New-UdChartDataset -DataProperty "PeakVirtualMemorySize" -Label "Espace libre" -BackgroundColor "#8014558C" -HoverBackgroundColor "#8014558C"
           $ds2.type = 'line'
           $ds1
           $ds2
       )
}###### fin consommation mémoire
    New-UdChart -Title "Nombre de séssions connectées." -Type Bar -AutoRefresh -Endpoint {
  Get-CimInstance -ClassName Win32_PerfFormattedData_LocalSessionManager_TerminalServices -ComputerName $ActiveDirectoryMaster | Out-UDChartData -LabelProperty "PSComputerName" -Dataset @(
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
    New-UdGrid -Title "Certificats AD" -Headers @("Date", "Nom") -Properties @("TimeCreated", "Message") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-WinEvent -ComputerName $ActiveDirectoryMaster -FilterHashTable @{ LogName = "Active Directory Web Services"; ID = 1401 } -MaxEvents 1 | Select-Object -Property "TimeCreated","Message" -ExpandProperty message | Sort-Object -Property @{Expression={$_.TimeCreated}; Ascending=$false} | Out-UDGridData
}####### fin events certAD
    New-UdGrid -Title "Etât des catalogues AD" -Headers @("Date", "Nom") -Properties @("TimeCreated", "Message") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-WinEvent -ComputerName $ActiveDirectoryMaster -FilterHashTable  @{ LogName = "Directory Service"; ID = 1869 } -MaxEvents 1 | Select-Object -Property "TimeCreated","Message" -ExpandProperty message | Out-UDGridData
}####### fin catalog ad events
    New-UdGrid -Title "AD Cohérence" -Headers @("Etat") -Properties @("Message") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-WinEvent -ComputerName $ActiveDirectoryMaster -FilterHashTable @{ LogName = "Directory Service"; ID = 1104 } -MaxEvents 1 | Select-Object -Property "Message" | Out-UDGridData
}####### fin coherence ad
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
    New-UdGrid -Title "Evénements DNS" -Headers @("Date", "Nom") -Properties @("TimeCreated", "Message") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-WinEvent -ComputerName $ActiveDirectoryMaster -FilterHashTable @{ LogName = "DNS Server"; ID = 4,2,769 } -MaxEvents 2 | Select-Object -Property "TimeCreated","Message" -ExpandProperty message | Sort-Object -Property @{Expression={$_.TimeCreated}; Descending=$true} | Out-UDGridData
}####### fin events dns
    New-UdGrid -Title "Historique des réplications AD" -Headers @("Date", "Nom") -Properties @("TimeCreated", "Message") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-WinEvent -ComputerName $ActiveDirectoryMaster -FilterHashTable  @{ LogName = "Directory Service"; ID = 1083 } -MaxEvents 3 | Select-Object -Property "TimeCreated","Message" -ExpandProperty message | Out-UDGridData
}####### fin repl ad events
    New-UdGrid -Title "Historique KES" -Headers @("Date", "Nom") -Properties @("TimeCreated", "Message") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-WinEvent -ComputerName $ActiveDirectoryMaster -FilterHashTable  @{ LogName = "Kaspersky Security"; ID = 6755 } -MaxEvents 1 | Select-Object -Property "TimeCreated","Message" -ExpandProperty message | Out-UDGridData
}####### fin kasc ad events
    New-UdGrid -Title "Erreurs de réplications" -Headers @("Date", "Nom") -Properties @("TimeCreated", "Message") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-WinEvent -ComputerName $ActiveDirectoryMaster -FilterHashTable  @{ LogName = "Directory Service"; ID = 1308 } -MaxEvents 1 | Select-Object -Property "TimeCreated","Message" | Out-UDGridData
}####### fin Erreurs de repl ad events
   }####### fin udlayout
  }
 }### fin AD Master
 New-UDCollapsible -Items {
    New-UDCollapsibleItem -Title "Active Directory RODC (logan)" -Icon vcard -Content {
   New-UDLayout -Columns 1 -Content { 
   ### temps CPU
   New-UdMonitor -Title "CPU (% processor time)" -Type Line -DataPointHistory 20 -RefreshInterval 5 -ChartBackgroundColor 'cornflowerblue' -ChartBorderColor 'lightgrey' -BackgroundColor "white" -FontColor "#88000000"  -Endpoint {
     Get-Counter '\processeur(_total)\% temps processeur' -ComputerName logan.iemn.fr -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
}
   ### mem usage
   New-UdMonitor -Title "Mémoire (% mémoire utilisée)" -Type Line -DataPointHistory 20 -RefreshInterval 5  -ChartBackgroundColor 'cornflowerblue' -ChartBorderColor 'lightgrey' -BackgroundColor "white" -FontColor "#88000000" -Endpoint {
     Get-Counter "\mémoire\pourcentage d’octets dédiés utilisés" -ComputerName logan.iemn.fr -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
}
   ### disk access
   New-UdMonitor -Title "Disque(s) (% activité du disque)" -Type Line -DataPointHistory 20 -RefreshInterval 5 -ChartBackgroundColor 'cornflowerblue' -ChartBorderColor 'lightgrey' -BackgroundColor "white" -FontColor "#88000000"  -Endpoint {
     Get-Counter "\disque physique(_total)\pourcentage du temps disque" -ComputerName logan.iemn.fr -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
}
    # processus en 
    # processus en cours (circle)
    New-UDChart -Title "Poids par Processus" -Type Doughnut -RefreshInterval 5 -Endpoint {  
    Get-Process -ComputerName logan.iemn.fr | ForEach-Object { [PSCustomObject]@{ Name = $_.Name; Threads = $_.Threads.Count } } | Out-UDChartData -DataProperty "Threads" -LabelProperty "Name"  
} -Options @{  
     legend = @{  
         display = $false  
     }  
   }
   # batons
  New-UdChart -Title "Espace disques" -Type Bar -AutoRefresh -Endpoint {
  Get-CimInstance -ClassName Win32_LogicalDisk -ComputerName logan.iemn.fr | ForEach-Object {
          [PSCustomObject]@{ DeviceId = $_.DeviceID;
                        Size = [Math]::Round($_.Size / 1GB, 2);
                        FreeSpace = [Math]::Round($_.FreeSpace / 1GB, 2); } } | Out-UDChartData -LabelProperty "DeviceID" -Dataset @(
       New-UdChartDataset -DataProperty "Size" -Label "Taille" -BackgroundColor "cornflowerblue" -HoverBackgroundColor "cornflowerblue"
       New-UdChartDataset -DataProperty "FreeSpace" -Label "Espace Libre" -BackgroundColor "lightgreen" -HoverBackgroundColor "lightgreen"
   )
}
###### fin charts 
 New-UdChart -Title "Consommateurs de mémoire" -Type Bar -Endpoint {
      Get-Process -ComputerName logan.iemn.fr | Get-Random -Count 10 |  Out-UDChartData -LabelProperty "Name" -Dataset @(
           $ds1 = New-UdChartDataset -DataProperty "VirtualMemorySize" -Label "Taille" -BackgroundColor "#80962F23" -HoverBackgroundColor "#80962F23" 
           $ds1.type = 'bar'
           $ds2 = New-UdChartDataset -DataProperty "PeakVirtualMemorySize" -Label "Espace libre" -BackgroundColor "#8014558C" -HoverBackgroundColor "#8014558C"
           $ds2.type = 'line'
           $ds1
           $ds2
       )
}
###### fin mémoire
New-UdGrid -Title "Process en cours" -Headers @("Nom", "Description") -Properties @("Name", "Description") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-CimInstance -ClassName Win32_Process -ComputerName logan.iemn.fr | Select Name,Description | Out-UDGridData
}####### fin Share
New-UdGrid -Title "Partages" -Headers @("Nom", "Description") -Properties @("Name", "Description") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-CimInstance -ClassName Win32_Share -ComputerName logan.iemn.fr | Select Name,Description | Out-UDGridData
}####### fin Share
New-UdGrid -Title "Services en cours" -Headers @("Nom", "Status", "Description") -Properties @("Name", "Status", "DisplayName") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-Service -ComputerName logan.iemn.fr | Where-Object {$_.Status -eq "Running"} | Select Name,Status,DisplayName | Out-UDGridData
}####### fin services
New-UdGrid -Title "Sessions connectées" -Headers @("Date", "Nom") -Properties @("TimeCreated", "Message") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-WinEvent  -ComputerName logan.iemn.fr -FilterHashTable @{ LogName = "Microsoft-Windows-TerminalServices-LocalSessionManager/Operational"; ID = 21,25 } -MaxEvents 5 | Select-Object -Property "TimeCreated","Message" -ExpandProperty message | Out-UDGridData
}####### fin 
New-UdGrid -Title "Sessions déconnectées" -Headers @("Date", "Nom") -Properties @("TimeCreated", "Message") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-WinEvent -ComputerName logan.iemn.fr -FilterHashTable @{ LogName = "Microsoft-Windows-TerminalServices-LocalSessionManager/Operational"; ID = 24,23 } -MaxEvents 5 | Select-Object -Property "TimeCreated","Message" -ExpandProperty message | Out-UDGridData
}####### fin eventsSessionDown
New-UdGrid -Title "Historique des mises à jour" -Headers @("Date", "Nom") -Properties @("TimeCreated", "Message") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-WinEvent -ComputerName logan.iemn.fr -FilterHashTable @{ LogName = "System"; ID = 43 } -MaxEvents 5 | Select-Object -Property "TimeCreated","Message" -ExpandProperty message | Out-UDGridData
}####### fin events maj
}####### fin udlayout

 }
 }### fin AD RODC 
 New-UDCollapsible -Items {
    New-UDCollapsibleItem -Title "Active Directory Slave (cooper)" -Icon vcard -Content {
   New-UDLayout -Columns 1 -Content { 
   ### temps CPU
   New-UdMonitor -Title "CPU (% processor time)" -Type Line -DataPointHistory 20 -RefreshInterval 5 -ChartBackgroundColor 'cornflowerblue' -ChartBorderColor 'lightgrey' -BackgroundColor "white" -FontColor "#88000000"  -Endpoint {
     Get-Counter '\processeur(_total)\% temps processeur' -ComputerName cooper.iemn.fr -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
}
   ### mem usage
   New-UdMonitor -Title "Mémoire (% mémoire utilisée)" -Type Line -DataPointHistory 20 -RefreshInterval 5  -ChartBackgroundColor 'cornflowerblue' -ChartBorderColor 'lightgrey' -BackgroundColor "white" -FontColor "#88000000" -Endpoint {
     Get-Counter "\mémoire\pourcentage d’octets dédiés utilisés" -ComputerName cooper.iemn.fr -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
}
   ### disk access
   New-UdMonitor -Title "Disque(s) (% activité du disque)" -Type Line -DataPointHistory 20 -RefreshInterval 5 -ChartBackgroundColor 'cornflowerblue' -ChartBorderColor 'lightgrey' -BackgroundColor "white" -FontColor "#88000000"  -Endpoint {
     Get-Counter "\disque physique(_total)\pourcentage du temps disque" -ComputerName cooper.iemn.fr -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
} 
    # processus en cours (circle)
    New-UDChart -Title "Poids par Processus" -Type Doughnut -RefreshInterval 5 -Endpoint {  
    Get-Process -ComputerName cooper.iemn.fr | ForEach-Object { [PSCustomObject]@{ Name = $_.Name; Threads = $_.Threads.Count } } | Out-UDChartData -DataProperty "Threads" -LabelProperty "Name"  
} -Options @{  
     legend = @{  
         display = $false  
     }  
   }
   # batons
  New-UdChart -Title "Espace disques" -Type Bar -AutoRefresh -Endpoint {
  Get-CimInstance -ClassName Win32_LogicalDisk -ComputerName cooper.iemn.fr | ForEach-Object {
          [PSCustomObject]@{ DeviceId = $_.DeviceID;
                        Size = [Math]::Round($_.Size / 1GB, 2);
                        FreeSpace = [Math]::Round($_.FreeSpace / 1GB, 2); } } | Out-UDChartData -LabelProperty "DeviceID" -Dataset @(
       New-UdChartDataset -DataProperty "Size" -Label "Taille" -BackgroundColor "cornflowerblue" -HoverBackgroundColor "cornflowerblue"
       New-UdChartDataset -DataProperty "FreeSpace" -Label "Espace Libre" -BackgroundColor "lightgreen" -HoverBackgroundColor "lightgreen"
   )
}
###### fin charts 
 New-UdChart -Title "Consommateurs de mémoire" -Type Bar -Endpoint {
      Get-Process -ComputerName cooper.iemn.fr | Get-Random -Count 10 |  Out-UDChartData -LabelProperty "Name" -Dataset @(
           $ds1 = New-UdChartDataset -DataProperty "VirtualMemorySize" -Label "Taille" -BackgroundColor "#80962F23" -HoverBackgroundColor "#80962F23" 
           $ds1.type = 'bar'
           $ds2 = New-UdChartDataset -DataProperty "PeakVirtualMemorySize" -Label "Espace libre" -BackgroundColor "#8014558C" -HoverBackgroundColor "#8014558C"
           $ds2.type = 'line'
           $ds1
           $ds2
       )
}
###### fin mémoire
New-UdChart -Title "Travaux d'impressions." -Type Bar -AutoRefresh -Endpoint {
  Get-CimInstance -ClassName Win32_PerfFormattedData_Spooler_PrintQueue -ComputerName cooper.iemn.fr | Out-UDChartData -LabelProperty "Name" -Dataset @(
       New-UdChartDataset -DataProperty "TotalJobsPrinted" -Label "Jobs Imprimés." -BackgroundColor "cornflowerblue" -HoverBackgroundColor "cornflowerblue"
       New-UdChartDataset -DataProperty "TotalPagesPrinted" -Label "Pages totales imprimées." -BackgroundColor "lightgreen" -HoverBackgroundColor "lightgreen"
       New-UdChartDataset -DataProperty "Jobs" -Label "Jobs en cours." -BackgroundColor "blue" -HoverBackgroundColor "blue"
       New-UdChartDataset -DataProperty "JobsErrors" -Label "Jobs en erreur." -BackgroundColor "brown" -HoverBackgroundColor "brown"
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
}###### fin charts impression.
New-UdGrid -Title "Process en cours" -Headers @("Nom", "Description") -Properties @("Name", "Description") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-CimInstance -ClassName Win32_Process -ComputerName cooper.iemn.fr | Select Name,Description | Out-UDGridData
}####### fin Share
New-UdGrid -Title "Partages" -Headers @("Nom", "Description") -Properties @("Name", "Description") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-CimInstance -ClassName Win32_Share -ComputerName cooper.iemn.fr | Select Name,Description | Out-UDGridData
}####### fin Share
New-UdGrid -Title "Services en cours" -Headers @("Nom", "Status", "Description") -Properties @("Name", "Status", "DisplayName") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-Service -ComputerName cooper.iemn.fr | Where-Object {$_.Status -eq "Running"} | Select Name,Status,DisplayName | Out-UDGridData
}####### fin services
New-UdGrid -Title "Sessions connectées" -Headers @("Date", "Nom") -Properties @("TimeCreated", "Message") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-WinEvent  -ComputerName cooper.iemn.fr -FilterHashTable @{ LogName = "Microsoft-Windows-TerminalServices-LocalSessionManager/Operational"; ID = 21,25 } -MaxEvents 5 | Select-Object -Property "TimeCreated","Message" -ExpandProperty message | Out-UDGridData
}####### fin 
New-UdGrid -Title "Sessions déconnectées" -Headers @("Date", "Nom") -Properties @("TimeCreated", "Message") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-WinEvent -ComputerName cooper.iemn.fr -FilterHashTable @{ LogName = "Microsoft-Windows-TerminalServices-LocalSessionManager/Operational"; ID = 24,23 } -MaxEvents 5 | Select-Object -Property "TimeCreated","Message" -ExpandProperty message | Out-UDGridData
}####### fin eventsSessionDown
New-UdGrid -Title "Historique des mises à jour" -Headers @("Date", "Nom") -Properties @("TimeCreated", "Message") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-WinEvent -ComputerName cooper.iemn.fr -FilterHashTable @{ LogName = "System"; ID = 43 } -MaxEvents 5 | Select-Object -Property "TimeCreated","Message" -ExpandProperty message | Out-UDGridData
}####### fin events maj
}####### fin udlayout

 }
 }### fin AD Slave
 New-UDCollapsible -Items {
    New-UDCollapsibleItem -Title "Gestionnaire d'applications (GYOA)" -Icon opencart -Content {
   New-UDLayout -Columns 1 -Content { 
   New-UdChart -Title "Espace disques" -Type Bar -AutoRefresh -Endpoint {
  Get-CimInstance -ClassName Win32_LogicalDisk -ComputerName wapt.iemn.fr | ForEach-Object {
          [PSCustomObject]@{ DeviceId = $_.DeviceID;
                        Size = [Math]::Round($_.Size / 1GB, 2);
                        FreeSpace = [Math]::Round($_.FreeSpace / 1GB, 2); } } | Out-UDChartData -LabelProperty "DeviceID" -Dataset @(
       New-UdChartDataset -DataProperty "Size" -Label "Taille" -BackgroundColor "cornflowerblue" -HoverBackgroundColor "cornflowerblue"
       New-UdChartDataset -DataProperty "FreeSpace" -Label "Espace Libre" -BackgroundColor "lightgreen" -HoverBackgroundColor "lightgreen"
   )
}
###### fin charts 
New-UdGrid -Title "Process en cours" -Headers @("Nom", "Description") -Properties @("Name", "Description") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-CimInstance -ClassName Win32_Process -ComputerName wapt.iemn.fr | Select Name,Description | Out-UDGridData
}####### fin Share
New-UdGrid -Title "Partages" -Headers @("Nom", "Description") -Properties @("Name", "Description") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-CimInstance -ClassName Win32_Share -ComputerName wapt.iemn.fr | Select Name,Description | Out-UDGridData
}####### fin Share
New-UdGrid -Title "Services en cours" -Headers @("Nom", "Status", "Description") -Properties @("Name", "Status", "DisplayName") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-Service -ComputerName wapt.iemn.fr | Where-Object {$_.Status -eq "Running"} | Select Name,Status,DisplayName | Out-UDGridData
}####### fin services
New-UdGrid -Title "Sessions connectées" -Headers @("Date", "Nom") -Properties @("TimeCreated", "Message") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-WinEvent  -ComputerName wapt.iemn.fr -FilterHashTable @{ LogName = "Microsoft-Windows-TerminalServices-LocalSessionManager/Operational"; ID = 21,25 } -MaxEvents 5 | Select-Object -Property "TimeCreated","Message" -ExpandProperty message | Out-UDGridData
}####### fin 
New-UdGrid -Title "Sessions déconnectées" -Headers @("Date", "Nom") -Properties @("TimeCreated", "Message") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-WinEvent -ComputerName wapt.iemn.fr -FilterHashTable @{ LogName = "Microsoft-Windows-TerminalServices-LocalSessionManager/Operational"; ID = 24,23 } -MaxEvents 5 | Select-Object -Property "TimeCreated","Message" -ExpandProperty message | Out-UDGridData
}####### fin eventsSessionDown
New-UdGrid -Title "Historique des mises à jour" -Headers @("Date", "Nom") -Properties @("TimeCreated", "Message") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-WinEvent -ComputerName wapt.iemn.fr -FilterHashTable @{ LogName = "System"; ID = 43 } -MaxEvents 5 | Select-Object -Property "TimeCreated","Message" -ExpandProperty message | Out-UDGridData
}####### fin events maj
}####### fin udlayout

 }
 }####fin Gestionnaire Applis (WapT)
 New-UDCollapsible -Items {
    New-UDCollapsibleItem -Title "Kaspersky Administration Security Center (Kasc)" -Icon shield -Content {
   New-UDLayout -Columns 1 -Content { 
       ### temps CPU
   New-UdMonitor -Title "CPU (% processor time)" -Type Line -DataPointHistory 20 -RefreshInterval 5 -ChartBackgroundColor 'cornflowerblue' -ChartBorderColor 'lightgrey' -BackgroundColor "white" -FontColor "#88000000"  -Endpoint {
     Get-Counter '\processeur(_total)\% temps processeur' -ComputerName kasc.iemn.fr -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
}
   ### mem usage
   New-UdMonitor -Title "Mémoire (% mémoire utilisée)" -Type Line -DataPointHistory 20 -RefreshInterval 5  -ChartBackgroundColor 'cornflowerblue' -ChartBorderColor 'lightgrey' -BackgroundColor "white" -FontColor "#88000000" -Endpoint {
     Get-Counter "\mémoire\pourcentage d’octets dédiés utilisés" -ComputerName kasc.iemn.fr -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
}
   ### disk access
   New-UdMonitor -Title "Disque(s) (% activité du disque)" -Type Line -DataPointHistory 20 -RefreshInterval 5 -ChartBackgroundColor 'cornflowerblue' -ChartBorderColor 'lightgrey' -BackgroundColor "white" -FontColor "#88000000"  -Endpoint {
     Get-Counter "\disque physique(_total)\pourcentage du temps disque" -ComputerName kasc.iemn.fr -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
}
    # processus en 
    # processus en cours (circle)
    New-UDChart -Title "Poids par Processus" -Type Doughnut -RefreshInterval 5 -Endpoint {  
    Get-Process -ComputerName kasc.iemn.fr | ForEach-Object { [PSCustomObject]@{ Name = $_.Name; Threads = $_.Threads.Count } } | Out-UDChartData -DataProperty "Threads" -LabelProperty "Name"  
} -Options @{  
     legend = @{  
         display = $false  
     }  
   }
   # batons
  New-UdChart -Title "Espace disques" -Type Bar -AutoRefresh -Endpoint {
  Get-CimInstance -ClassName Win32_LogicalDisk -ComputerName kasc.iemn.fr | ForEach-Object {
          [PSCustomObject]@{ DeviceId = $_.DeviceID;
                        Size = [Math]::Round($_.Size / 1GB, 2);
                        FreeSpace = [Math]::Round($_.FreeSpace / 1GB, 2); } } | Out-UDChartData -LabelProperty "DeviceID" -Dataset @(
       New-UdChartDataset -DataProperty "Size" -Label "Taille" -BackgroundColor "cornflowerblue" -HoverBackgroundColor "cornflowerblue"
       New-UdChartDataset -DataProperty "FreeSpace" -Label "Espace Libre" -BackgroundColor "lightgreen" -HoverBackgroundColor "lightgreen"
   )
}
###### fin charts 
 New-UdChart -Title "Consommateurs de mémoire" -Type Bar -Endpoint {
      Get-Process -ComputerName kasc.iemn.fr | Get-Random -Count 10 |  Out-UDChartData -LabelProperty "Name" -Dataset @(
           $ds1 = New-UdChartDataset -DataProperty "VirtualMemorySize" -Label "Taille" -BackgroundColor "#80962F23" -HoverBackgroundColor "#80962F23" 
           $ds1.type = 'bar'
           $ds2 = New-UdChartDataset -DataProperty "PeakVirtualMemorySize" -Label "Espace libre" -BackgroundColor "#8014558C" -HoverBackgroundColor "#8014558C"
           $ds2.type = 'line'
           $ds1
           $ds2
       )
}
###### fin mémoire
New-UdGrid -Title "Process en cours" -Headers @("Nom", "Description") -Properties @("Name", "Description") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-CimInstance -ClassName Win32_Process -ComputerName kasc.iemn.fr | Select Name,Description | Out-UDGridData
}####### fin Share
New-UdGrid -Title "Partages" -Headers @("Nom", "Description") -Properties @("Name", "Description") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-CimInstance -ClassName Win32_Share -ComputerName kasc.iemn.fr | Select Name,Description | Out-UDGridData
}####### fin Share
New-UdGrid -Title "Services en cours" -Headers @("Nom", "Status", "Description") -Properties @("Name", "Status", "DisplayName") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-Service -ComputerName kasc.iemn.fr | Where-Object {$_.Status -eq "Running"} | Select Name,Status,DisplayName | Out-UDGridData
}####### fin services
New-UdGrid -Title "Sessions connectées" -Headers @("Date", "Nom") -Properties @("TimeCreated", "Message") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-WinEvent  -ComputerName kasc.iemn.fr -FilterHashTable @{ LogName = "Microsoft-Windows-TerminalServices-LocalSessionManager/Operational"; ID = 21,25 } -MaxEvents 5 | Select-Object -Property "TimeCreated","Message" -ExpandProperty message | Out-UDGridData
}####### fin 
New-UdGrid -Title "Sessions déconnectées" -Headers @("Date", "Nom") -Properties @("TimeCreated", "Message") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-WinEvent -ComputerName kasc.iemn.fr -FilterHashTable @{ LogName = "Microsoft-Windows-TerminalServices-LocalSessionManager/Operational"; ID = 24,23 } -MaxEvents 5 | Select-Object -Property "TimeCreated","Message" -ExpandProperty message | Out-UDGridData
}####### fin eventsSessionDown
New-UdGrid -Title "Historique des mises à jour" -Headers @("Date", "Nom") -Properties @("TimeCreated", "Message") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-WinEvent -ComputerName kasc.iemn.fr -FilterHashTable @{ LogName = "System"; ID = 43 } -MaxEvents 5 | Select-Object -Property "TimeCreated","Message" -ExpandProperty message | Out-UDGridData
}####### fin events maj
}####### fin udlayout

 }
 }####fin Serveur Anti-Virus (Kaspersky)
 New-UDCollapsible -Items {
    New-UDCollapsibleItem -Title "Remote Desktop Server (RDS01)" -Icon desktop -Content {
   New-UDLayout -Columns 1 -Content { 
       ### temps CPU
   New-UdMonitor -Title "CPU (% processor time)" -Type Line -DataPointHistory 20 -RefreshInterval 5 -ChartBackgroundColor 'cornflowerblue' -ChartBorderColor 'lightgrey' -BackgroundColor "white" -FontColor "#88000000"  -Endpoint {
     Get-Counter '\processeur(_total)\% temps processeur' -ComputerName rds01.iemn.fr -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
}
   ### mem usage
   New-UdMonitor -Title "Mémoire (% mémoire utilisée)" -Type Line -DataPointHistory 20 -RefreshInterval 5  -ChartBackgroundColor 'cornflowerblue' -ChartBorderColor 'lightgrey' -BackgroundColor "white" -FontColor "#88000000" -Endpoint {
     Get-Counter "\mémoire\pourcentage d’octets dédiés utilisés" -ComputerName rds01.iemn.fr -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
}
   ### disk access
   New-UdMonitor -Title "Disque(s) (% activité du disque)" -Type Line -DataPointHistory 20 -RefreshInterval 5 -ChartBackgroundColor 'cornflowerblue' -ChartBorderColor 'lightgrey' -BackgroundColor "white" -FontColor "#88000000"  -Endpoint {
     Get-Counter "\disque physique(_total)\pourcentage du temps disque" -ComputerName rds01.iemn.fr -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
}
    # processus en 
    # processus en cours (circle)
    New-UDChart -Title "Poids par Processus" -Type Doughnut -RefreshInterval 5 -Endpoint {  
    Get-Process -ComputerName rds01.iemn.fr | ForEach-Object { [PSCustomObject]@{ Name = $_.Name; Threads = $_.Threads.Count } } | Out-UDChartData -DataProperty "Threads" -LabelProperty "Name"  
} -Options @{  
     legend = @{  
         display = $false  
     }  
   }
   # batons
  New-UdChart -Title "Espace disques" -Type Bar -AutoRefresh -Endpoint {
  Get-CimInstance -ClassName Win32_LogicalDisk -ComputerName rds01.iemn.fr | ForEach-Object {
          [PSCustomObject]@{ DeviceId = $_.DeviceID;
                        Size = [Math]::Round($_.Size / 1GB, 2);
                        FreeSpace = [Math]::Round($_.FreeSpace / 1GB, 2); } } | Out-UDChartData -LabelProperty "DeviceID" -Dataset @(
       New-UdChartDataset -DataProperty "Size" -Label "Taille" -BackgroundColor "cornflowerblue" -HoverBackgroundColor "cornflowerblue"
       New-UdChartDataset -DataProperty "FreeSpace" -Label "Espace Libre" -BackgroundColor "lightgreen" -HoverBackgroundColor "lightgreen"
   )
}
###### fin charts 
 New-UdChart -Title "Consommateurs de mémoire" -Type Bar -Endpoint {
      Get-Process -ComputerName rds01.iemn.fr | Get-Random -Count 10 |  Out-UDChartData -LabelProperty "Name" -Dataset @(
           $ds1 = New-UdChartDataset -DataProperty "VirtualMemorySize" -Label "Taille" -BackgroundColor "#80962F23" -HoverBackgroundColor "#80962F23" 
           $ds1.type = 'bar'
           $ds2 = New-UdChartDataset -DataProperty "PeakVirtualMemorySize" -Label "Espace libre" -BackgroundColor "#8014558C" -HoverBackgroundColor "#8014558C"
           $ds2.type = 'line'
           $ds1
           $ds2
       )
}
###### fin mémoire
  New-UdChart -Title "Nombre de séssions connectées." -Type Bar -AutoRefresh -Endpoint {
  Get-CimInstance -ClassName Win32_PerfFormattedData_LocalSessionManager_TerminalServices -ComputerName rds01.iemn.fr | Out-UDChartData -LabelProperty "PSComputerName" -Dataset @(
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
       Get-CimInstance -ClassName Win32_Process -ComputerName rds01.iemn.fr | Select Name,Description | Out-UDGridData
}####### fin Share
New-UdGrid -Title "Partages" -Headers @("Nom", "Description") -Properties @("Name", "Description") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-CimInstance -ClassName Win32_Share -ComputerName rds01.iemn.fr | Select Name,Description | Out-UDGridData
}####### fin Share
New-UdGrid -Title "Services en cours" -Headers @("Nom", "Status", "Description") -Properties @("Name", "Status", "DisplayName") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-Service -ComputerName rds01.iemn.fr | Where-Object {$_.Status -eq "Running"} | Select Name,Status,DisplayName | Out-UDGridData
}####### fin services
New-UdGrid -Title "Sessions connectées" -Headers @("Date", "Nom") -Properties @("TimeCreated", "Message") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-WinEvent  -ComputerName rds01.iemn.fr -FilterHashTable @{ LogName = "Microsoft-Windows-TerminalServices-LocalSessionManager/Operational"; ID = 21,25 } -MaxEvents 5 | Select-Object -Property "TimeCreated","Message" -ExpandProperty message | Out-UDGridData
}####### fin 
New-UdGrid -Title "Sessions déconnectées" -Headers @("Date", "Nom") -Properties @("TimeCreated", "Message") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-WinEvent -ComputerName rds01.iemn.fr -FilterHashTable @{ LogName = "Microsoft-Windows-TerminalServices-LocalSessionManager/Operational"; ID = 24,23 } -MaxEvents 5 | Select-Object -Property "TimeCreated","Message" -ExpandProperty message | Out-UDGridData
}####### fin eventsSessionDown
New-UdGrid -Title "Historique des mises à jour" -Headers @("Date", "Nom") -Properties @("TimeCreated", "Message") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-WinEvent -ComputerName rds01.iemn.fr -FilterHashTable @{ LogName = "System"; ID = 43 } -MaxEvents 5 | Select-Object -Property "TimeCreated","Message" -ExpandProperty message | Out-UDGridData
}####### fin events maj
}####### fin udlayout

 }
 }####fin Remote Desktop Serveur
 New-UDCollapsible -Items {
    New-UDCollapsibleItem -Title "Serveur d'impressions (iemn-printers)" -Icon print -Content {
   New-UDLayout -Columns 1 -Content { 
   New-UdMonitor -Title "CPU (% processor time)" -Type Line -DataPointHistory 20 -RefreshInterval 5 -ChartBackgroundColor 'cornflowerblue' -ChartBorderColor 'lightgrey' -BackgroundColor "white" -FontColor "#88000000"  -Endpoint {
     Get-Counter '\processeur(_total)\% temps processeur' -ComputerName iemn-printers.iemn.fr -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
}### cpu usage
   New-UdMonitor -Title "Mémoire (% mémoire utilisée)" -Type Line -DataPointHistory 20 -RefreshInterval 5  -ChartBackgroundColor 'cornflowerblue' -ChartBorderColor 'lightgrey' -BackgroundColor "white" -FontColor "#88000000" -Endpoint {
     Get-Counter "\mémoire\pourcentage d’octets dédiés utilisés" -ComputerName iemn-printers.iemn.fr -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
}### mem access
   New-UdMonitor -Title "Disque(s) (% activité du disque)" -Type Line -DataPointHistory 20 -RefreshInterval 5 -ChartBackgroundColor 'cornflowerblue' -ChartBorderColor 'lightgrey' -BackgroundColor "white" -FontColor "#88000000"  -Endpoint {
     Get-Counter "\disque physique(_total)\pourcentage du temps disque" -ComputerName iemn-printers.iemn.fr -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
}### disk access
   New-UDChart -Title "Poids par Processus" -Type Doughnut -RefreshInterval 5 -Endpoint {  
    Get-Process -ComputerName iemn-printers.iemn.fr | ForEach-Object { [PSCustomObject]@{ Name = $_.Name; Threads = $_.Threads.Count } } | Out-UDChartData -DataProperty "Threads" -LabelProperty "Name"  
} -Options @{  
     legend = @{  
         display = $false  
     }  
   }# processus en cours (circle)
New-UdChart -Title "Espace disques" -Type Bar -AutoRefresh -Endpoint {
  Get-CimInstance -ClassName Win32_LogicalDisk -ComputerName iemn-printers.iemn.fr | ForEach-Object {
          [PSCustomObject]@{ DeviceId = $_.DeviceID;
                        Size = [Math]::Round($_.Size / 1GB, 2);
                        FreeSpace = [Math]::Round($_.FreeSpace / 1GB, 2); } } | Out-UDChartData -LabelProperty "DeviceID" -Dataset @(
       New-UdChartDataset -DataProperty "Size" -Label "Taille" -BackgroundColor "cornflowerblue" -HoverBackgroundColor "cornflowerblue"
       New-UdChartDataset -DataProperty "FreeSpace" -Label "Espace Libre" -BackgroundColor "lightgreen" -HoverBackgroundColor "lightgreen"
   )
}###### fin chart disques 
New-UdChart -Title "Consommateurs de mémoire" -Type Bar -Endpoint {
      Get-Process -ComputerName iemn-printers.iemn.fr | Get-Random -Count 10 |  Out-UDChartData -LabelProperty "Name" -Dataset @(
           $ds1 = New-UdChartDataset -DataProperty "VirtualMemorySize" -Label "Taille" -BackgroundColor "#80962F23" -HoverBackgroundColor "#80962F23" 
           $ds1.type = 'bar'
           $ds2 = New-UdChartDataset -DataProperty "PeakVirtualMemorySize" -Label "Espace libre" -BackgroundColor "#8014558C" -HoverBackgroundColor "#8014558C"
           $ds2.type = 'line'
           $ds1
           $ds2
       )
}###### fin mémoire
New-UdChart -Title "Travaux d'impressions." -Type Bar -AutoRefresh -Endpoint {
  Get-CimInstance -ClassName Win32_PerfFormattedData_Spooler_PrintQueue -ComputerName iemn-printers.iemn.fr | Out-UDChartData -LabelProperty "Name" -Dataset @(
       New-UdChartDataset -DataProperty "TotalJobsPrinted" -Label "Jobs Imprimés." -BackgroundColor "cornflowerblue" -HoverBackgroundColor "cornflowerblue"
       New-UdChartDataset -DataProperty "TotalPagesPrinted" -Label "Pages totales imprimées." -BackgroundColor "lightgreen" -HoverBackgroundColor "lightgreen"
       New-UdChartDataset -DataProperty "Jobs" -Label "Jobs en cours." -BackgroundColor "blue" -HoverBackgroundColor "blue"
       New-UdChartDataset -DataProperty "JobsErrors" -Label "Jobs en erreur." -BackgroundColor "brown" -HoverBackgroundColor "brown"
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
}###### fin charts impression.
New-UdGrid -Title "Processus en cours" -Headers @("Nom", "Description") -Properties @("Name", "Description") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-CimInstance -ClassName Win32_Process -ComputerName iemn-printers.iemn.fr | Select Name,Description | Out-UDGridData
}####### fin process en cours
New-UdGrid -Title "Partages" -Headers @("Nom", "Description") -Properties @("Name", "Description") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-CimInstance -ClassName Win32_Share -ComputerName iemn-printers.iemn.fr | Select Name,Description | Out-UDGridData
}####### fin Sharefile
New-UdGrid -Title "Services en cours" -Headers @("Nom", "Status", "Description") -Properties @("Name", "Status", "DisplayName") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-Service -ComputerName iemn-printers.iemn.fr | Where-Object {$_.Status -eq "Running"} | Select Name,Status,DisplayName | Out-UDGridData
}####### fin services
New-UdGrid -Title "Sessions connectées" -Headers @("Date", "Nom") -Properties @("TimeCreated", "Message") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-WinEvent  -ComputerName iemn-printers.iemn.fr -FilterHashTable @{ LogName = "Microsoft-Windows-TerminalServices-LocalSessionManager/Operational"; ID = 21,25 } -MaxEvents 5 | Select-Object -Property "TimeCreated","Message" -ExpandProperty message | Out-UDGridData
}####### fin sessions connectés
New-UdGrid -Title "Sessions déconnectées" -Headers @("Date", "Nom") -Properties @("TimeCreated", "Message") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-WinEvent -ComputerName iemn-printers.iemn.fr -FilterHashTable @{ LogName = "Microsoft-Windows-TerminalServices-LocalSessionManager/Operational"; ID = 24,23 } -MaxEvents 5 | Select-Object -Property "TimeCreated","Message" -ExpandProperty message | Out-UDGridData
}####### fin eventsSessionDown
New-UdGrid -Title "Historique des mises à jour" -Headers @("Date", "Nom") -Properties @("TimeCreated", "Message") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-WinEvent -ComputerName iemn-printers.iemn.fr -FilterHashTable @{ LogName = "System"; ID = 43 } -MaxEvents 5 | Select-Object -Property "TimeCreated","Message" -ExpandProperty message | Out-UDGridData
}####### fin events maj
}####### fin udlayout
 }
 }####fin Printers
 New-UDCollapsible -Items {
   New-UDCollapsibleItem -Title "Hyperviseur Node1 (city)" -Icon windows -Content {
   New-UDLayout -Columns 1 -Content { 
   New-UdMonitor -Title "CPU (% processor time)" -Type Line -DataPointHistory 20 -RefreshInterval 5 -ChartBackgroundColor 'cornflowerblue' -ChartBorderColor 'lightgrey' -BackgroundColor "white" -FontColor "#88000000"  -Endpoint {
     Get-Counter '\processeur(_total)\% temps processeur' -ComputerName city.iemn.fr -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
}### temps CPU
   New-UdMonitor -Title "Mémoire (% mémoire utilisée)" -Type Line -DataPointHistory 20 -RefreshInterval 5  -ChartBackgroundColor 'cornflowerblue' -ChartBorderColor 'lightgrey' -BackgroundColor "white" -FontColor "#88000000" -Endpoint {
     Get-Counter "\mémoire\pourcentage d’octets dédiés utilisés" -ComputerName city.iemn.fr -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
}### memoire utilisée
   New-UdMonitor -Title "Disque(s) (% activité du disque)" -Type Line -DataPointHistory 20 -RefreshInterval 5 -ChartBackgroundColor 'cornflowerblue' -ChartBorderColor 'lightgrey' -BackgroundColor "white" -FontColor "#88000000"  -Endpoint {
     Get-Counter "\disque physique(_total)\pourcentage du temps disque" -ComputerName city.iemn.fr -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
}# Activité du disque
   New-UDChart -Title "Poids par Processus" -Type Doughnut -RefreshInterval 5 -Endpoint {  
    Get-Process -ComputerName city.iemn.fr | ForEach-Object { [PSCustomObject]@{ Name = $_.Name; Threads = $_.Threads.Count } } | Out-UDChartData -DataProperty "Threads" -LabelProperty "Name"  
} -Options @{  
     legend = @{  
         display = $false  
     }  
   }# Processus
  New-UdChart -Title "Espace disques" -Type Bar -AutoRefresh -Endpoint {
  Get-CimInstance -ClassName Win32_LogicalDisk -ComputerName city.iemn.fr | ForEach-Object {
          [PSCustomObject]@{ DeviceId = $_.DeviceID;
                        Size = [Math]::Round($_.Size / 1GB, 2);
                        FreeSpace = [Math]::Round($_.FreeSpace / 1GB, 2); } } | Out-UDChartData -LabelProperty "DeviceID" -Dataset @(
       New-UdChartDataset -DataProperty "Size" -Label "Taille" -BackgroundColor "cornflowerblue" -HoverBackgroundColor "cornflowerblue"
       New-UdChartDataset -DataProperty "FreeSpace" -Label "Espace Libre" -BackgroundColor "lightgreen" -HoverBackgroundColor "lightgreen"
   )
}###### fin charts disques
  New-UdChart -Title "Consommateurs de mémoire" -Type Bar -Endpoint {
      Get-Process -ComputerName city.iemn.fr | Get-Random -Count 10 |  Out-UDChartData -LabelProperty "Name" -Dataset @(
           $ds1 = New-UdChartDataset -DataProperty "VirtualMemorySize" -Label "Taille" -BackgroundColor "#80962F23" -HoverBackgroundColor "#80962F23" 
           $ds1.type = 'bar'
           $ds2 = New-UdChartDataset -DataProperty "PeakVirtualMemorySize" -Label "Espace libre" -BackgroundColor "#8014558C" -HoverBackgroundColor "#8014558C"
           $ds2.type = 'line'
           $ds1
           $ds2
       )
}###### fin mémoire
  New-UdChart -Title "Mémoire allouée par VMs." -Type Bar -AutoRefresh -Endpoint {
  Get-CimInstance -ClassName Win32_PerfFormattedData_BalancerStats_HyperVDynamicMemoryVM -ComputerName city.iemn.fr | ForEach-Object {
          [PSCustomObject]@{ Name = $_.Name;
                        PhysicalMemory = [Math]::Round($_.PhysicalMemory / 1KB, 2);
                        CurrentPressure = [Math]::Round($_.CurrentPressure / 1KB, 2);}} | Out-UDChartData -LabelProperty "Name" -Dataset @(
       New-UdChartDataset -DataProperty "PhysicalMemory" -Label "Gb." -BackgroundColor "cornflowerblue" -HoverBackgroundColor "cornflowerblue"
       New-UdChartDataset -DataProperty "CurrentPressure" -Label "Gb." -BackgroundColor "brick" -HoverBackgroundColor "brick"
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
}###### fin charts mémoire par vms.
  New-UdChart -Title "Nombre de séssions connectées." -Type Bar -AutoRefresh -Endpoint {
  Get-CimInstance -ClassName Win32_PerfFormattedData_LocalSessionManager_TerminalServices -ComputerName city.iemn.fr | Out-UDChartData -LabelProperty "PSComputerName" -Dataset @(
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
}###### fin charts séssions connectées
New-UdGrid -Title "Disque(s) VMs" -Headers @("Nom de VM", "I/O par sec.") -Properties @("Name", "WriteOperationsPerSec") -AutoRefresh -RefreshInterval 10 -Endpoint {
       Get-CimInstance -class Win32_PerfFormattedData_Counters_HyperVVirtualStorageDevice -ComputerName city.iemn.fr | Select Name,WriteOperationsPerSec | Where-Object {$_.Name -notlike "ISO*"} | Out-UDGridData
}####### fin hddvm
New-UdGrid -Title "Partages" -Headers @("Nom", "Description") -Properties @("Name", "Description") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-CimInstance -ClassName Win32_Share -ComputerName city.iemn.fr | Select Name,Description | Out-UDGridData
}####### fin Share
New-UdGrid -Title "Processus en cours" -Headers @("Nom", "Description") -Properties @("Name", "Description") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-CimInstance -ClassName Win32_Process -ComputerName city.iemn.fr | Select Name,Description | Out-UDGridData
}####### fin process
New-UdGrid -Title "Services en cours" -Headers @("Nom", "Status", "Description") -Properties @("Name", "Status", "DisplayName") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-Service -ComputerName city.iemn.fr | Where-Object {$_.Status -eq "Running"} | Select Name,Status,DisplayName | Out-UDGridData
}####### fin services 
New-UdGrid -Title "Connexions" -Headers @("Date", "Nom") -Properties @("TimeCreated", "Message") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-WinEvent  -ComputerName city.iemn.fr -FilterHashTable @{ LogName = "Microsoft-Windows-TerminalServices-LocalSessionManager/Operational"; ID = 21,25 } -MaxEvents 5 | Select-Object -Property "TimeCreated","Message" -ExpandProperty message| Sort-Object -Descending -Property "TimeCreated" | Out-UDGridData
}####### fin connexions
New-UdGrid -Title "Déconnexions" -Headers @("Date", "Nom") -Properties @("TimeCreated", "Message") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-WinEvent -ComputerName city.iemn.fr -FilterHashTable @{ LogName = "Microsoft-Windows-TerminalServices-LocalSessionManager/Operational"; ID = 24,23 } -MaxEvents 5 | Select-Object -Property "TimeCreated","Message" -ExpandProperty message| Sort-Object -Descending -Property "TimeCreated" | Out-UDGridData
}####### fin eventsSessionDown
New-UdGrid -Title "Historique des mises à jour" -Headers @("Date", "Nom") -Properties @("TimeCreated", "Message") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-WinEvent -ComputerName city.iemn.fr -FilterHashTable @{ LogName = "System"; ID = 43 } -MaxEvents 5 | Select-Object -Property "TimeCreated","Message" -ExpandProperty message | Sort-Object -Descending -Property "TimeCreated" | Out-UDGridData
}####### fin events maj
}####### fin udlayout
 }
 }####fin Hyper-V Node1
 New-UDCollapsible -Items {
   New-UDCollapsibleItem -Title "Hyperviseur Node2 (sin)" -Icon windows -Content {
   New-UDLayout -Columns 1 -Content { 
   New-UdMonitor -Title "CPU (% processor time)" -Type Line -DataPointHistory 20 -RefreshInterval 5 -ChartBackgroundColor 'cornflowerblue' -ChartBorderColor 'lightgrey' -BackgroundColor "white" -FontColor "#88000000"  -Endpoint {
     Get-Counter '\processeur(_total)\% temps processeur' -ComputerName sin.iemn.fr -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
}### temps CPU
   New-UdMonitor -Title "Mémoire (% mémoire utilisée)" -Type Line -DataPointHistory 20 -RefreshInterval 5  -ChartBackgroundColor 'cornflowerblue' -ChartBorderColor 'lightgrey' -BackgroundColor "white" -FontColor "#88000000" -Endpoint {
     Get-Counter "\mémoire\pourcentage d’octets dédiés utilisés" -ComputerName sin.iemn.fr -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
}### memoire utilisée
   New-UdMonitor -Title "Disque(s) (% activité du disque)" -Type Line -DataPointHistory 20 -RefreshInterval 5 -ChartBackgroundColor 'cornflowerblue' -ChartBorderColor 'lightgrey' -BackgroundColor "white" -FontColor "#88000000"  -Endpoint {
     Get-Counter "\disque physique(_total)\pourcentage du temps disque" -ComputerName sin.iemn.fr -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
}# Activité du disque
   New-UDChart -Title "Poids par Processus" -Type Doughnut -RefreshInterval 5 -Endpoint {  
    Get-Process -ComputerName sin.iemn.fr | ForEach-Object { [PSCustomObject]@{ Name = $_.Name; Threads = $_.Threads.Count } } | Out-UDChartData -DataProperty "Threads" -LabelProperty "Name"  
} -Options @{  
     legend = @{  
         display = $false  
     }  
   }# Processus
   New-UdChart -Title "Espace disques" -Type Bar -AutoRefresh -Endpoint {
  Get-CimInstance -ClassName Win32_LogicalDisk -ComputerName sin.iemn.fr | ForEach-Object {
          [PSCustomObject]@{ DeviceId = $_.DeviceID;
                        Size = [Math]::Round($_.Size / 1GB, 2);
                        FreeSpace = [Math]::Round($_.FreeSpace / 1GB, 2); } } | Out-UDChartData -LabelProperty "DeviceID" -Dataset @(
       New-UdChartDataset -DataProperty "Size" -Label "Taille" -BackgroundColor "cornflowerblue" -HoverBackgroundColor "cornflowerblue"
       New-UdChartDataset -DataProperty "FreeSpace" -Label "Espace Libre" -BackgroundColor "lightgreen" -HoverBackgroundColor "lightgreen"
   )
}###### fin charts disques
   New-UdChart -Title "Consommateurs de mémoire" -Type Bar -Endpoint {
      Get-Process -ComputerName sin.iemn.fr | Get-Random -Count 10 |  Out-UDChartData -LabelProperty "Name" -Dataset @(
           $ds1 = New-UdChartDataset -DataProperty "VirtualMemorySize" -Label "Taille" -BackgroundColor "#80962F23" -HoverBackgroundColor "#80962F23" 
           $ds1.type = 'bar'
           $ds2 = New-UdChartDataset -DataProperty "PeakVirtualMemorySize" -Label "Espace libre" -BackgroundColor "#8014558C" -HoverBackgroundColor "#8014558C"
           $ds2.type = 'line'
           $ds1
           $ds2
       )
}###### fin mémoire
   New-UdChart -Title "Mémoire allouée par VMs." -Type Bar -AutoRefresh -Endpoint {
  Get-CimInstance -ClassName Win32_PerfFormattedData_BalancerStats_HyperVDynamicMemoryVM -ComputerName sin.iemn.fr | ForEach-Object {
          [PSCustomObject]@{ Name = $_.Name;
                        PhysicalMemory = [Math]::Round($_.PhysicalMemory / 1KB, 2);
                        CurrentPressure = [Math]::Round($_.CurrentPressure / 1KB, 2);}} | Out-UDChartData -LabelProperty "Name" -Dataset @(
       New-UdChartDataset -DataProperty "PhysicalMemory" -Label "Gb." -BackgroundColor "cornflowerblue" -HoverBackgroundColor "cornflowerblue"
       New-UdChartDataset -DataProperty "CurrentPressure" -Label "Gb." -BackgroundColor "brick" -HoverBackgroundColor "brick"
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
}###### fin charts mémoire par vms.
New-UdChart -Title "Nombre de séssions connectées." -Type Bar -AutoRefresh -Endpoint {
  Get-CimInstance -ClassName Win32_PerfFormattedData_LocalSessionManager_TerminalServices -ComputerName sin.iemn.fr | Out-UDChartData -LabelProperty "PSComputerName" -Dataset @(
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
}###### fin charts séssions connectées
New-UdGrid -Title "Disque(s) VMs" -Headers @("Nom de VM", "I/O par sec.") -Properties @("Name", "WriteOperationsPerSec") -AutoRefresh -RefreshInterval 10 -Endpoint {
       Get-CimInstance -class Win32_PerfFormattedData_Counters_HyperVVirtualStorageDevice -ComputerName sin.iemn.fr | Select Name,WriteOperationsPerSec | Where-Object {$_.Name -notlike "ISO*"} | Out-UDGridData
}####### fin hddvm
New-UdGrid -Title "Partages" -Headers @("Nom", "Description") -Properties @("Name", "Description") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-CimInstance -ClassName Win32_Share -ComputerName sin.iemn.fr | Select Name,Description | Out-UDGridData
}####### fin Share
New-UdGrid -Title "Processus en cours" -Headers @("Nom", "Description") -Properties @("Name", "Description") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-CimInstance -ClassName Win32_Process -ComputerName sin.iemn.fr | Select Name,Description | Out-UDGridData
}####### fin process
New-UdGrid -Title "Services en cours" -Headers @("Nom", "Status", "Description") -Properties @("Name", "Status", "DisplayName") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-Service -ComputerName sin.iemn.fr | Where-Object {$_.Status -eq "Running"} | Select Name,Status,DisplayName | Out-UDGridData
}####### fin services 
New-UdGrid -Title "Connexions" -Headers @("Date", "Nom") -Properties @("TimeCreated", "Message") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-WinEvent  -ComputerName sin.iemn.fr -FilterHashTable @{ LogName = "Microsoft-Windows-TerminalServices-LocalSessionManager/Operational"; ID = 21,25 } -MaxEvents 5 | Select-Object -Property "TimeCreated","Message" -ExpandProperty message| Sort-Object -Descending -Property "TimeCreated" | Out-UDGridData
}####### fin connexions
New-UdGrid -Title "Déconnexions" -Headers @("Date", "Nom") -Properties @("TimeCreated", "Message") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-WinEvent -ComputerName sin.iemn.fr -FilterHashTable @{ LogName = "Microsoft-Windows-TerminalServices-LocalSessionManager/Operational"; ID = 24,23 } -MaxEvents 5 | Select-Object -Property "TimeCreated","Message" -ExpandProperty message| Sort-Object -Descending -Property "TimeCreated" | Out-UDGridData
}####### fin eventsSessionDown
New-UdGrid -Title "Historique des mises à jour" -Headers @("Date", "Nom") -Properties @("TimeCreated", "Message") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-WinEvent -ComputerName sin.iemn.fr -FilterHashTable @{ LogName = "System"; ID = 43 } -MaxEvents 5 | Select-Object -Property "TimeCreated","Message" -ExpandProperty message | Sort-Object -Descending -Property "TimeCreated" | Out-UDGridData
}####### fin events maj
}####### fin udlayout
 }
 }####fin Hyper-V Node2
 New-UDCollapsible -Items {
 New-UDCollapsibleItem -Title "Hyperviseur Node3 ($Node3)" -Icon windows -Content {
   New-UDLayout -Columns 1 -Content { 
    New-UdMonitor -Title "CPU (% processor time)" -Type Line -DataPointHistory 20 -RefreshInterval 5 -ChartBackgroundColor 'cornflowerblue' -ChartBorderColor 'lightgrey' -BackgroundColor "white" -FontColor "#88000000"  -Endpoint {
     Get-Counter '\processeur(_total)\% temps processeur' -ComputerName $Node3 -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
}### temps CPU
    New-UdMonitor -Title "Mémoire (% mémoire utilisée)" -Type Line -DataPointHistory 20 -RefreshInterval 5  -ChartBackgroundColor 'cornflowerblue' -ChartBorderColor 'lightgrey' -BackgroundColor "white" -FontColor "#88000000" -Endpoint {
     Get-Counter "\mémoire\pourcentage d’octets dédiés utilisés" -ComputerName $Node3 -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
}### memoire utilisée
    New-UdMonitor -Title "Disque(s) (% activité du disque)" -Type Line -DataPointHistory 20 -RefreshInterval 5 -ChartBackgroundColor 'cornflowerblue' -ChartBorderColor 'lightgrey' -BackgroundColor "white" -FontColor "#88000000"  -Endpoint {
     Get-Counter "\disque physique(_total)\pourcentage du temps disque" -ComputerName $Node3 -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
}# Activité du disque
    New-UDChart -Title "Poids par Processus" -Type Doughnut -RefreshInterval 5 -Endpoint {  
    Get-Process -ComputerName $Node3 | ForEach-Object { [PSCustomObject]@{ Name = $_.Name; Threads = $_.Threads.Count } } | Out-UDChartData -DataProperty "Threads" -LabelProperty "Name"  
} -Options @{  
     legend = @{  
         display = $false  
     }  
   }# Processus
    New-UdChart -Title "Espace disques" -Type Bar -AutoRefresh -Endpoint {
  Get-CimInstance -ClassName Win32_LogicalDisk -ComputerName $Node3 | ForEach-Object {
          [PSCustomObject]@{ DeviceId = $_.DeviceID;
                        Size = [Math]::Round($_.Size / 1GB, 2);
                        FreeSpace = [Math]::Round($_.FreeSpace / 1GB, 2); } } | Out-UDChartData -LabelProperty "DeviceID" -Dataset @(
       New-UdChartDataset -DataProperty "Size" -Label "Taille" -BackgroundColor "cornflowerblue" -HoverBackgroundColor "cornflowerblue"
       New-UdChartDataset -DataProperty "FreeSpace" -Label "Espace Libre" -BackgroundColor "lightgreen" -HoverBackgroundColor "lightgreen"
   )
}###### fin charts disques
    New-UdChart -Title "Consommateurs de mémoire" -Type Bar -Endpoint {
      Get-Process -ComputerName $Node3 | Get-Random -Count 10 |  Out-UDChartData -LabelProperty "Name" -Dataset @(
           $ds1 = New-UdChartDataset -DataProperty "VirtualMemorySize" -Label "Taille" -BackgroundColor "#80962F23" -HoverBackgroundColor "#80962F23" 
           $ds1.type = 'bar'
           $ds2 = New-UdChartDataset -DataProperty "PeakVirtualMemorySize" -Label "Espace libre" -BackgroundColor "#8014558C" -HoverBackgroundColor "#8014558C"
           $ds2.type = 'line'
           $ds1
           $ds2
       )
}###### fin mémoire
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
}###### fin charts séssions connectées
    New-UdGrid -Title "Partages" -Headers @("Nom", "Description") -Properties @("Name", "Description") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-CimInstance -ClassName Win32_Share -ComputerName $Node3 | Select Name,Description | Out-UDGridData
}####### fin Share
    New-UdGrid -Title "Processus en cours" -Headers @("Nom", "Description") -Properties @("Name", "Description") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-CimInstance -ClassName Win32_Process -ComputerName $Node3 | Select Name,Description | Out-UDGridData
}####### fin process
    New-UdGrid -Title "Services en cours" -Headers @("Nom", "Status", "Description") -Properties @("Name", "Status", "DisplayName") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-Service -ComputerName $Node3 | Where-Object {$_.Status -eq "Running"} | Select Name,Status,DisplayName | Out-UDGridData
}####### fin services 
    New-UdGrid -Title "Connexions" -Headers @("Date", "Nom") -Properties @("TimeCreated", "Message") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-WinEvent  -ComputerName $Node3 -FilterHashTable @{ LogName = "Microsoft-Windows-TerminalServices-LocalSessionManager/Operational"; ID = 21,25 } -MaxEvents 5 | Select-Object -Property "TimeCreated","Message" -ExpandProperty message| Sort-Object -Descending -Property "TimeCreated" | Out-UDGridData
}####### fin connexions
    New-UdGrid -Title "Déconnexions" -Headers @("Date", "Nom") -Properties @("TimeCreated", "Message") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-WinEvent -ComputerName $Node3 -FilterHashTable @{ LogName = "Microsoft-Windows-TerminalServices-LocalSessionManager/Operational"; ID = 24,23 } -MaxEvents 5 | Select-Object -Property "TimeCreated","Message" -ExpandProperty message| Sort-Object -Descending -Property "TimeCreated" | Out-UDGridData
}####### fin eventsSessionDown
    New-UdGrid -Title "Historique des mises à jour" -Headers @("Date", "Nom") -Properties @("TimeCreated", "Message") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-WinEvent -ComputerName $Node3 -FilterHashTable @{ LogName = "System"; ID = 43 } -MaxEvents 5 | Select-Object -Property "TimeCreated","Message" -ExpandProperty message | Sort-Object -Descending -Property "TimeCreated" | Out-UDGridData
}####### fin events maj
   }####### fin udlayout
  }
 }####fin Hyper-V Node3
 New-UDCollapsible -Items {
 New-UDCollapsibleItem -Title "Authorité de certification ($CA)" -Icon certificate -Content {
   New-UDLayout -Columns 1 -Content { 
    New-UdMonitor -Title "CPU (% processor time)" -Type Line -DataPointHistory 20 -RefreshInterval 5 -ChartBackgroundColor 'cornflowerblue' -ChartBorderColor 'lightgrey' -BackgroundColor "white" -FontColor "#88000000"  -Endpoint {
     Get-Counter '\processeur(_total)\% temps processeur' -ComputerName $CA -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
}### temps CPU
    New-UdMonitor -Title "Mémoire (% mémoire utilisée)" -Type Line -DataPointHistory 20 -RefreshInterval 5  -ChartBackgroundColor 'cornflowerblue' -ChartBorderColor 'lightgrey' -BackgroundColor "white" -FontColor "#88000000" -Endpoint {
     Get-Counter "\mémoire\pourcentage d’octets dédiés utilisés" -ComputerName $CA -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
}### memoire utilisée
    New-UdMonitor -Title "Disque(s) (% activité du disque)" -Type Line -DataPointHistory 20 -RefreshInterval 5 -ChartBackgroundColor 'cornflowerblue' -ChartBorderColor 'lightgrey' -BackgroundColor "white" -FontColor "#88000000"  -Endpoint {
     Get-Counter "\disque physique(_total)\pourcentage du temps disque" -ComputerName $CA -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
}# Activité du disque
    New-UDChart -Title "Poids par Processus" -Type Doughnut -RefreshInterval 5 -Endpoint {  
    Get-Process -ComputerName $CA | ForEach-Object { [PSCustomObject]@{ Name = $_.Name; Threads = $_.Threads.Count } } | Out-UDChartData -DataProperty "Threads" -LabelProperty "Name"  
} -Options @{  
     legend = @{  
         display = $false  
     }  
   }# Processus
    New-UdChart -Title "Espace disques" -Type Bar -AutoRefresh -Endpoint {
  Get-CimInstance -ClassName Win32_LogicalDisk -ComputerName $CA | ForEach-Object {
          [PSCustomObject]@{ DeviceId = $_.DeviceID;
                        Size = [Math]::Round($_.Size / 1GB, 2);
                        FreeSpace = [Math]::Round($_.FreeSpace / 1GB, 2); } } | Out-UDChartData -LabelProperty "DeviceID" -Dataset @(
       New-UdChartDataset -DataProperty "Size" -Label "Taille" -BackgroundColor "cornflowerblue" -HoverBackgroundColor "cornflowerblue"
       New-UdChartDataset -DataProperty "FreeSpace" -Label "Espace Libre" -BackgroundColor "lightgreen" -HoverBackgroundColor "lightgreen"
   )
}###### fin charts disques
    New-UdChart -Title "Consommateurs de mémoire" -Type Bar -Endpoint {
      Get-Process -ComputerName $CA | Get-Random -Count 10 |  Out-UDChartData -LabelProperty "Name" -Dataset @(
           $ds1 = New-UdChartDataset -DataProperty "VirtualMemorySize" -Label "Taille" -BackgroundColor "#80962F23" -HoverBackgroundColor "#80962F23" 
           $ds1.type = 'bar'
           $ds2 = New-UdChartDataset -DataProperty "PeakVirtualMemorySize" -Label "Espace libre" -BackgroundColor "#8014558C" -HoverBackgroundColor "#8014558C"
           $ds2.type = 'line'
           $ds1
           $ds2
       )
}###### fin mémoire
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
}###### fin charts séssions connectées
    New-UdGrid -Title "Partages" -Headers @("Nom", "Description") -Properties @("Name", "Description") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-CimInstance -ClassName Win32_Share -ComputerName $CA | Select Name,Description | Out-UDGridData
}####### fin Share
    New-UdGrid -Title "Processus en cours" -Headers @("Nom", "Description") -Properties @("Name", "Description") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-CimInstance -ClassName Win32_Process -ComputerName $CA | Select Name,Description | Out-UDGridData
}####### fin process
    New-UdGrid -Title "Services en cours" -Headers @("Nom", "Status", "Description") -Properties @("Name", "Status", "DisplayName") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-Service -ComputerName $CA | Where-Object {$_.Status -eq "Running"} | Select Name,Status,DisplayName | Out-UDGridData
}####### fin services 
    New-UdGrid -Title "Connexions" -Headers @("Date", "Nom") -Properties @("TimeCreated", "Message") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-WinEvent  -ComputerName $CA -FilterHashTable @{ LogName = "Microsoft-Windows-TerminalServices-LocalSessionManager/Operational"; ID = 21,25 } -MaxEvents 5 | Select-Object -Property "TimeCreated","Message" -ExpandProperty message| Sort-Object -Descending -Property "TimeCreated" | Out-UDGridData
}####### fin connexions
    New-UdGrid -Title "Déconnexions" -Headers @("Date", "Nom") -Properties @("TimeCreated", "Message") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-WinEvent -ComputerName $CA -FilterHashTable @{ LogName = "Microsoft-Windows-TerminalServices-LocalSessionManager/Operational"; ID = 24,23 } -MaxEvents 5 | Select-Object -Property "TimeCreated","Message" -ExpandProperty message| Sort-Object -Descending -Property "TimeCreated" | Out-UDGridData
}####### fin eventsSessionDown
    New-UdGrid -Title "Historique des mises à jour" -Headers @("Date", "Nom") -Properties @("TimeCreated", "Message") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-WinEvent -ComputerName $CA -FilterHashTable @{ LogName = "System"; ID = 43 } -MaxEvents 5 | Select-Object -Property "TimeCreated","Message" -ExpandProperty message | Sort-Object -Descending -Property "TimeCreated" | Out-UDGridData
}####### fin events maj
   }####### fin udlayout
  }
 }####fin Authorité de Certification
 New-UDCollapsible -Items {
 New-UDCollapsibleItem -Title "Windows Deployment Server ($WDS)" -Icon play -Content {
   New-UDLayout -Columns 1 -Content { 
    New-UdMonitor -Title "CPU (% processor time)" -Type Line -DataPointHistory 20 -RefreshInterval 5 -ChartBackgroundColor 'cornflowerblue' -ChartBorderColor 'lightgrey' -BackgroundColor "white" -FontColor "#88000000"  -Endpoint {
     Get-Counter '\processeur(_total)\% temps processeur' -ComputerName $WDS -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
}### temps CPU
    New-UdMonitor -Title "Mémoire (% mémoire utilisée)" -Type Line -DataPointHistory 20 -RefreshInterval 5  -ChartBackgroundColor 'cornflowerblue' -ChartBorderColor 'lightgrey' -BackgroundColor "white" -FontColor "#88000000" -Endpoint {
     Get-Counter "\mémoire\pourcentage d’octets dédiés utilisés" -ComputerName $WDS -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
}### memoire utilisée
    New-UdMonitor -Title "Disque(s) (% activité du disque)" -Type Line -DataPointHistory 20 -RefreshInterval 5 -ChartBackgroundColor 'cornflowerblue' -ChartBorderColor 'lightgrey' -BackgroundColor "white" -FontColor "#88000000"  -Endpoint {
     Get-Counter "\disque physique(_total)\pourcentage du temps disque" -ComputerName $WDS -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
}# Activité du disque
    New-UDChart -Title "Poids par Processus" -Type Doughnut -RefreshInterval 5 -Endpoint {  
    Get-Process -ComputerName $WDS | ForEach-Object { [PSCustomObject]@{ Name = $_.Name; Threads = $_.Threads.Count } } | Out-UDChartData -DataProperty "Threads" -LabelProperty "Name"  
} -Options @{  
     legend = @{  
         display = $false  
     }  
   }# Processus
    New-UdChart -Title "Espace disques" -Type Bar -AutoRefresh -Endpoint {
  Get-CimInstance -ClassName Win32_LogicalDisk -ComputerName $WDS | ForEach-Object {
          [PSCustomObject]@{ DeviceId = $_.DeviceID;
                        Size = [Math]::Round($_.Size / 1GB, 2);
                        FreeSpace = [Math]::Round($_.FreeSpace / 1GB, 2); } } | Out-UDChartData -LabelProperty "DeviceID" -Dataset @(
       New-UdChartDataset -DataProperty "Size" -Label "Taille" -BackgroundColor "cornflowerblue" -HoverBackgroundColor "cornflowerblue"
       New-UdChartDataset -DataProperty "FreeSpace" -Label "Espace Libre" -BackgroundColor "lightgreen" -HoverBackgroundColor "lightgreen"
   )
}###### fin charts disques
    New-UdChart -Title "Consommateurs de mémoire" -Type Bar -Endpoint {
      Get-Process -ComputerName $WDS | Get-Random -Count 10 |  Out-UDChartData -LabelProperty "Name" -Dataset @(
           $ds1 = New-UdChartDataset -DataProperty "VirtualMemorySize" -Label "Taille" -BackgroundColor "#80962F23" -HoverBackgroundColor "#80962F23" 
           $ds1.type = 'bar'
           $ds2 = New-UdChartDataset -DataProperty "PeakVirtualMemorySize" -Label "Espace libre" -BackgroundColor "#8014558C" -HoverBackgroundColor "#8014558C"
           $ds2.type = 'line'
           $ds1
           $ds2
       )
}###### fin mémoire
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
}###### fin charts séssions connectées
    New-UdGrid -Title "Partages" -Headers @("Nom", "Description") -Properties @("Name", "Description") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-CimInstance -ClassName Win32_Share -ComputerName $WDS | Select Name,Description | Out-UDGridData
}####### fin Share
    New-UdGrid -Title "Processus en cours" -Headers @("Nom", "Description") -Properties @("Name", "Description") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-CimInstance -ClassName Win32_Process -ComputerName $WDS | Select Name,Description | Out-UDGridData
}####### fin process
    New-UdGrid -Title "Services en cours" -Headers @("Nom", "Status", "Description") -Properties @("Name", "Status", "DisplayName") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-Service -ComputerName $WDS | Where-Object {$_.Status -eq "Running"} | Select Name,Status,DisplayName | Out-UDGridData
}####### fin services 
    New-UdGrid -Title "Connexions" -Headers @("Date", "Nom") -Properties @("TimeCreated", "Message") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-WinEvent  -ComputerName $WDS -FilterHashTable @{ LogName = "Microsoft-Windows-TerminalServices-LocalSessionManager/Operational"; ID = 21,25 } -MaxEvents 5 | Select-Object -Property "TimeCreated","Message" -ExpandProperty message| Sort-Object -Descending -Property "TimeCreated" | Out-UDGridData
}####### fin connexions
    New-UdGrid -Title "Déconnexions" -Headers @("Date", "Nom") -Properties @("TimeCreated", "Message") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-WinEvent -ComputerName $WDS -FilterHashTable @{ LogName = "Microsoft-Windows-TerminalServices-LocalSessionManager/Operational"; ID = 24,23 } -MaxEvents 5 | Select-Object -Property "TimeCreated","Message" -ExpandProperty message| Sort-Object -Descending -Property "TimeCreated" | Out-UDGridData
}####### fin eventsSessionDown
    New-UdGrid -Title "Historique des mises à jour" -Headers @("Date", "Nom") -Properties @("TimeCreated", "Message") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-WinEvent -ComputerName $WDS -FilterHashTable @{ LogName = "System"; ID = 43 } -MaxEvents 5 | Select-Object -Property "TimeCreated","Message" -ExpandProperty message | Sort-Object -Descending -Property "TimeCreated" | Out-UDGridData
}####### fin events maj
   }####### fin udlayout
  }
 }####fin WDS
 New-UDCollapsible -Items {
 New-UDCollapsibleItem -Title "Windows Server Update Services ($WSUS)" -Icon star -Content {
   New-UDLayout -Columns 1 -Content { 
    New-UdMonitor -Title "CPU (% processor time)" -Type Line -DataPointHistory 20 -RefreshInterval 5 -ChartBackgroundColor 'cornflowerblue' -ChartBorderColor 'lightgrey' -BackgroundColor "white" -FontColor "#88000000"  -Endpoint {
     Get-Counter '\processeur(_total)\% temps processeur' -ComputerName $WSUS -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
}### temps CPU
    New-UdMonitor -Title "Mémoire (% mémoire utilisée)" -Type Line -DataPointHistory 20 -RefreshInterval 5  -ChartBackgroundColor 'cornflowerblue' -ChartBorderColor 'lightgrey' -BackgroundColor "white" -FontColor "#88000000" -Endpoint {
     Get-Counter "\mémoire\pourcentage d’octets dédiés utilisés" -ComputerName $WSUS -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
}### memoire utilisée
    New-UdMonitor -Title "Disque(s) (% activité du disque)" -Type Line -DataPointHistory 20 -RefreshInterval 5 -ChartBackgroundColor 'cornflowerblue' -ChartBorderColor 'lightgrey' -BackgroundColor "white" -FontColor "#88000000"  -Endpoint {
     Get-Counter "\disque physique(_total)\pourcentage du temps disque" -ComputerName $WSUS -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
}# Activité du disque
    New-UDChart -Title "Poids par Processus" -Type Doughnut -RefreshInterval 5 -Endpoint {  
    Get-Process -ComputerName $WSUS | ForEach-Object { [PSCustomObject]@{ Name = $_.Name; Threads = $_.Threads.Count } } | Out-UDChartData -DataProperty "Threads" -LabelProperty "Name"  
} -Options @{  
     legend = @{  
         display = $false  
     }  
   }# Processus
    New-UdChart -Title "Espace disques" -Type Bar -AutoRefresh -Endpoint {
  Get-CimInstance -ClassName Win32_LogicalDisk -ComputerName $WSUS | ForEach-Object {
          [PSCustomObject]@{ DeviceId = $_.DeviceID;
                        Size = [Math]::Round($_.Size / 1GB, 2);
                        FreeSpace = [Math]::Round($_.FreeSpace / 1GB, 2); } } | Out-UDChartData -LabelProperty "DeviceID" -Dataset @(
       New-UdChartDataset -DataProperty "Size" -Label "Taille" -BackgroundColor "cornflowerblue" -HoverBackgroundColor "cornflowerblue"
       New-UdChartDataset -DataProperty "FreeSpace" -Label "Espace Libre" -BackgroundColor "lightgreen" -HoverBackgroundColor "lightgreen"
   )
}###### fin charts disques
    New-UdChart -Title "Consommateurs de mémoire" -Type Bar -Endpoint {
      Get-Process -ComputerName $WSUS | Get-Random -Count 10 |  Out-UDChartData -LabelProperty "Name" -Dataset @(
           $ds1 = New-UdChartDataset -DataProperty "VirtualMemorySize" -Label "Taille" -BackgroundColor "#80962F23" -HoverBackgroundColor "#80962F23" 
           $ds1.type = 'bar'
           $ds2 = New-UdChartDataset -DataProperty "PeakVirtualMemorySize" -Label "Espace libre" -BackgroundColor "#8014558C" -HoverBackgroundColor "#8014558C"
           $ds2.type = 'line'
           $ds1
           $ds2
       )
}###### fin mémoire
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
}###### fin charts séssions connectées
    New-UdGrid -Title "Partages" -Headers @("Nom", "Description") -Properties @("Name", "Description") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-CimInstance -ClassName Win32_Share -ComputerName $WSUS | Select Name,Description | Out-UDGridData
}####### fin Share
    New-UdGrid -Title "Processus en cours" -Headers @("Nom", "Description") -Properties @("Name", "Description") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-CimInstance -ClassName Win32_Process -ComputerName $WSUS | Select Name,Description | Out-UDGridData
}####### fin process
    New-UdGrid -Title "Services en cours" -Headers @("Nom", "Status", "Description") -Properties @("Name", "Status", "DisplayName") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-Service -ComputerName $WSUS | Where-Object {$_.Status -eq "Running"} | Select Name,Status,DisplayName | Out-UDGridData
}####### fin services 
    New-UdGrid -Title "Connexions" -Headers @("Date", "Nom") -Properties @("TimeCreated", "Message") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-WinEvent  -ComputerName $WSUS -FilterHashTable @{ LogName = "Microsoft-Windows-TerminalServices-LocalSessionManager/Operational"; ID = 21,25 } -MaxEvents 5 | Select-Object -Property "TimeCreated","Message" -ExpandProperty message| Sort-Object -Descending -Property "TimeCreated" | Out-UDGridData
}####### fin connexions
    New-UdGrid -Title "Déconnexions" -Headers @("Date", "Nom") -Properties @("TimeCreated", "Message") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-WinEvent -ComputerName $WSUS -FilterHashTable @{ LogName = "Microsoft-Windows-TerminalServices-LocalSessionManager/Operational"; ID = 24,23 } -MaxEvents 5 | Select-Object -Property "TimeCreated","Message" -ExpandProperty message| Sort-Object -Descending -Property "TimeCreated" | Out-UDGridData
}####### fin eventsSessionDown
    New-UdGrid -Title "Historique des mises à jour" -Headers @("Date", "Nom") -Properties @("TimeCreated", "Message") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-WinEvent -ComputerName $WSUS -FilterHashTable @{ LogName = "System"; ID = 43 } -MaxEvents 5 | Select-Object -Property "TimeCreated","Message" -ExpandProperty message | Sort-Object -Descending -Property "TimeCreated" | Out-UDGridData
}####### fin events maj
   }####### fin udlayout
  }
 }####fin WSUS
} # Contenu de la dashboard
​
Start-UDDashboard -Port 8080 -Dashboard $iemn_dashboard -AutoReload # Je lance la tâche sur le port 8080 avec le nom de variable ci-dessus avec l'option d'actualisation des datas.
Start-Sleep -Seconds 3590 # Je lance un pause pour 59min 50secs
Get-UDDashboard | Stop-UDDashboard #je kill l'instance pour laisser place à la future (cronjob) [contournement de la limite de 1h d'utilisation].