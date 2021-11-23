
 # SharePoint PS Remote Session /// PoshMod pas fan //

$s=new-PSsession -ComputerName $intranet -Name "ps_session_SP"
 #Set-PSSessionConfiguration -Name Microsoft.PowerShell32 –ShowSecurityDescriptorUI
 Invoke-Command -Session $s -ScriptBlock {Add-PSSnapin Microsoft.SharePoint.PowerShell;}
 New-UDCollapsible -Items {
    New-UDCollapsibleItem -Title "Sharepoint ($intranet)" -Icon cloud -Content {
   New-UDLayout -Columns 1 -Content { 
#   New-UdMonitor -Title "CPU (% processor time)" -Type Line -DataPointHistory 20 -RefreshInterval 5 -ChartBackgroundColor 'cornflowerblue' -ChartBorderColor 'lightgrey' -BackgroundColor "white" -FontColor "#88000000"  -Endpoint {
#     Get-Counter '\processeur(_total)\% temps processeur' -ComputerName $intranet -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
#} ### mem usage
#   New-UdMonitor -Title "Mémoire (% mémoire utilisée)" -Type Line -DataPointHistory 20 -RefreshInterval 5  -ChartBackgroundColor 'cornflowerblue' -ChartBorderColor 'lightgrey' -BackgroundColor "white" -FontColor "#88000000" -Endpoint {
#     Get-Counter "\mémoire\pourcentage d’octets dédiés utilisés" -ComputerName $intranet -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
#}### disk access
#   New-UdMonitor -Title "Disque(s) (% activité du disque)" -Type Line -DataPointHistory 20 -RefreshInterval 5 -ChartBackgroundColor 'cornflowerblue' -ChartBorderColor 'lightgrey' -BackgroundColor "white" -FontColor "#88000000"  -Endpoint {
#     Get-Counter "\disque physique(_total)\pourcentage du temps disque" -ComputerName $intranet -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue | Out-UDMonitorData
#}# processus en cours (circle)
#    New-UDChart -Title "Poids par Processus" -Type Doughnut -RefreshInterval 5 -Endpoint {  
#    Get-Process -ComputerName $intranet | ForEach-Object { [PSCustomObject]@{ Name = $_.Name; Threads = $_.Threads.Count } } | Out-UDChartData -DataProperty "Threads" -LabelProperty "Name"  
#} -Options @{  
#     legend = @{  
#         display = $false  
#     }  
#   }# batons
#  New-UdChart -Title "Espace disques" -Type Bar -AutoRefresh -Endpoint {
#  Get-CimInstance -ClassName Win32_LogicalDisk -ComputerName sharepoint.iemn.fr | ForEach-Object {
#          [PSCustomObject]@{ DeviceId = $_.DeviceID;
#                        Size = [Math]::Round($_.Size / 1GB, 2);
#                        FreeSpace = [Math]::Round($_.FreeSpace / 1GB, 2); } } | Out-UDChartData -LabelProperty "DeviceID" -Dataset @(
#       New-UdChartDataset -DataProperty "Size" -Label "Taille" -BackgroundColor "cornflowerblue" -HoverBackgroundColor "cornflowerblue"
#       New-UdChartDataset -DataProperty "FreeSpace" -Label "Espace Libre" -BackgroundColor "lightgreen" -HoverBackgroundColor "lightgreen"
#   )
#}###### fin charts 
 New-UdChart -Title "Consommateurs de mémoire" -Type Bar -Endpoint {
      Get-Process -ComputerName $intranet | Get-Random -Count 10 |  Out-UDChartData -LabelProperty "Name" -Dataset @(
           $ds1 = New-UdChartDataset -DataProperty "VirtualMemorySize" -Label "Taille" -BackgroundColor "#80962F23" -HoverBackgroundColor "#80962F23" 
           $ds1.type = 'bar'
           $ds2 = New-UdChartDataset -DataProperty "PeakVirtualMemorySize" -Label "Espace libre" -BackgroundColor "#8014558C" -HoverBackgroundColor "#8014558C"
           $ds2.type = 'line'
           $ds1
           $ds2
       )
}###### fin mémoire
New-UdGrid -Title "Sites SharePoint" -Headers @("Url") -Properties @("Url") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Invoke-Command -Session $s -ScriptBlock {Get-SPSite} | Select Url | Out-UDGridData
}####### fin liste de sites
$s=new-PSsession -ComputerName $intranet -Name "ps_session_SP"
 Invoke-Command -Session $s -ScriptBlock {Add-PSSnapin Microsoft.SharePoint.PowerShell;}
New-UdGrid -Title "Public Url" -Headers @("Public Url") -Properties @("PublicUrl") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Invoke-Command -Session $s -ScriptBlock {Get-SPAlternateURL -WebApplication https://intranet.iemn.fr} | Select PublicUrl | Out-UDGridData
}####### fin liste des Url Public
$s=new-PSsession -ComputerName $intranet -Name "ps_session_SP"
 Invoke-Command -Session $s -ScriptBlock {Add-PSSnapin Microsoft.SharePoint.PowerShell;}
New-UdGrid -Title "Noms des services SharePoint" -Headers @("TypeName") -Properties @("TypeName") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Invoke-Command -Session $s -ScriptBlock {Get-SPService} | Select TypeName | Out-UDGridData
}####### fin liste des services SP
#$s=new-PSsession -ComputerName $intranet -Name "ps_session_SP"
# Invoke-Command -Session $s -ScriptBlock {Add-PSSnapin Microsoft.SharePoint.PowerShell;}
#New-UdGrid -Title "Noms des applications SharePoint IEMN" -Headers @("DisplayName","TypeName") -Properties @("DisplayName","TypeName") -AutoRefresh -RefreshInterval 60 -Endpoint {
#       Invoke-Command -Session $s -ScriptBlock {Get-SPService} | Select TypeName,DisplayName | Out-UDGridData
}####### fin liste des application SP
New-UdGrid -Title "Processus en cours" -Headers @("Nom", "Description") -Properties @("Name", "Description") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-CimInstance -ClassName Win32_Process -ComputerName $intranet | Select Name,Description | Out-UDGridData
}####### fin Process
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
 }####fin SharePoint