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
$wapt = "gyoa.iemn.fr" #wapt
$kaspersky = "kasc.iemn.fr" # Serveur KES
$urbackup = "ares.iemn.fr" # serveur urbackup
$filer1 = "homes.iemn.fr" # filer n°1
$filer2 = "clust-file01.iemn.fr" # filer n°2
$caracserver = "hado.carac.iemn.fr" # server carac
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
Import-Module -Name ADAuth
Import-Module ActiveDirectory
#fonctions
#colors
$css = "style.css"
#font
$fontcolor = '#FFF'
#fond
$wallcolor = '#333'
$bgcolor = '#333'
#Dash
$titre = "DYWA - Delegate Your Windows Administration"
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
  UDInput = @{
      backgroundColor = "rgb(51,51,51)" 
  }
  UDInputField = @{
      backgroundColor = "rgb(51,51,51)"
  }
  '.btn, .btn-large' = @{
      background = 'cornflowerblue'
  }
  '.btn:hover, .btn-large:hover' = @{
      background = '#ccc'
      color = '#333'
  }
  '.ud-counter' = @{
      'border-top-left-radius' = '10px'
  }
  '.card .card-action a:not(.btn):not(.btn-large):not(.btn-large):not(.btn-floating)' = @{
	   'color' = '#33B2E7 !important'
   }
  'html' = @{
	   'font-family' = 'helvetica, helvetica Neue, Arial, sans-serif !important'
   }
  'div#vim1_ping,div#vim2_ping,div#vim3_ping,div#vim4_ping,div#vim5_ping,div#cooper_ping,div#sin_ping,div#city_ping,div#marv_ping,div#cerberus_ping,div#kraken_ping,div#albator_ping,div#kraken2_ping,div#eliott_ping,div#xivo_ping,div#internet_ping' = @{
	   'color' = 'lightgreen !important'
   }
  'div#vim1_ping_down,div#vim2_ping_down,div#vim3_ping_down,div#vim4_ping_down,div#vim5_ping_down,div#cooper_ping_down,#sin_ping_down,div#city_ping_down,div#marv_ping_down,div#cerberus_ping_down,div#kraken_ping_down,div#albator_ping_down,div#kraken2_ping_down,div#eliott_ping_down,div#xivo_ping_down,div#internet_ping_down' = @{
	   'color' = 'red !important'
   }
}
$bienvenue = "Delegate Your Windows Administration"
$logologin = New-UDImage -Height 125 -Width 125 -Url "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAFEAAABSCAYAAAAsGziYAAAACXBIWXMAAAsTAAALEwEAmpwYAAA7T2lUWHRYTUw6Y29tLmFkb2JlLnhtcAAAAAAAPD94cGFja2V0IGJlZ2luPSLvu78iIGlkPSJXNU0wTXBDZWhpSHpyZVN6TlRjemtjOWQiPz4KPHg6eG1wbWV0YSB4bWxuczp4PSJhZG9iZTpuczptZXRhLyIgeDp4bXB0az0iQWRvYmUgWE1QIENvcmUgNS41LWMwMjEgNzkuMTU0OTExLCAyMDEzLzEwLzI5LTExOjQ3OjE2ICAgICAgICAiPgogICA8cmRmOlJERiB4bWxuczpyZGY9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkvMDIvMjItcmRmLXN5bnRheC1ucyMiPgogICAgICA8cmRmOkRlc2NyaXB0aW9uIHJkZjphYm91dD0iIgogICAgICAgICAgICB4bWxuczp4bXBNTT0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL21tLyIKICAgICAgICAgICAgeG1sbnM6c3RSZWY9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9zVHlwZS9SZXNvdXJjZVJlZiMiCiAgICAgICAgICAgIHhtbG5zOnN0RXZ0PSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VFdmVudCMiCiAgICAgICAgICAgIHhtbG5zOnhtcD0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wLyIKICAgICAgICAgICAgeG1sbnM6ZGM9Imh0dHA6Ly9wdXJsLm9yZy9kYy9lbGVtZW50cy8xLjEvIgogICAgICAgICAgICB4bWxuczpwaG90b3Nob3A9Imh0dHA6Ly9ucy5hZG9iZS5jb20vcGhvdG9zaG9wLzEuMC8iCiAgICAgICAgICAgIHhtbG5zOnRpZmY9Imh0dHA6Ly9ucy5hZG9iZS5jb20vdGlmZi8xLjAvIgogICAgICAgICAgICB4bWxuczpleGlmPSJodHRwOi8vbnMuYWRvYmUuY29tL2V4aWYvMS4wLyI+CiAgICAgICAgIDx4bXBNTTpPcmlnaW5hbERvY3VtZW50SUQ+eG1wLmRpZDowMTgwMTE3NDA3MjA2ODExQTJEMENGNkE0QjlFMjdDMzwveG1wTU06T3JpZ2luYWxEb2N1bWVudElEPgogICAgICAgICA8eG1wTU06RG9jdW1lbnRJRD54bXAuZGlkOjE4OEMwREVBNjZBRTExRTFBNUIxRkZGQ0QxQjIzMENEPC94bXBNTTpEb2N1bWVudElEPgogICAgICAgICA8eG1wTU06SW5zdGFuY2VJRD54bXAuaWlkOjE4MjIyMzhjLTg0MDYtNDkyYS05ODRhLWY2ZGJhNWVmY2ZmODwveG1wTU06SW5zdGFuY2VJRD4KICAgICAgICAgPHhtcE1NOkRlcml2ZWRGcm9tIHJkZjpwYXJzZVR5cGU9IlJlc291cmNlIj4KICAgICAgICAgICAgPHN0UmVmOmluc3RhbmNlSUQ+eG1wLmlpZDowMTgwMTE3NDA3MjA2ODExQTJEMENGNkE0QjlFMjdDMzwvc3RSZWY6aW5zdGFuY2VJRD4KICAgICAgICAgICAgPHN0UmVmOmRvY3VtZW50SUQ+eG1wLmRpZDowMTgwMTE3NDA3MjA2ODExQTJEMENGNkE0QjlFMjdDMzwvc3RSZWY6ZG9jdW1lbnRJRD4KICAgICAgICAgPC94bXBNTTpEZXJpdmVkRnJvbT4KICAgICAgICAgPHhtcE1NOkhpc3Rvcnk+CiAgICAgICAgICAgIDxyZGY6U2VxPgogICAgICAgICAgICAgICA8cmRmOmxpIHJkZjpwYXJzZVR5cGU9IlJlc291cmNlIj4KICAgICAgICAgICAgICAgICAgPHN0RXZ0OmFjdGlvbj5zYXZlZDwvc3RFdnQ6YWN0aW9uPgogICAgICAgICAgICAgICAgICA8c3RFdnQ6aW5zdGFuY2VJRD54bXAuaWlkOmQ5Nzk0N2Q3LWZkYTctNDI1Yy1iOGViLTM0NzIxNzYwNDZmMzwvc3RFdnQ6aW5zdGFuY2VJRD4KICAgICAgICAgICAgICAgICAgPHN0RXZ0OndoZW4+MjAxOC0xMC0wMlQwNzo0OTo0NiswMjowMDwvc3RFdnQ6d2hlbj4KICAgICAgICAgICAgICAgICAgPHN0RXZ0OnNvZnR3YXJlQWdlbnQ+QWRvYmUgUGhvdG9zaG9wIENDIChNYWNpbnRvc2gpPC9zdEV2dDpzb2Z0d2FyZUFnZW50PgogICAgICAgICAgICAgICAgICA8c3RFdnQ6Y2hhbmdlZD4vPC9zdEV2dDpjaGFuZ2VkPgogICAgICAgICAgICAgICA8L3JkZjpsaT4KICAgICAgICAgICAgICAgPHJkZjpsaSByZGY6cGFyc2VUeXBlPSJSZXNvdXJjZSI+CiAgICAgICAgICAgICAgICAgIDxzdEV2dDphY3Rpb24+c2F2ZWQ8L3N0RXZ0OmFjdGlvbj4KICAgICAgICAgICAgICAgICAgPHN0RXZ0Omluc3RhbmNlSUQ+eG1wLmlpZDoxODIyMjM4Yy04NDA2LTQ5MmEtOTg0YS1mNmRiYTVlZmNmZjg8L3N0RXZ0Omluc3RhbmNlSUQ+CiAgICAgICAgICAgICAgICAgIDxzdEV2dDp3aGVuPjIwMTgtMTAtMDJUMDc6NDk6NTUrMDI6MDA8L3N0RXZ0OndoZW4+CiAgICAgICAgICAgICAgICAgIDxzdEV2dDpzb2Z0d2FyZUFnZW50PkFkb2JlIFBob3Rvc2hvcCBDQyAoTWFjaW50b3NoKTwvc3RFdnQ6c29mdHdhcmVBZ2VudD4KICAgICAgICAgICAgICAgICAgPHN0RXZ0OmNoYW5nZWQ+Lzwvc3RFdnQ6Y2hhbmdlZD4KICAgICAgICAgICAgICAgPC9yZGY6bGk+CiAgICAgICAgICAgIDwvcmRmOlNlcT4KICAgICAgICAgPC94bXBNTTpIaXN0b3J5PgogICAgICAgICA8eG1wOkNyZWF0b3JUb29sPkFkb2JlIFBob3Rvc2hvcCBDQyAoTWFjaW50b3NoKTwveG1wOkNyZWF0b3JUb29sPgogICAgICAgICA8eG1wOkNyZWF0ZURhdGU+MjAxOC0xMC0wMlQwNzo0NjoyMSswMjowMDwveG1wOkNyZWF0ZURhdGU+CiAgICAgICAgIDx4bXA6TW9kaWZ5RGF0ZT4yMDE4LTEwLTAyVDA3OjQ5OjU1KzAyOjAwPC94bXA6TW9kaWZ5RGF0ZT4KICAgICAgICAgPHhtcDpNZXRhZGF0YURhdGU+MjAxOC0xMC0wMlQwNzo0OTo1NSswMjowMDwveG1wOk1ldGFkYXRhRGF0ZT4KICAgICAgICAgPGRjOmZvcm1hdD5pbWFnZS9wbmc8L2RjOmZvcm1hdD4KICAgICAgICAgPHBob3Rvc2hvcDpDb2xvck1vZGU+MzwvcGhvdG9zaG9wOkNvbG9yTW9kZT4KICAgICAgICAgPHRpZmY6T3JpZW50YXRpb24+MTwvdGlmZjpPcmllbnRhdGlvbj4KICAgICAgICAgPHRpZmY6WFJlc29sdXRpb24+NzIwMDAwLzEwMDAwPC90aWZmOlhSZXNvbHV0aW9uPgogICAgICAgICA8dGlmZjpZUmVzb2x1dGlvbj43MjAwMDAvMTAwMDA8L3RpZmY6WVJlc29sdXRpb24+CiAgICAgICAgIDx0aWZmOlJlc29sdXRpb25Vbml0PjI8L3RpZmY6UmVzb2x1dGlvblVuaXQ+CiAgICAgICAgIDxleGlmOkNvbG9yU3BhY2U+NjU1MzU8L2V4aWY6Q29sb3JTcGFjZT4KICAgICAgICAgPGV4aWY6UGl4ZWxYRGltZW5zaW9uPjgxPC9leGlmOlBpeGVsWERpbWVuc2lvbj4KICAgICAgICAgPGV4aWY6UGl4ZWxZRGltZW5zaW9uPjgyPC9leGlmOlBpeGVsWURpbWVuc2lvbj4KICAgICAgPC9yZGY6RGVzY3JpcHRpb24+CiAgIDwvcmRmOlJERj4KPC94OnhtcG1ldGE+CiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgCjw/eHBhY2tldCBlbmQ9InciPz6ufJXgAAAAIGNIUk0AAHolAACAgwAA+f8AAIDpAAB1MAAA6mAAADqYAAAXb5JfxUYAAAazSURBVHja7J17iFRVHMc/d+aur3yEZpaaWT5qfbubiu8Mqehh9hCKKAgiIizoCZXVXxL0VxElFEFEBD0oehMYURiBgfZU81FmWqaWtrbrY3fm9sf5nTx7vHd2xr0z98zc+4VlBmRmrx9/v3N+5/y+5+gFQUADyAP6AAWgq9a/3Kdx1AcYIe/3A//U7F+wQSJRR+OZQCswXqLyR2A90JFBrEynA7OABUCLZNunwKvA3gxi+RoMzARmC8wFQDuwBngB+CuDWD7IGcBFkuKLgNHAFmC1RGYGsQwNAqZLerdKZE6QP/sAeBj4IZudS+swsBEI5KcoPxOBq4A5wKPAixnE0moXkBpgYIAcLmPkbOBB4FAGMVodwLcWxEBA+sDtwCTgZmBnBrE0yO+stC4CFwqHecAnwI0SuRnECB0RkEVjnAwEZJNE5nvATcC6DGK0jgLfh0RksywdRwNvAVcDX2cQo3VMQBatmXuysQZ/E7gM+CmDGK3jsrYOrJl7MtAXOBd4HVgKHMgg9gzSjsgpQD8p1F8CbgA6M4jR6gQ2hdSRU4H+wDLgIVkqZhBLqAvYHJLaU4EBwOMyW3+eQSytgkwidvkzFTgNeBaYL0vJsiHm5AvTFpFbQ8qf6QLzAeCJciH2ky86Lq9pi8itIZNNK3C/zNibeoLYX+qkg/IFnSkEWQS2h4yR84DHZEVTEuJced1uwOtKYWoXgR1WRHqoLbT5wJdREFskZD+Wqt6T7aEjKQb5sxWRA4HbSkG8C7hC4GnynrHm7EwhyEBAFuR9TiaaiTJ2doM4CrhW3i8F8gZED/hbviSNEQnwqxGRA1DNr5MgXgcMlfdNwCUCMmdE40HUvlxaQe4SkD5wjsDs0BA9WR/ak87FBkQT5pGUpjbAb7J6WSjZu01DbEb1GWzlgcXymg+JyLSC3A18JZPM/+m8RArsqJXLAnnNWZNNmkHuRLkt8iZEelgCzrdSWsNsTzHIQ4DnoxrcLWV8wJOKPW9EpVaaQQa+jIdjKvjQnBKpfTyNIH1Upytf4edmWeWPxwmTUKcUpqmDeCpqiYjIdmM3JDUQx/Xi8zMskFipXUgLxBG9/I5pIamtu2OpAOkDw2L4nslGRNpR2fAgfZQZMg41AyusjYt9aQDpo3ay49IFsgbPWSD/NcqfoBEhxv2XmiARaRbkngGy0Gggq9UyPT8kImlUkL41CcSp84yItOvIY40E0kftDVZLY0JSex8n2rENAdIH2qr8O0Zbs7aOzLZGAekT88GYCI20xkitw42Q2j5VOqoVorOA660xUkdkXYP0Ue3AWmmEgLQbYHUN0kcd06qlhqNas/Z6W4PsqjeQGmKByvcUe6MzgOWc3EnUZ5TrCqSPMjfukrqulhoqIPPWZFN3IH2ZITckABFUt2wZJ+/+tKFsK3UBUi/7PpMBPwkNQZ0ZCdslrwuQJsSjRPeeq63BKMua7f85JM9VwOEGmIa4GXVXwqIEn2UQypFmt2M1SFwFqSEGqKNYixJ+noEC0lwi6slGp3bRVYgAb6NM3cMSfqYBwOVGHYlR/jhpNjUh7gHeQZ39TVr9UefqclZE4iJIe1N2DXAr6pBg0uoLXBoSkYFrqW1D3AC8i9q6ckF9UK5du/w5iEP257D2wJNSt/VzBKTp2jWXiPqISOIRGQZxI/AycKdDY3cTJ1y79jIxcftzVKNqNXANcLZjk+DikIJcTzaJpXYUxN3AKtRZX5eUR3ml7THSdKQVXYGIpPSVqFMFLkm7dsOsfYnYn0tBLAL3oCx0Yx0EOZdoR1pNQfbUvN8jxfeHUre5JI/urt2cEZHtMtkUXIAI6u7Be4HnHVz7e6ijI3Zq64jUGRUkDVGvZEahLidzUa0hqa0jsur250q8OKtQ+353OwpyZkREVt3+XKmh6T55uJWOgpxGAvbnSiF2SSQeRl3g6KKmhNSRVbU/n6q17hHgT+ApR3Z8bE2i+3nEqtqfe+NPfAbYBjznYB0JyrW7worK/XT3SCYOEeAj2WF5GtX6dE2ma9eebGJzpOVieNBfUE34lcAfDoIcJyAXCtSRqDZtbI6PuG83Hi+15C3U1pZSjvZK5ryBOqscmy8zF/ODbkfd1LEEeB+3GkqdqLbwF8RsbK32PduLgTtkN2hIQvC+AV4BXpOKIv61Z40uK5+IstMtlyVaUw1Sd62k7lqq60uv+Y3vvizPlshAPxO1e97bYaUDZRFcLxsm66idAzjxa/OHoY6zNaOODI9F/XcgQyX9m6wSpB1lKzkA/C516hbUBWg7KHHbZjX13wCDJvbrmQJtvAAAAABJRU5ErkJggg==" 
$FormLogin = New-UDAuthenticationMethod -Endpoint {
    param([PSCredential]$Credentials)
    ##Auth Function
    Function Test-ADAuthentication { 
    param($userlogin,$userpassword) 
    (new-object directoryservices.directoryentry "",$userlogin,$userpassword).psbase.name -ne $null 
} 
    ##Check Cred
        if((Test-ADAuthentication $Credentials.UserName $Credentials.GetNetworkCredential().Password) -and (Get-ADUser $Credentials.UserName -Properties MemberOf | Where {$_.MemberOf -like "*adm*"} | Select MemberOf)) { 
            ##Correct Pass
            New-UDAuthenticationResult -Success -UserName ($Credentials.UserName) -Role "Admin"
        }
        if((Test-ADAuthentication $Credentials.UserName $Credentials.GetNetworkCredential().Password) -and (Get-ADUser $Credentials.UserName -Properties MemberOf | Where {$_.MemberOf -like "*direction*"} | Select MemberOf)) { 
            ##Correct Pass
            New-UDAuthenticationResult -Success -UserName ($Credentials.UserName) -Role "Direction"
        }
        if((Test-ADAuthentication $Credentials.UserName $Credentials.GetNetworkCredential().Password) -and (Get-ADUser $Credentials.UserName -Properties MemberOf | Where {$_.MemberOf -like "*carac*"} | Select MemberOf)) { 
            ##Correct Pass
            New-UDAuthenticationResult -Success -UserName ($Credentials.UserName) -Role "carac"
        }
        if((Test-ADAuthentication $Credentials.UserName $Credentials.GetNetworkCredential().Password) -and (Get-ADUser $Credentials.UserName -Properties MemberOf | Where {$_.MemberOf -like "*accueil*"} | Select MemberOf)) { 
            ##Correct Pass
            New-UDAuthenticationResult -Success -UserName ($Credentials.UserName) -Role "accueil"
        }
        if((Test-ADAuthentication $Credentials.UserName $Credentials.GetNetworkCredential().Password) -and (Get-ADUser $Credentials.UserName -Properties MemberOf | Where {$_.MemberOf -like "*ecm*"} | Select MemberOf)) { 
            ##Correct Pass
            New-UDAuthenticationResult -Success -UserName ($Credentials.UserName) -Role "ECM"
        }
        if((Test-ADAuthentication $Credentials.UserName $Credentials.GetNetworkCredential().Password) -and (Get-ADUser $Credentials.UserName -Properties MemberOf | Where {$_.MemberOf -like "*dashboards*"} | Select MemberOf)) { 
            ##Correct Pass
            New-UDAuthenticationResult -Success -UserName ($Credentials.UserName) -Role "dash"
        }
        if((Test-ADAuthentication $Credentials.UserName $Credentials.GetNetworkCredential().Password) -and (Get-ADUser $Credentials.UserName -Properties MemberOf | Where {$_.MemberOf -like "*sfc*"} | Select MemberOf)) { 
            ##Correct Pass
            New-UDAuthenticationResult -Success -UserName ($Credentials.UserName) -Role "copieur"
        }
        if((Test-ADAuthentication $Credentials.UserName $Credentials.GetNetworkCredential().Password) -and (Get-ADUser $Credentials.UserName -Properties PrimaryGroup | Where {$_.PrimaryGroup -like "*utilisateurs du domaine*"} | Select PrimaryGroup)) { 
            ##Correct Pass
            New-UDAuthenticationResult -Success -UserName ($Credentials.UserName) -Role "User"
        }
    ##Bad Pass
    New-UDAuthenticationResult -ErrorMessage "Identifiants incorrects / Bad ID's"
}
$LoginPage = New-UDLoginPage -Title "Get Your Own Windows Management" -AuthenticationMethod @($FormLogin) -PageBackgroundColor "#333" -LoginFormBackgroundColor "#333" -LoginFormFontColor "white" -WelcomeText $bienvenue -Logo $logologin -LoginButtonFontColor "#33B2E7" -LoadingText "En cours de chargement ..."
$Link = New-UDLink -Text 'Systèmes d Information et administration des Systèmes et des Réseaux' -Url 'https://portail.iemn.fr'  #-Url 'https://desmet-gauthier.fr'
$Footer = New-UDFooter -Copyright 'de Smet Gauthier | IEMN - CNRS UMR 8520' -Links $Link
$date = Get-Date -format "dd/MM/yyyy HH:mm:ss"
# variables systeme
    $users = (Get-ADUser -Filter * | Where-Object ObjectClass -eq "user" ).count
    $users2 = (Get-ADUser -Filter * | Where-Object Enabled -like "False" ).count
    $users3 = (Get-ADUser -Filter * | Where-Object Enabled -like "True" ).count
    $groups1 = (Get-ADGroup -Filter * | Where-Object ObjectClass -like "group" ).count
    $groups2 = Get-ADGroup -Filter *
    $groups3 = Get-ADOrganizationalUnit -Filter * -Properties *
    $gpocount = (Get-GPO -All -Domain iemn.fr -Server 194.57.171.186 | Where {$_.GpoStatus -like "AllSettingsEnabled"} | Select DisplayName).count
    $ADcomptotal = (Get-ADComputer  -Filter * -SearchBase "CN=Computers,DC=iemn,DC=fr" -Properties OperatingSystem | Select OperatingSystem).count
    $ADcompwinxp = (Get-ADComputer  -Filter * -SearchBase "CN=Computers,DC=iemn,DC=fr" -Properties OperatingSystem | Where {$_.OperatingSystem -like "*Windows XP*"} | Select OperatingSystem).count
    $ADcompwin7 = (Get-ADComputer  -Filter * -SearchBase "CN=Computers,DC=iemn,DC=fr" -Properties OperatingSystem | Where {$_.OperatingSystem -like "*Windows 7*"} | Select OperatingSystem).count
    $ADcompwin8 = (Get-ADComputer  -Filter * -SearchBase "CN=Computers,DC=iemn,DC=fr" -Properties OperatingSystem | Where {$_.OperatingSystem -like "*Windows 8*"} | Select OperatingSystem).count
    $ADcompwin10 = (Get-ADComputer  -Filter * -SearchBase "CN=Computers,DC=iemn,DC=fr" -Properties OperatingSystem | Where {$_.OperatingSystem -like "*Windows 10*"} | Select OperatingSystem).count
    $ADcompwinserv = (Get-ADComputer  -Filter * -SearchBase "CN=Computers,DC=iemn,DC=fr" -Properties OperatingSystem | Where {$_.OperatingSystem -like "Windows Server*"} | Select OperatingSystem).count
    $userpercent = (($users3 / $users)*"0,01")*"100"
    $userpercentround = [math]::Round($userpercent / 1,0) 
    $nodesup = (Get-ClusterNode -Cluster  $Hyperviseur | Where {$_.State -eq "Up"} | Select State).count
    $nodesdown = (Get-ClusterNode -Cluster  $Hyperviseur | Where {$_.State -eq "Down"} | Select State).count
    $nodes = (Get-ClusterNode -Cluster  $Hyperviseur | Select State).count
    $vnodespercent = [math]::Round((($nodesup/$nodes)*"0,01")*"100" / 1,0)
    $vmnumbers = (Get-Cluster –Name $Hyperviseur | Get-ClusterGroup | Select Name).count
    $vmnumbersup = (Get-Cluster –Name $Hyperviseur | Get-ClusterGroup | Where {$_.State -eq "Online"} | Select Name).count
    $vmnumbersdown = (Get-Cluster –Name $Hyperviseur | Get-ClusterGroup | Where {$_.State -eq "Offline"} | Select Name).count
    $vmnumberpercent = [math]::Round((($vmnumbersup/$vmnumbers)*"0,01")*"100" / 1,0)
    $vmconf1 = Get-VM -ComputerName (Get-ClusterNode -Cluster sin-city.iemn.fr) | select Name 
    $vmconfeach = ForEach($itemvmconf1 in $vmconf1)
    {Get-VMNetworkAdapter -ComputerName (Get-ClusterNode -Cluster sin-city.iemn.fr) -VMName $itemvmconf1.Name}
    $vmvlan = ($vmconfeach).count
    $vmvlanup = ($vmconfeach | select Connected | Where {$_.Connected -like "True"}).count
    $vmvlanwarn = ($vmconfeach | select Status | Where {$_.Status -like "*Degraded*"}).count
    $vmvlandown = ($vmconfeach | select Connected | Where {$_.Connected -notlike "True"}).count
    $vmvlanpercent = [math]::Round((($vmvlanup/$vmvlan)*"0,01")*"100" / 1,0)
    $wps1count = (Get-Printer -ComputerName cooper.iemn.fr | Where {$_.Name -like "SafeQ*"}).count
    $wps2count =(Get-Printer -ComputerName iemn-printers.iemn.fr | Where {$_.Name -like "*SafeQ" -or $_.Name -like "SFC*"}).count
    $wpstotalcount = ($wps1count + $wps2count)
    $wpspercent = [math]::Round((($wpstotalcount/4)*"0,01")*"100" / 1,0)
    $psspcount=new-PSsession -ComputerName $intranet
    $spcount = Invoke-Command -Session $psspcount -ScriptBlock {
    Add-PSSnapin Microsoft.SharePoint.Powershell
    Get-SPSite}
    $cert = (Get-ChildItem -Path Cert:\LocalMachine\WebHosting\9E77325FD9CA32BD98735E5C2D7A4FEBE67F7C1F)
    $spcountsite = ($spcount).count
    $rdsconnectioncount = (Get-RDUserSession -ConnectionBroker $rds | Select UserName).count
    $rdsremoteappcount = (Get-RDRemoteApp -ConnectionBroker $rds -CollectionName "IEMN" | Select DisplayName).count
# Pages
$page_Accueil = New-UDPage -Name "Links" -Icon home -AutoRefresh $true -RefreshInterval 60 -Content{
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
} -AuthorizedRole @("Admin", "dash") #fin page Accueil
$page_status = New-UDPage -Name "Up or Down" -Icon battery -AutoRefresh $true -RefreshInterval 30 -Content {
New-UDCard -Title "Etâts des services Windows IEMN" -Content {
    New-UDParagraph -Text "$date" -Color "#fff"
    New-UDRow -Columns{
        New-UDColumn -Size 3 -Content{
        New-UDParagraph -Text "Status Global" -Color "#fff"
        if ($userpercent -ge 80) {New-UDCounter -BackgroundColor "lightgreen" -FontColor "#333" -Icon user_circle -Title "$userpercentround % des utilisateurs sont actifs" -TextSize 2 -AutoRefresh -RefreshInterval 60 -Endpoint {$userpercent}} elseif ($userpercent -le 80 -ge 50) {New-UDCounter -BackgroundColor "orange" -FontColor "#333" -Icon user_circle -Title "$userpercentround % des utilisateurs sont actifs" -TextSize 2 -AutoRefresh -RefreshInterval 60 -Endpoint {$userpercent}} elseif ($userpercent -le 49 -ge 0) {New-UDCounter -BackgroundColor "red" -FontColor "#333" -Icon user_circle -Title "$userpercentround % des utilisateurs sont actifs" -TextSize 2 -AutoRefresh -RefreshInterval 60 -Endpoint {$userpercent}}
        if ($vnodespercent -ge 80) {New-UDCounter -BackgroundColor "lightgreen" -FontColor "#333" -Icon server -Title "$vnodespercent % des noeuds sont en production" -TextSize 2 -AutoRefresh -RefreshInterval 60 -Endpoint {$vnodespercent}} elseif ($vnodespercent -le 80 -ge 50) {New-UDCounter -BackgroundColor "orange" -FontColor "#333" -Icon server -Title "$vnodespercent % des noeuds sont en production" -TextSize 2 -AutoRefresh -RefreshInterval 60 -Endpoint {$vnodespercent}} elseif ($vnodespercent -le 49 -ge 0) {New-UDCounter -BackgroundColor "red" -FontColor "#333" -Icon server -Title "$vnodespercent des noeuds sont en production" -TextSize 2 -AutoRefresh -RefreshInterval 60 -Endpoint {$vnodespercent}}
        if ($vmnumberpercent -ge 99) {New-UDCounter -BackgroundColor "lightgreen" -FontColor "#333" -Icon laptop -Title "$vmnumberpercent % des Machines Virtuelles sont UP" -TextSize 2 -AutoRefresh -RefreshInterval 60 -Endpoint {$vmnumberpercent}} elseif ($vmnumberpercent -le 98 -ge 50) {New-UDCounter -BackgroundColor "orange" -FontColor "#333" -Icon laptop -Title "$vmnumberpercent % des Machines Virtuelles sont UP" -TextSize 2 -AutoRefresh -RefreshInterval 60 -Endpoint {$vmnumberpercent}} elseif ($vmnumberpercent -le 49 -ge 0) {New-UDCounter -BackgroundColor "red" -FontColor "#333" -Icon laptop -Title "$vmnumberpercent % des Machines Virtuelles sont UP" -TextSize 2 -AutoRefresh -RefreshInterval 60 -Endpoint {$vmnumberpercent}}
    }
        New-UDColumn -Size 3 -Content{
        New-UDParagraph -Text "Status Global" -Color "#fff"
        if ($vmvlanpercent -ge 80) {New-UDCounter -BackgroundColor "lightgreen" -FontColor "#333" -Icon desktop -Title "$vmvlanpercent % des VMs UP sont connectées" -TextSize 2 -AutoRefresh -RefreshInterval 60 -Endpoint {$vmvlanpercent}} elseif ($vmvlanpercent -le 80 -ge 50) {New-UDCounter -BackgroundColor "orange" -FontColor "#333" -Icon desktop -Title "$vmvlanpercent % des VMs UP sont connectées" -TextSize 2 -AutoRefresh -RefreshInterval 60 -Endpoint {$vmvlanpercent}} elseif ($vmvlanpercent -le 49 -ge 0) {New-UDCounter -BackgroundColor "red" -FontColor "#333" -Icon desktop -Title "$vmvlanpercent % des VMs UP sont connectées" -TextSize 2 -AutoRefresh -RefreshInterval 60 -Endpoint {$vmvlanpercent}}
        if ($wpspercent -ge 75) {New-UDCounter -BackgroundColor "lightgreen" -FontColor "#333" -Icon print -Title "$wpspercent % des imprimantes sont UP" -TextSize 2 -AutoRefresh -RefreshInterval 60 -Endpoint {$wpspercent}} elseif ($wpspercent -le 74 -ge 50) {New-UDCounter -BackgroundColor "orange" -FontColor "#333" -Icon print -Title "$wpspercent % des imprimantes sont UP" -TextSize 2 -AutoRefresh -RefreshInterval 60 -Endpoint {$wpspercent}} elseif ($wpspercent -le 49 -ge 0) {New-UDCounter -BackgroundColor "red" -FontColor "#333" -Icon print -Title "$wpspercent % des imprimantes sont UP" -TextSize 2 -AutoRefresh -RefreshInterval 60 -Endpoint {$wpspercent}}
        New-UDCounter -BackgroundColor "lightgreen" -FontColor "#333" -Icon cloud -Title "$spcountsite Sites sur l'intranet sont UP" -TextSize 2 -AutoRefresh -RefreshInterval 60 -Endpoint {$spcountsite}
    }
        New-UDColumn -Size 3 -Content{
        New-UDParagraph -Text "Status des Nodes sur Hyper-V" -Color "#fff"
        New-UDCounter -FontColor '#333' -BackgroundColor "lightgreen" -Title "$nodesup Node(s) Online" -Icon server -TextSize 2 -AutoRefresh -RefreshInterval 60 -Endpoint {$nodesup}
        New-UDCounter -FontColor '#fff' -BackgroundColor "#e95555" -Title "$nodesdown Node(s) Offline" -Icon server -TextSize 2 -AutoRefresh -RefreshInterval 60 -Endpoint {$nodesdown}
        New-UDCounter -FontColor '#333' -BackgroundColor "lightgreen" -Title "$vmvlanup VLANCard Online" -Icon link -TextSize 2 -AutoRefresh -RefreshInterval 60 -Endpoint {$vmvlanup}
}#fin column Status des noeuds
        New-UDColumn -Size 3 -Content{
        New-UDParagraph -Text "Status des VMs sur Hyper-V" -Color "#fff"
        New-UDCounter -FontColor '#333' -BackgroundColor "lightgreen" -Title "$vmnumbersup VM Online" -Icon laptop -TextSize 2 -AutoRefresh -RefreshInterval 60 -Endpoint {$vmnumbersup}
        New-UDCounter -FontColor '#fff' -BackgroundColor "#e95555" -Title "$vmnumbersdown VM Offline" -Icon laptop -TextSize 2 -AutoRefresh -RefreshInterval 60 -Endpoint {$vmnumbersdown}
        New-UDCounter -FontColor '#fff' -BackgroundColor "#e95555" -Title "$vmvlandown VLANCard Offline" -Icon link -TextSize 2 -AutoRefresh -RefreshInterval 60 -Endpoint {$vmvlandown}
        }
    }#fin Row
}#fin udCard counters
New-UDCard -Title "Etât des autres châssis/services" -Content{
    New-UDRow -Columns{ 
        New-UDColumn -Size 2 -Content{
            $albator_ping = Test-Connection -BufferSize 32 -Count 1 -ComputerName 'albator.iemn.fr' -Quiet
            if ($albator_ping -like "True" ) {New-UDElement -tag "div" -Id "albator_ping" -AutoRefresh -RefreshInterval 60 -Content{"La baie de disque n°1 est allumée"}} else{New-UDElement -tag "div" -Id "albator_ping_down" -AutoRefresh -RefreshInterval 60 -Content{"La baie de disques n°1 est éteinte"}} 
        }#fin column albator
        New-UDColumn -Size 2 -Content{
            $kraken_ping = Test-Connection -BufferSize 32 -Count 1 -ComputerName 'kraken.iemn.fr' -Quiet
            if ($kraken_ping -like "True" ) {New-UDElement -tag "div" -Id "kraken_ping" -AutoRefresh -RefreshInterval 60 -Content{"La baie de disque n°2 est allumée"}} else{New-UDElement -tag "div" -Id "kraken_ping_down" -AutoRefresh -RefreshInterval 60 -Content{"La baie de disque n°2 est éteinte"}} 
        }#fin column kraken
        New-UDColumn -Size 2 -Content{
            $kraken2_ping = Test-Connection -BufferSize 32 -Count 1 -ComputerName 'kraken2.iemn.fr' -Quiet
            if ($kraken2_ping -like "True" ) {New-UDElement -tag "div" -Id "kraken2_ping" -AutoRefresh -RefreshInterval 60 -Content{"La baie de disque n°3 est allumée"}} else{New-UDElement -tag "div" -Id "kraken2_ping_down" -AutoRefresh -RefreshInterval 60 -Content{"La baie de disque n°3 est éteinte"}} 
        }#fin column kraken2
        New-UDColumn -Size 2 -Content{
            $cooper_ping = Test-Connection -BufferSize 32 -Count 1 -ComputerName 'cooper.iemn.fr' -Quiet
            if ($cooper_ping -like "True" ) {New-UDElement -tag "div" -Id "cooper_ping" -AutoRefresh -RefreshInterval 60 -Content{"L'AD n°2 est allumé"}} else{New-UDElement -tag "div" -Id "cooper_ping_down" -AutoRefresh -RefreshInterval 60 -Content{"L'AD n°2 est éteint"}} 
        }#fin column AD2
        New-UDColumn -Size 2 -Content{
            $cerberus_ping = Test-Connection -BufferSize 32 -Count 1 -ComputerName 'localhost' -Quiet
            if ($cerberus_ping -like "True" ) {New-UDElement -tag "div" -Id "cerberus_ping" -AutoRefresh -RefreshInterval 60 -Content{"Le monitoring est allumé"}} else{New-UDElement -tag "div" -Id "cerberus_ping_down" -AutoRefresh -RefreshInterval 60 -Content{"Le monitoring est éteint"}} 
        }#fin column monitoring
        New-UDColumn -Size 2 -Content{
            $internet_ping = Test-Connection -BufferSize 32 -Count 1 -ComputerName 'google.fr' -Quiet
            if ($internet_ping -like "True" ) {New-UDElement -tag "div" -Id "internet_ping" -AutoRefresh -RefreshInterval 60 -Content{"Le réseau et internet fonctionnent"}} else{New-UDElement -tag "div" -Id "internet_ping_down" -AutoRefresh -RefreshInterval 60 -Content{"il y'a une coupure réseau et/ou internet"}} 
        }#fin column internet   
    }#fin row
    New-UDRow -Columns{
        New-UDColumn -Size 3 -Content{
            $xivo_ping = Test-Connection -BufferSize 32 -Count 1 -ComputerName '172.20.5.10' -Quiet
            if ($xivo_ping -like "True" ) {New-UDElement -tag "div" -Id "xivo_ping" -AutoRefresh -RefreshInterval 60 -Content{"Le serveur de téléphonie ip (XiVO) est allumé"}} else{New-UDElement -tag "div" -Id "xivo_ping_down" -AutoRefresh -RefreshInterval 60 -Content{"Le serveur de téléphonie ip (XiVO) est éteint"}} 
        }#fin column xivo 
        #New-UDColumn -Size 3 -Content{
        #    $xivo_ping = Test-Connection -BufferSize 32 -Count 1 -ComputerName '172.20.5.10' -Quiet
        #    if ($xivo_ping -like "True" ) {New-UDElement -tag "div" -Id "xivo_ping" -AutoRefresh -RefreshInterval 60 -Content{"Le serveur de téléphonie ip (XiVO) est allumé"}} else{New-UDElement -tag "div" -Id "xivo_ping_down" -AutoRefresh -RefreshInterval 60 -Content{"Le serveur de téléphonie ip (XiVO) est éteint"}} 
        #}#fin column publis
        #New-UDColumn -Size 2 -Content{
        #    $xivo_ping = Test-Connection -BufferSize 32 -Count 1 -ComputerName '172.20.5.10' -Quiet
        #    if ($xivo_ping -like "True" ) {New-UDElement -tag "div" -Id "xivo_ping" -AutoRefresh -RefreshInterval 60 -Content{"Le serveur de téléphonie ip (XiVO) est allumé"}} else{New-UDElement -tag "div" -Id "xivo_ping_down" -AutoRefresh -RefreshInterval 60 -Content{"Le serveur de téléphonie ip (XiVO) est éteint"}} 
        #}#fin column portail
        #New-UDColumn -Size 2 -Content{
        #    $xivo_ping = Test-Connection -BufferSize 32 -Count 1 -ComputerName '172.20.5.10' -Quiet
        #    if ($xivo_ping -like "True" ) {New-UDElement -tag "div" -Id "xivo_ping" -AutoRefresh -RefreshInterval 60 -Content{"Le serveur de téléphonie ip (XiVO) est allumé"}} else{New-UDElement -tag "div" -Id "xivo_ping_down" -AutoRefresh -RefreshInterval 60 -Content{"Le serveur de téléphonie ip (XiVO) est éteint"}} 
        #}#fin column visites
        #New-UDColumn -Size 2 -Content{
        #    $xivo_ping = Test-Connection -BufferSize 32 -Count 1 -ComputerName '172.20.5.10' -Quiet
        #    if ($xivo_ping -like "True" ) {New-UDElement -tag "div" -Id "xivo_ping" -AutoRefresh -RefreshInterval 60 -Content{"Le serveur de téléphonie ip (XiVO) est allumé"}} else{New-UDElement -tag "div" -Id "xivo_ping_down" -AutoRefresh -RefreshInterval 60 -Content{"Le serveur de téléphonie ip (XiVO) est éteint"}} 
        #}#fin column services    
         
    }#fin row
}#fin card
} -AuthorizedRole @("User", "Direction", "Admin", "carac", "dash")  # fin page status
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
 } -AuthorizedRole @("dash", "Admin") # fin page ADS
$page_ADCarac = New-UDPage -Name "PF CARAC" -Icon adn -AutoRefresh $true -RefreshInterval 60 -Content{
New-UDCard -Title "Annuaire CARAC" -Content{
New-UDRow -Columns {
New-UDColumn -Size 6 {
New-UDInput -Title “Ajouter un user” -Id “useraddcaracform” -Content {
New-UDInputField -Type ‘textbox’ -Name ‘caracuseraddidsurname’ -Placeholder ‘Entrer le prénom du user’
New-UDInputField -Type ‘textbox’ -Name ‘caracuseraddidname’ -Placeholder ‘Entrer le nom du user’
New-UDInputField -Type ‘password’ -Name ‘caracuseradd’ -Placeholder ‘Entrer le mot de passe souhaité’
} -Endpoint {
param($caracuseraddidsurname,$caracuseraddidname,$caracuseradd)
$caracuseraddid = “$caracuseraddidsurname.$caracuseraddidname”
$caracuseradiddisplayname = “$caracuseraddidsurname $caracuseraddidname”
New-ADUser -Server $caracserver -Name $caracuseraddid -OtherAttributes @{'mail'="$caracuseraddid@carac.iemn.fr";'UserPrincipalName'="$caracuseraddid@carac.iemn.fr";'GivenName'="$caracuseraddidsurname";'sn'="$caracuseraddidname";'DistinguishedName'="CN=$caracuseradiddisplayname,CN=Users,DC=CARAC,DC=iemn,DC=fr"} -SamAccountName "$caracuseraddidsurname.$caracuseraddidname" -CannotChangePassword:$true -Country "FR" -OtherName "$caracuseraddidsurname $caracuseraddidname" -DisplayName "$caracuseraddidsurname $caracuseraddidname" -HomeDrive "Z:" -HomeDirectory "\\lciserv2.iemn.fr\carac-dist"  -Enabled:$true -PasswordNeverExpires:$true -AccountPassword (ConvertTo-SecureString -AsPlainText $caracuseradd -Force) -PassThru
}
}# Ajout carac users
New-UDColumn -Size 6 {
New-UDInput -Title “Supprimer un user” -Id “Formdelcaracuser” -Content {
New-UDInputField -Type ‘textbox’ -Name ‘deluser’ -Placeholder ‘Entrer l identifiant du user’
} -Endpoint {
param($deluser)
Remove-ADUser -Server $caracserver $deluser -Confirm:$false
}
}# Suppression carac users
}#input users
New-UDRow -Columns{
New-UDColumn -Size 6 {
    New-UdGrid -Title "Postes clients sous domaine CARAC" -Headers @("Noms DNS AD", "SamAccountName", "IPv4Address") -Properties @("DNSHostName", "SamAccountName", "IPv4Address") -PageSize 15 -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-ADComputer  -Filter * -Server $caracserver -Properties * | Select DNSHostName,SamAccountName,IPv4Address | Out-UDGridData
}####### fin liste des pc sous AD
}# ADComputers liste carac
New-UDColumn -Size 6 {
       $caracpccount = (Get-ADComputer  -Filter * -Server $caracserver -Properties * | Select DNSHostName).count
       New-UDCounter -BackgroundColor "cornflowerblue" -Title "$caracpccount postes gérés au total" -Icon desktop -TextSize 2 -AutoRefresh -RefreshInterval 60 -Endpoint {$caracpccount}
}####### fin compteur des pc sous AD
New-UDColumn -Size 6 {
       $caracpccountwin10 = (Get-ADComputer  -Filter * -Server $caracserver -Properties * | Select OperatingSystem | Where {$_.OPeratingSystem -like "Windows 10*"}).count
       New-UDCounter -BackgroundColor "lightgreen" -FontColor "#333" -Title "$caracpccountwin10 postes sous Windows 10" -Icon desktop -TextSize 2 -AutoRefresh -RefreshInterval 60 -Endpoint {$caracpccountwin10}
}####### fin compteur des pc sous AD Windows 10
New-UDColumn -Size 6 {
       $caracpccountwin8 = (Get-ADComputer  -Filter * -Server $caracserver -Properties * | Select OperatingSystem | Where {$_.OPeratingSystem -like "Windows 8*"}).count
       New-UDCounter -BackgroundColor "orange" -Title "$caracpccountwin8 postes sous Windows 8.1" -Icon desktop -TextSize 2 -AutoRefresh -RefreshInterval 60 -Endpoint {$caracpccountwin8}
}####### fin compteur des pc sous AD Windows 8 et 8.1
New-UDColumn -Size 6 {
       $caracpccountwin7 = (Get-ADComputer  -Filter * -Server $caracserver -Properties * | Select OperatingSystem | Where {$_.OPeratingSystem -like "Windows 7*"}).count
       New-UDCounter -BackgroundColor "orangered" -Title "$caracpccountwin7 postes sous Windows 7" -Icon desktop -TextSize 2 -AutoRefresh -RefreshInterval 60 -Endpoint {$caracpccountwin7}
}####### fin compteur des pc sous AD Windows 7
} #input computer
New-UDRow -Columns{   
New-UDColumn -Size 6 {
New-UDInput -Title “Supprimer un ordinateur du domaine” -Id “Formdelcaracpc” -Content {
New-UDInputField -Type ‘textbox’ -Name ‘delpc’ -Placeholder ‘Entrer le nom de la machine à supprimer’
} -Endpoint {
param($delpc)
Remove-ADComputer -Server $caracserver $delpc -Confirm:$false
}
}# Suppression carac users
New-UDParagraph -Text "Liens utiles" -Color "white"
New-UDColumn -Size 6 {
    New-UDLayout -Columns 4 -Content{
        New-UDLink -Icon link -Text "Adresser une machine" -Url "https://ops.iemn.fr/netmagis" -OpenInNewWindow -FontColor "cornflowerblue"
        New-UDLink -Icon amazon -Text "Portail des services info" -Url "https://portail.iemn.fr" -OpenInNewWindow -FontColor "cornflowerblue"
        New-UDLink -Icon binoculars -Text "Intranet" -Url "https://intranet.iemn.fr/" -OpenInNewWindow -FontColor "cornflowerblue"
        New-UDLink -Icon check -Text "les applications distantes" -Url "https://rds01.iemn.fr/RDWeb/" -OpenInNewWindow -FontColor "cornflowerblue"
        New-UDLink -Icon cloud -Text "Cloud IEMN (Agenda/Contacts)" -Url "https://nc.iemn.fr" -OpenInNewWindow -FontColor "cornflowerblue"
        New-UDLink -Icon mail_forward -Text "WebMail IEMN" -Url "https://rc.iemn.fr" -OpenInNewWindow -FontColor "cornflowerblue"
        New-UDLink -Icon sign_in -Text "Synchro de comptes RH/Windows" -Url "https://services.iemn.fr" -OpenInNewWindow -FontColor "cornflowerblue"
        New-UDLink -Icon home -Text "Visites IEMN" -Url "https://services.iemn.fr" -OpenInNewWindow -FontColor "cornflowerblue"
    }
}
}#del computer
 }#fin card
 } -AuthorizedRole @("carac", "Admin", "Direction", "dash") # fin page ADS CARAC
$page_CA = New-UDPage -Name "Authorité de Certification" -Icon certificate -Content {
New-UDCollapsible -BackgroundColor "#333" -FontColor "#FFF" -Items {  
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
$sCA=new-PSsession -ComputerName $CA 
New-UdGrid -Title "Modèles Certificats" -Headers @("Nom") -Properties @("Name") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Invoke-Command -Session $sCA -ScriptBlock {Get-CATemplate} | Select Name | Out-UDGridData
}####### fin liste des modeles
 } -AuthorizedRole @("Admin") # fin page CA
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
 } -AuthorizedRole @("Admin") # fin page Hyperviseurs
$page_intranet = New-UDPage -Name "SharePoint Services" -Icon cloud -Content {
New-UDCollapsible -BackgroundColor "#333" -FontColor "#FFF" -Items {  
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
 $ssp=new-PSsession -ComputerName $intranet -Name "SP1"
New-UdGrid -Title "Sites SharePoint" -Headers @("Url") -Properties @("Url") -AutoRefresh -RefreshInterval 60 -Endpoint {
    $spcount | Out-UDGridData
}####### fin liste de sites
$ssp2=new-PSsession -ComputerName $intranet -Name "SP2"
New-UdGrid -Title "Url publiques SharePoint" -Headers @("Public Url") -Properties @("PublicUrl") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Invoke-Command -Session $ssp2 -ScriptBlock {
Add-PSSnapin Microsoft.SharePoint.Powershell
Get-SPAlternateURL} | Select PublicUrl | Out-UDGridData
}
####### fin liste de url publiques
 } -AuthorizedRole @("Admin", "dash") # fin page SharePoint
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
 } -AuthorizedRole @("dashboard") # fin monitor
$page_rds = New-UDPage -Name "Remote Desktop Services" -Icon desktop -Content {
New-UDCollapsible -BackgroundColor "#333" -FontColor "#FFF" -Items {  
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
New-UDRow -Columns{
New-UDColumn -Size 4 -Content{
New-UdGrid -BackgroundColor '#333' -FontColor '#fff' -Title "Serveurs RDS" -Headers @("Nom du serveur") -Properties @("Server") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-RDServer -ConnectionBroker $rds | Select Server | Out-UDGridData
}####### fin liste des serveurs applications
}#fin serveur rds
New-UDColumn -Size 4 -Content{
if ($rdsconnectioncount -ge 5) {New-UDCounter -BackgroundColor "lightgreen" -FontColor "#333" -Icon print -Title "$rdsconnectioncount Utilisateur(s) connecté(s)" -TextSize 2 -AutoRefresh -RefreshInterval 60 -Endpoint {$rdsconnectioncount}} elseif ($rdsconnectioncount -le 4 -ge 1) {New-UDCounter -BackgroundColor "orange" -FontColor "#333" -Icon print -Title "$rdsconnectioncount Utilisateur(s) connecté(s)" -TextSize 2 -AutoRefresh -RefreshInterval 60 -Endpoint {$rdsconnectioncount}} elseif ($rdsconnectioncount -le 0) {New-UDCounter -BackgroundColor "red" -FontColor "#333" -Icon print -Title "$rdsconnectioncount Utilisateur(s) connecté(s)" -TextSize 2 -AutoRefresh -RefreshInterval 60 -Endpoint {$rdsconnectioncount}}
}#fin column counter
New-UDColumn -Size 4 -Content{
if ($rdsremoteappcount -ge 5) {New-UDCounter -BackgroundColor "lightgreen" -FontColor "#333" -Icon print -Title "$rdsremoteappcount Application(s) disponible(s)" -TextSize 2 -AutoRefresh -RefreshInterval 60 -Endpoint {$rdsremoteappcount}} elseif ($rdsremoteappcount -le 4 -ge 1) {New-UDCounter -BackgroundColor "orange" -FontColor "#333" -Icon print -Title "$rdsremoteappcount Applications(s) disponible(s)" -TextSize 2 -AutoRefresh -RefreshInterval 60 -Endpoint {$rdsremoteappcount}} elseif ($rdsremoteappcount -le 0) {New-UDCounter -BackgroundColor "red" -FontColor "#333" -Icon print -Title "$rdsremoteappcount Application(s) disponible(s)" -TextSize 2 -AutoRefresh -RefreshInterval 60 -Endpoint {$rdsremoteappcount}}
}#fin column counter
}#fin row
New-UDRow -Columns{
New-UDColumn -Size 7 -Content{
New-UdGrid -BackgroundColor '#333' -Title "Applications RDS" -FontColor '#fff' -Headers @("Nom du serveur", "Dossier") -Properties @("DisplayName", "FilePath") -AutoRefresh -RefreshInterval 600 -Endpoint {
       Get-RDRemoteApp -ConnectionBroker $rds -CollectionName "IEMN" | Select DisplayName,FilePath | Out-UDGridData
}####### fin liste des serveurs applications
}#fin column
New-UDColumn -Size 5 -Content{
New-UdGrid -BackgroundColor '#333' -Title "Utilisateurs connectés" -FontColor '#fff' -Headers @("Nom de l'utilisateur", "Nom du Serveur Hôte") -Properties @("UserName", "HostServer") -AutoRefresh -RefreshInterval 600 -Endpoint {
       Get-RDUserSession -ConnectionBroker $rds -CollectionName "IEMN" | Where {$_.SessionState -like 'STATE_ACTIVE'} | Select UserName,HostServer | Out-UDGridData
}####### fin liste des utilisateurs connectés
}#fin column
}#fin row
New-UDRow -Columns{
New-UDColumn -Size 4 -Content{
New-UdGrid -BackgroundColor '#333' -Title "Certificats" -FontColor '#fff' -Headers @("Rôle", "Etât", "Expire le") -Properties @("Role", "Level", "ExpiresOn") -AutoRefresh -RefreshInterval 600 -Endpoint {
       Get-RDCertificate -ConnectionBroker $rds | Select Role,Level,ExpiresOn | Out-UDGridData
}####### fin liste des certificats
}
New-UDColumn -SIze 4 -Content{
New-UdGrid -BackgroundColor '#333' -Title "Utilisateurs Loggés déconnectés" -FontColor '#fff' -Headers @("Nom de l'utilisateur", "Nom du Serveur Hôte") -Properties @("UserName", "HostServer") -PageSize 4 -AutoRefresh -RefreshInterval 600 -Endpoint {
       Get-RDUserSession -ConnectionBroker $rds | Where {$_.SessionState -like 'STATE_DISCONNECTED'} | Select UserName,HostServer | Out-UDGridData
}####### fin liste des utilisateurs connectés
}#fin column
New-UDColumn -Size 4 {
New-UDInput -Title “Déconnecter un user” -Id “Formlogoffuser” -Content {
New-UDInputField -Type ‘textbox’ -Name ‘logoffuser’ -Placeholder ‘Entrer l identifiant du user’
} -Endpoint {
param($logoffuser)
$server   = 'rds01.iemn.fr'
$username = $logoffuser
$session = ((quser /server:$server | ? { $_ -match $username }) -split ' +')[2]
logoff $session /server:$server
Show-UDToast -Icon trash -IconColor "white" -MessageColor "#ec7331" -BackgroundColor "#ccc" -Duration 5000 -Message "c'est gagné !"
}
}#fin deco user
}#fin row
 } -AuthorizedRole @("Admin", "Direction", "dash") # fin page RDS
$page_WSUS = New-UDPage -Name "WS Update Services" -Icon calendar -Content {
New-UDCollapsible -BackgroundColor "#333" -FontColor "#FFF" -Items {  
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
 } -AuthorizedRole @("Admin", "dash") # fin page WSUS
$page_WDS = New-UDPage -Name "Win Deployment Server" -Icon server -Content {
New-UDCollapsible -BackgroundColor "#333" -FontColor "#FFF" -Items {  
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
 } -AuthorizedRole @("Admin", "dash") # fin page WDS
$page_WPS = New-UDPage -Name "Win Printers Server" -Icon print -Content {  
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
}####### fin udlayout valeurs graphiques

 }
 }####fin CA
New-UDCard -Content{
    New-UdGrid -Title "Information(s) Réseau" -Headers @("IP", "Adresse Mac", "Nom DNS", "Ordre DNS") -Properties @("IPAddress", "MACAddress", "DNSHostName", "DNSServerSearchOrder") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-CimInstance -ClassName Win32_NetworkAdapterConfiguration -Filter "IPEnabled='True'" -ComputerName $WPS -Property * | 
Select-Object -Property IPAddress,MACAddress,DNSHostName,DNSServerSearchOrder | Out-UDGridData
}####### fin applis en cours
 } #fin ip/mac
New-UDLayout -Columns 2 -Content{
New-UDCard -Title "IEMN-PRINTERS" -Content{
New-UdGrid -Title "Imprimantes Partagées" -Headers @("Nom", "Drivers", "Nom du port", "partagée", "Publiée dans le catalogue") -Properties @("Name", "DriverName", "PortName", "Shared", "Published") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-Printer -ComputerName $WPS | Where {$_.Shared -like "True"} | Select Name,DriverName,PortName,Shared,Published | Out-UDGridData
}####### fin liste des imprimantes iemn-printers
New-UdGrid -Title "Queue Job" -Headers @("Nom") -Properties @("Name") -AutoRefresh -RefreshInterval 10 -Endpoint {
        $WPSPrint2 = Get-printer -ComputerName $WPS | select Name
        ForEach($itemprint2 in $WPSPrint2)
       {Get-PrintJob -ComputerName $WPS -PrinterName $itemprint2.Name | Select Name | Out-UDGridData}
}####### fin liste des jobs iemn-printers
New-UDButton -Text "Redémarrer le spooler" -Icon recycle -OnClick{
#set your first argument as $computer 
$computer2 = "iemn-printers.iemn.fr" 
#Stop the service: 
#Get-WmiObject -Class Win32_Service -Filter 'name="spooler"' -ComputerName $computer2 | Invoke-WmiMethod -Name StopService | out-null
#Get-WmiObject -Class Win32_Service -Filter 'name="LPDSVC"' -ComputerName $computer2 | Invoke-WmiMethod -Name StopService | out-null 
(get-service -ComputerName $computer2 -Name Spooler).Stop()
(get-service -ComputerName $computer2 -Name LPDSVC).Stop()
#Delete all items in: C:\windows\system32\spool\printers on the remote computer 
#the `$ is the escape charater to make sure powershell sees the $ as a charater rather than a variable 
Get-ChildItem "\\$computer2\C`$\windows\system32\spool\printers" | Remove-Item 
#Start the service 
Set-Service spooler -ComputerName $computer2 -status Running
Set-Service LPDSVC -ComputerName $computer2 -status Running
Show-UDToast -Icon trash -IconColor "white" -MessageColor "#ec7331" -BackgroundColor "#ccc" -Duration 10000 -Message "On enlève les âneries et on recommence !"  
}#fin bouton reset spooler cooper
}# fin de la card
New-UDCard -Title "COOPER" -Content{
New-UdGrid -Title "Imprimantes Partagées" -Headers @("Nom", "Drivers", "Nom du port", "partagée", "Publiée dans le catalogue") -Properties @("Name", "DriverName", "PortName", "Shared", "Published") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-Printer -ComputerName $ADSlave | Where {$_.Shared -like "True"} | Select Name,DriverName,PortName,Shared,Published | Out-UDGridData
}####### fin liste des imprimantes iemn-printers
New-UdGrid -Title "Queue Job" -Headers @("Nom") -Properties @("Name") -AutoRefresh -RefreshInterval 10 -Endpoint {
       $ADSlavePrint2 = Get-printer -ComputerName $ADSlave | select Name 
        ForEach($itemprintslave2 in $ADSlavePrint2)
       {Get-PrintJob -ComputerName $ADSlave -PrinterName $itemprintslave2.Name | Select * | Out-UDGridData}
}####### fin liste des jobs iemn-printers
New-UDButton -Text "Redémarrer le spooler" -Icon recycle -OnClick{
#set your first argument as $computer 
$computer = "cooper.iemn.fr" 
#Stop the service: 
#Get-WmiObject -Class Win32_Service -Filter 'name="spooler"' -ComputerName $computer | Invoke-WmiMethod -Name Stop-Service -Class Win32_Service | out-null
(get-service -ComputerName $computer -Name Spooler).Stop()
#Get-WmiObject -Class Win32_Service -Filter 'name="LPDSVC"' -ComputerName $computer | Invoke-WmiMethod -Name Stop-Service | out-null  
(get-service -ComputerName $computer -Name LPDSVC).Stop()
#Delete all items in: C:\windows\system32\spool\printers on the remote computer 
#the `$ is the escape charater to make sure powershell sees the $ as a charater rather than a variable 
Get-ChildItem "\\$computer\C`$\windows\system32\spool\printers" | Remove-Item 
#Start the service 
Set-Service spooler -ComputerName $computer -status Running
Set-Service LPDSVC -ComputerName $computer -status Running
Show-UDToast -Icon trash -IconColor "white" -MessageColor "#ec7331" -BackgroundColor "#ccc" -Duration 10000 -Message "On enlève les âneries et on recommence !"  
}#fin bouton reset spooler cooper
}# fin de la card
}#fin layout
 } -AuthorizedRole @("Direction", "Admin", "accueil", "carac", "dash", "copieur", "sfc") # fin page WPS
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
 } -AuthorizedRole @("Admin", "dash") # fin page SafeQ
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
} -AuthorizedRole @("Admin", "dash") #fin de page wapt
$page_kasc = New-UDPage -Name "Kaspersky EndPoint" -Icon bug -Content {
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
} -AuthorizedRole @("Admin", "dash") #fin de page kasc
$page_urbackup = New-UDPage -Name "UrBackup" -Icon save -Content {
New-UDCard -Title "Date et Heure" -Text "$date"
New-UDCollapsible -BackgroundColor "#333" -FontColor "#FFF" -Items {  
 New-UDCollapsible -Items  {
  New-UDCollapsibleItem -BackgroundColor "#333" -FontColor "#FFF" -Title "UrBackup ($urbackup)" -Icon save -Content {
   New-UDLayout -Columns 2 -Content { 
    New-UdChart -Title "Espace disques" -Type Bar -AutoRefresh -Endpoint {
   Get-CimInstance -ClassName Win32_LogicalDisk -ComputerName $urbackup | ForEach-Object {
          [PSCustomObject]@{ DeviceId = $_.DeviceID;
                        Size = [Math]::Round($_.Size / 1GB, 2);
                        FreeSpace = [Math]::Round($_.FreeSpace / 1GB, 2); } } | Out-UDChartData -LabelProperty "DeviceID" -Dataset @(
       New-UdChartDataset -DataProperty "Size" -Label "Taille" -BackgroundColor "cornflowerblue" -HoverBackgroundColor "cornflowerblue"
       New-UdChartDataset -DataProperty "FreeSpace" -Label "Espace Libre" -BackgroundColor "lightgreen" -HoverBackgroundColor "lightgreen"
   )
} ###### fin charts espace disque 
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
    New-UdGrid -Title "Services en cours" -Headers @("Nom", "Description") -Properties @("Name", "DisplayName") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-Service -ComputerName $urbackup | Where-Object {$_.Status -eq "Running"} | Select Name,DisplayName | Out-UDGridData
}####### fin services
    New-UdGrid -Title "Dernières séssions connectées" -Headers @("Date", "Nom") -Properties @("TimeCreated", "Message") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-WinEvent  -ComputerName $urbackup -FilterHashTable @{ LogName = "Microsoft-Windows-TerminalServices-LocalSessionManager/Operational"; ID = 21,25 } -MaxEvents 3 | Select-Object -Property "TimeCreated","Message" -ExpandProperty message | Out-UDGridData
}####### fin séssions connectées
    New-UdGrid -Title "Historique des mises à jour" -Headers @("Date", "Nom") -Properties @("TimeCreated", "Message") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-WinEvent -ComputerName $urbackup -FilterHashTable @{ LogName = "System"; ID = 43 } -MaxEvents 6 | Select-Object -Property "TimeCreated","Message" -ExpandProperty message | Out-UDGridData
}####### fin events maj
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
New-UDCard -Title "Tools" -Text "Quick Arès Monitoring"
New-UDRow -Columns {
    New-UDColumn -Size 6 -Content{
        New-UDButton -Icon cloud_upload -Text "Monter le Disque D: de backups" -OnClick{
            $ares_mount = new-PSsession -ComputerName 'ares.iemn.fr'
            Show-UDToast -Icon cloud_upload -IconColor "white" -MessageColor "#ec7331" -BackgroundColor "#ccc" -Duration 17000 -Message "On my Way !"
            Connect-WSMan -ComputerName "ares.iemn.fr"
            Set-Item -Path "WSMan:\ares.iemn.fr\Service\Auth\CredSSP" -Value $True
            Invoke-Command -Session $ares_mount -ScriptBlock {Mount-DiskImage -ImagePath "\\clust-file01.iemn.fr\iosbackup\iosbackup.vhdx"}
            Show-UDToast -Icon cloud_upload -IconColor "white" -MessageColor "#ec7331" -BackgroundColor "#ccc" -Duration 17000 -Message "vérifie, ça doit être bon !"
        }
    }
    New-UDColumn -Size 6 -Content{
        New-UdGrid -Title "Disques montés" -Headers @("Lettre lecteur", "Nom") -Properties @("Name", "VolumeName") -FontColor '#fff' -AutoRefresh -RefreshInterval 60 -Endpoint {
                Get-CimInstance -ClassName Win32_LogicalDisk -ComputerName 'ares.iemn.fr' | Select Name, VolumeName | Out-UDGridData
            }
    }
}
} -AuthorizedRole @("Admin", "dash") #fin de page urbackup
$page_Bitlocker = New-UDPage -Name "BitLocker & TPM" -Icon user_secret -Content {
    New-UdGrid -BackgroundColor '#333' -Title "Info Sécu" -FontColor '#fff' -Headers @("Name", "Recovery Passwd", "GUID") -Properties @("DistinguishedName","msfve-recoverypassword", "ObjectGUID") -AutoRefresh -RefreshInterval 600 -Endpoint {
        Get-ADObject -Server melinda.iemn.fr -Filter {objectclass -eq 'msFVE-RecoveryInformation'} -Properties * | Select DistinguishedName,msfve-recoverypassword,ObjectGUID | Out-UDGridData
    }
} -AuthorizedRole @("Admin", "dash") #fin page bitlocker
$page_infoADmonitor = New-UDPage -Name "Active Directories Infos" -Icon address_book -Content {
New-UDCard -Title "Infos Utiles" -Content{
New-UDParagraph -Text "Utilisateurs Active Directory" -Color "#fff"
New-UDRow -Columns{
    New-UDColumn -Size 4 -Content{
New-UDCounter -BackgroundColor "cornflowerblue" -Title "$users Utilisateurs au total" -Icon user_circle -TextSize 2 -AutoRefresh -RefreshInterval 60 -Endpoint {$users}
}# utilisateurs total
    New-UDColumn -Size 4 -Content{
New-UDCounter -BackgroundColor "lightgreen" -FontColor "#333" -Icon user_circle -Title "$users3 Utilisateurs actifs" -TextSize 2 -AutoRefresh -RefreshInterval 60 -Endpoint {$users3}
}# utilisateurs actifs
    New-UDColumn -Size 4 -Content{
New-UDCounter -BackgroundColor "#ec7331" -Title "$users2 Utilisateurs inactifs" -Icon user_circle -TextSize 2 -AutoRefresh -RefreshInterval 60 -Endpoint {$users2}
}# utilisateurs inactifs
    New-UDColumn -Size 4 -Content{
        $expiredpassword = (Get-ADUser -Filter * -Properties * | Select Name,AccountExpirationDate | Where {$_.AccountExpirationDate -notlike $null}).count
        if ($expiredpassword -le 0) {New-UDCounter -BackgroundColor "lightgreen" -FontColor "#333" -Icon user_circle -Title "$expiredpassword comptes ont une échéance" -TextSize 2 -AutoRefresh -RefreshInterval 60 -Endpoint {$expiredpassword}} elseif ($expiredpassword -le 19 -ge 1) {New-UDCounter -BackgroundColor "orange" -FontColor "#333" -Icon user_circle -Title "$expiredpassword comptes ont une échéance" -TextSize 2 -AutoRefresh -RefreshInterval 60 -Endpoint {$expiredpassword}} elseif ($expiredpassword -ge 20) {New-UDCounter -BackgroundColor "#EA5150" -FontColor "#fff" -Icon user_circle -Title "$expiredpassword comptes ont une échéance" -TextSize 2 -AutoRefresh -RefreshInterval 60 -Endpoint {$expiredpassword}}
    }# mot de passe expirés counter
    New-UDColumn -Size 8 -Content{
        New-UdGrid -Title "Comptes avec échéance" -Headers @("Nom", "Date") -Properties @("Name", "AccountExpirationDate") -PageSize 2 -DateTimeFormat "DD/MM/YY" -AutoRefresh -RefreshInterval 120 -Endpoint {
        Get-ADUser -Filter * -Properties * | Select Name,AccountExpirationDate | Where {$_.AccountExpirationDate -notlike $null} | Out-UDGridData
} ####### fin udgrid
}# mot de passe expirés
}# counters / mot de passe
New-UDRow -Columns {
New-UDColumn -Size 4 {
New-UDInput -Title “Enlever l'échèance d'un compte user” -Id “Form” -Content {
New-UDInputField -Type ‘textbox’ -Name ‘Text’ -Placeholder ‘Entrer l identifiant du user’
} -Endpoint {
param($Text)
#get-aduser -filter * -searchbase "dc=iemn,dc=fr" | where { $_.Name -like '$Text' } | set-aduser -passwordNeverExpires $true
Clear-ADAccountExpiration -Identity $Text
}
}
New-UDColumn -Size 4 {
New-UDInput -Title “Enlever l'échèance d'un mot de passe” -Id “delpasswordtime” -Content {
New-UDInputField -Type ‘textbox’ -Name ‘Textpassword’ -Placeholder ‘Entrer l identifiant du user’
} -Endpoint {
param($Textpassword)
get-aduser -filter * -searchbase "dc=iemn,dc=fr" | where { $_.Name -like ‘$Textpassword’ } | set-aduser -passwordNeverExpires:$true
}
}
New-UDColumn -Size 4 {
New-UDInput -Title “Déverrouiller un compte AD” -Id “unlockuser” -Content {
New-UDInputField -Type ‘textbox’ -Name ‘activeuser’ -Placeholder ‘Entrer l identifiant du user’
} -Endpoint {
param($activeuser)
Unlock-ADAccount $activeuser
}
}
New-UDRow -Columns{
New-UDColumn -Size 4 {
New-UDInput -Title “Supprimer un user” -Id “Formdeluser” -Content {
New-UDInputField -Type ‘textbox’ -Name ‘deluser’ -Placeholder ‘Entrer l identifiant du user’
} -Endpoint {
param($deluser)
Remove-ADUser $deluser -Confirm:$false
}
}
New-UDColumn -Size 4 {
New-UDInput -Title “Changer le mot de passe user” -Id “doknow” -Content {
New-UDInputField -Type ‘textbox’ -Name ‘idchangepasswd’ -Placeholder ‘Entrer le prénom identifiant du user’
New-UDInputField -Type ‘password’ -Name ‘userchangepass’ -Placeholder ‘Votre mot de passe’
} -Endpoint {
param($userchangepass,$idchangepasswd)
Set-ADAccountPassword -Identity $idchangepasswd -Reset -NewPassword (ConvertTo-SecureString -AsPlainText $userchangepass -Force)
}
}
New-UDColumn -Size 4 {
New-UDInput -Title “Ajouter un user au groupe” -Id “addusergroup” -Content {
New-UDInputField -Type ‘textbox’ -Name ‘idgroup’ -Placeholder ‘Entrer l identifiant du user’
New-UDInputField -Type ‘textbox’ -Name ‘group’ -Placeholder ‘Entrer le groupe souhaité’
} -Endpoint {
param($group,$idgroup)
Add-ADGroupMember -Identity $group -Members $idgroup
}
}
}
} #input users
New-UDRow -Columns {
New-UDColumn -Size 6 {
New-UDInput -Title “Supprimer un user du groupe” -Id “delusergroup” -Content {
New-UDInputField -Type ‘textbox’ -Name ‘iddel’ -Placeholder ‘Entrer l identifiant du user’
New-UDInputField -Type ‘textbox’ -Name ‘userdel’ -Placeholder ‘Entrer le groupe souhaité’
} -Endpoint {
param($userdel,$iddel)
Remove-ADGroupMember -Identity $userdel -Members $iddel -Confirm:$false
}
}
New-UDColumn -Size 6 {
New-UDInput -Title “Ajouter un user” -Id “useraddform” -Content {
New-UDInputField -Type ‘textbox’ -Name ‘useraddidsurname’ -Placeholder ‘Entrer le prénom du user’
New-UDInputField -Type ‘textbox’ -Name ‘useraddidname’ -Placeholder ‘Entrer le nom du user’
New-UDInputField -Type ‘password’ -Name ‘useradd’ -Placeholder ‘Entrer le mot de passe souhaité’
} -Endpoint {
param($useraddidsurname,$useraddidname,$useradd)
$useraddid = “$useraddidsurname.$useraddidname”
$useradiddisplayname = “$useraddidsurname $useraddidname”
New-ADUser -Server $ActiveDirectoryMaster -Name $useraddid -OtherAttributes @{'mail'="$useraddid@iemn.fr";'UserPrincipalName'="$useraddid@iemn.fr";'GivenName'="$useraddidsurname";'sn'="$useraddidname";'DistinguishedName'="CN=$useradiddisplayname,CN=Users,DC=iemn,DC=fr"} -SamAccountName "$useraddidsurname.$useraddidname" -CannotChangePassword:$true -Country "FR" -OtherName "$useraddidsurname $useraddidname" -DisplayName "$useraddidsurname $useraddidname" -Enabled:$true -PasswordNeverExpires:$true -AccountPassword (ConvertTo-SecureString -AsPlainText $useradd -Force) -PassThru
}
}
}
New-UDParagraph -Text "Ordinateurs Active Directory" -Color "#fff"
New-UDRow -Columns{
    New-UDColumn -Size 2 -Content{
        New-UDCounter -Title "Postes sous AD" -BackgroundColor "cornflowerblue" -TextSize 2 -Icon laptop -AutoRefresh -RefreshInterval 60 -Endpoint {$ADcomptotal}
    }
    New-UDColumn -Size 2 -Content{
        New-UDCounter -Title "Postes Windows xp" -BackgroundColor "#e95555" -TextSize 2 -Icon laptop -AutoRefresh -RefreshInterval 60 -Endpoint {$ADcompwinxp}
    }
    New-UDColumn -Size 2 -Content{
    New-UDCounter -Title "Postes Windows 7" -BackgroundColor "#ec7331" -TextSize 2 -Icon laptop -AutoRefresh -RefreshInterval 60 -Endpoint {$ADcompwin7}
    }
    New-UDColumn -Size 2 -Content{
        New-UDCounter -Title "Postes Windows 8 et 8.1" -FontColor "#333" -BackgroundColor "#ecb531" -TextSize 2 -Icon laptop -AutoRefresh -RefreshInterval 60 -Endpoint {$ADcompwin8}
    }
    New-UDColumn -Size 2 -Content{
        New-UDCounter -Title "Postes Windows 10" -FontColor "#333" -BackgroundColor "lightgreen" -TextSize 2 -Icon laptop -AutoRefresh -RefreshInterval 60 -Endpoint {$ADcompwin10}
    }
    New-UDColumn -Size 2 -Content{
        New-UDCounter -Title "Postes Server" -FontColor "#333" -BackgroundColor "lightgreen" -TextSize 2 -Icon server -AutoRefresh -RefreshInterval 60 -Endpoint {$ADcompwinserv}
    }
}
New-UDRow -Columns{
    New-UDColumn -Size 6 -Content{ 
        New-UDInput -Title “Joindre une machine au domaine” -Id “domain_add_comp” -Content {
        New-UDInputField -Type ‘textbox’ -Name ‘domain_add_comp_name’ -Placeholder ‘Entrer le nom de la machine’
        New-UDInputField -Type ‘textbox’ -Name ‘domain_add_comp_adminname’ -Placeholder ‘Entrer le nom de l admin de la machine <nom de machine>\admin local’
        New-UDInputField -Type ‘password’ -Name ‘domain_add_comp_adminpassword’ -Placeholder ‘Entrer le mot de passe de l admin de la machine’
        New-UDInputField -Type ‘textbox’ -Name ‘domain_add_comp_admindomainname’ -Placeholder ‘Entrer votre compte admin du domaine ’
        New-UDInputField -Type ‘password’ -Name ‘domain_add_comp_admindomainpassword’ -Placeholder ‘Entrer le mot de passe du compte admin du domaine’
        } -Endpoint {
        param($domain_add_comp_name,$domain_add_comp_adminname,$domain_add_comp_adminpassword,$domain_add_comp_admindomainname,$domain_add_comp_admindomainpassword)
        $domain_add_comp_admindomainpassword_converted = $domain_add_comp_admindomainpassword | ConvertTo-SecureString -asPlainText -Force
        $domain_add_comp_adminpassword_converted = $domain_add_comp_adminpassword | ConvertTo-SecureString -asPlainText -Force
        $credential_iemn = New-Object System.Management.Automation.PSCredential($domain_add_comp_admindomainname,$domain_add_comp_admindomainpassword_converted)
        $credential_local = New-Object System.Management.Automation.PSCredential($domain_add_comp_adminname,$domain_add_comp_adminpassword_converted)
        Add-Computer -ComputerName $domain_add_comp_name -DomainName iemn.fr -Credential $credential_iemn -restart –force -LocalCredential $credential_local
        }
    }
    New-UDColumn -Size 6 -Content{
        New-UDParagraph -Text "GPO & Groupes Active Directory" -Color "#fff"
        New-UDCounter -Title "Nombre total de groupes" -BackgroundColor "cornflowerblue" -Icon file -AutoRefresh -RefreshInterval 60 -Endpoint {$groups1}
        New-UDCounter -Title "Nombre total de gpo actives" -BackgroundColor "cornflowerblue" -Icon file -AutoRefresh -RefreshInterval 60 -Endpoint {$gpocount}
    }
}
}#fin infos utiles
New-UDRow -Columns{
    New-UDColumn -Size 6 -Content{
        New-UdGrid -Title "Forêt IEMN" -Headers @("Maître du domaine", "Niveau Fonctionnel", "Catalogue global", "Domaines") -Properties @("DomainNamingMaster", "ForestMode", "GlobalCatalogs", "Domains") -PageSize 7 -AutoRefresh -RefreshInterval 60 -Endpoint {
        Get-ADForest | Select DomainNamingMaster,ForestMode,GlobalCatalogs,Domains | Out-UDGridData
        }####### fin liste des comptes de Forêt AD
    }
    New-UDColumn -Size 6 -Content{
        New-UdGrid -Title "Comptes de services" -Headers @("Nom d'utilisateur", "Actif") -Properties @("SamAccountName", "Enabled") -PageSize 7 -AutoRefresh -RefreshInterval 60 -Endpoint {
        Get-ADServiceAccount  -Filter * | Select SamAccountName,Enabled | Out-UDGridData
        }####### fin liste des comptes de services
        
    }
}
New-UDRow -Columns{
    New-UDColumn -Size 6 -Content{
        New-UdGrid -Title "Utilisateurs" -Headers @("Nom d'utilisateur", "UID", "Actif") -Properties @("UserPrincipalName", "SamAccountName", "Enabled") -PageSize 7 -AutoRefresh -RefreshInterval 60 -Endpoint {
        Get-ADUser -Filter * -SearchBase "CN=Users,DC=iemn,DC=fr" | Select UserPrincipalName,SamAccountName,Enabled | Out-UDGridData
        }####### fin liste des comptes de users AD
    }
    New-UDColumn -Size 6 -Content{
        New-UdGrid -Title "Information Mot de passe et Filers_Profiles" -Headers @("Nom d'utilisateur", "Dernière connexion", "Dernier Changement de Passwd", "Filer Profil") -Properties @("Name", "LastLogonDate", "PasswordLastSet", "HomeDrive") -PageSize 7 -AutoRefresh -RefreshInterval 60 -Endpoint {
        Get-ADUser -Filter * -SearchBase "CN=Users,DC=iemn,DC=fr" -Properties * | Select Name,LastLogonDate,PasswordLastSet,HomeDrive | Out-UDGridData
        }####### fin liste des comptes de users AD
    }
}
New-UDRow -Columns{
    New-UDColumn -Size 6 -Content{
        New-UdGrid -Title "liste des groupes d'organisation" -Headers @("UO", "Type") -Properties @("CanonicalName", "DistinguishedName") -PageSize 7 -AutoRefresh -RefreshInterval 600 -Endpoint {
        $groups3 | Select CanonicalName,DistinguishedName | Out-UDGridData}
        }
    New-UDColumn -Size 6 -Content{
        New-UdGrid -Title "liste des groupes" -Headers @("Nom du groupe", "Type") -Properties @("SamAccountName", "GroupCategory") -PageSize 7 -AutoRefresh -RefreshInterval 600 -Endpoint {
       $groups2 | Select SamAccountName,GroupCategory | Out-UDGridData}
    }
}
New-UDRow -Columns{
    New-UDColumn -Size 6 -Content{
        New-UdGrid -Title "Postes clients sous AD" -Headers @("Noms DNS AD", "SamAccountName", "IP") -Properties @("DNSHostName", "SamAccountName", "IPv4Address") -PageSize 7 -DefaultSortColumn "DNSHostName" -DefaultSortDescending -AutoRefresh -RefreshInterval 60 -Endpoint {
        Get-ADComputer  -Filter * -SearchBase "CN=Computers,DC=iemn,DC=fr" -Properties * | Select DNSHostName,SamAccountName,IPv4Address | Out-UDGridData
        }####### fin liste des pc sous AD
    }
    New-UDColumn -Size 6 -Content{
        New-UdGrid -Title "GPO IEMN.FR" -Headers @("Nom de la GPO", "Domaine" ,"Propriètaire", "Status") -Properties @("DisplayName", "DomainName", "Owner", "GpoStatus") -DefaultSortDescending -AutoRefresh -RefreshInterval 60 -Endpoint {
        Get-GPO -All -Domain iemn.fr -Server 194.57.171.186 | Select DisplayName,DomainName,Owner,GpoStatus | Out-UDGridData
        }####### fin liste des serveurs applications 
    }
}
New-UDRow -Columns{
    New-UDColumn -Size 6 -Content{
       New-UdGrid -Title "Certificats AD" -Headers @("Date", "Nom") -Properties @("TimeCreated", "Message") -PageSize 7 -DefaultSortDescending -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-WinEvent -ComputerName 194.57.171.186 -FilterHashTable @{ LogName = "Active Directory Web Services"; ID = 1401 } -MaxEvents 1 | Select-Object -Property "TimeCreated","Message" -ExpandProperty message | Sort-Object -Property @{Expression={$_.TimeCreated}; Ascending=$false} | Out-UDGridData
        }####### fin events certAD
    }
    New-UDColumn -Size 6 -Content{
        New-UdGrid -Title "Etât des catalogues AD" -Headers @("Date", "Nom") -Properties @("TimeCreated", "Message") -PageSize 7 -DefaultSortDescending -AutoRefresh -RefreshInterval 60 -Endpoint {
        Get-WinEvent -ComputerName 194.57.171.186 -FilterHashTable  @{ LogName = "Directory Service"; ID = 1869 } -MaxEvents 1 | Select-Object -Property "TimeCreated","Message" -ExpandProperty message | Out-UDGridData
        }####### fin catalog ad events
    }
}
New-UDRow -Columns{
    New-UDColumn -Size 6 -Content{
       New-UdGrid -Title "AD Cohérence" -Headers @("Etat") -Properties @("Message") -PageSize 3 -DefaultSortDescending -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-WinEvent -ComputerName 194.57.171.186 -FilterHashTable @{ LogName = "Directory Service"; ID = 1104 } -MaxEvents 3 | Select-Object "Message" -ExpandProperty message | Out-UDGridData
        }####### fin coherence ad
    }
    New-UDColumn -Size 6 -Content{
        New-UdGrid -Title "Evénements DNS" -Headers @("Date", "Nom") -Properties @("TimeCreated", "Message") -PageSize 3 -DefaultSortDescending -AutoRefresh -RefreshInterval 60 -Endpoint {
        Get-WinEvent -ComputerName 194.57.171.186 -FilterHashTable @{ LogName = "DNS Server"; ID = 4,2,769 } -MaxEvents 2 | Select-Object -Property "TimeCreated","Message" -ExpandProperty message | Sort-Object -Property @{Expression={$_.TimeCreated}; Descending=$true} | Out-UDGridData
        }####### fin events dns
    }
}
New-UDRow -Columns{
    New-UDColumn -Size 6 -Content{
       New-UdGrid -Title "Historique des réplications AD" -Headers @("Date", "Nom") -Properties @("TimeCreated", "Message") -PageSize 3 -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-WinEvent -ComputerName 194.57.171.186 -FilterHashTable  @{ LogName = "Directory Service"; ID = 1083 } -MaxEvents 3 | Select-Object -Property "TimeCreated","Message" -ExpandProperty message | Out-UDGridData
        }####### fin repl ad events
    }
    New-UDColumn -Size 6 -Content{
       New-UdGrid -Title "Erreurs de réplications" -Headers @("Date", "Nom") -Properties @("TimeCreated", "Message") -DefaultSortDescending -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-WinEvent -ComputerName 194.57.171.186 -FilterHashTable  @{ LogName = "Directory Service"; ID = 1308 } -MaxEvents 3 | Select-Object -Property "TimeCreated","Message" -ExpandProperty message | Out-UDGridData
        }####### fin Erreurs de repl ad events
    }
}
New-UDRow -Columns{
    New-UDColumn -Size 6 -Content{
       New-UdGrid -Title "Historique KES" -Headers @("Date", "Nom") -Properties @("TimeCreated", "Message") -PageSize 3 -DefaultSortDescending -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-WinEvent -ComputerName 194.57.171.186 -FilterHashTable  @{ LogName = "Kaspersky Security"; ID = 6755 } -MaxEvents 1 | Select-Object -Property "TimeCreated","Message" -ExpandProperty message | Out-UDGridData
       }####### fin kasc ad events
    }
}
} -AuthorizedRole @("Admin", "dash") # fin page ad infos 
$page_infoclustmonitor = New-UDPage -Name "Cluster Hyper-V Infos" -Icon windows -Content {
New-UdGrid -BackgroundColor '#333' -FontColor '#fff' -Title "Cluster Hyper-V" -Headers @("Nom du serveur") -Properties @("Name") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-Cluster -Name $Hyperviseur | Select Name | Out-UDGridData
}####### fin liste des serveurs applications
New-UDRow -Columns{
New-UDColumn -Size 3 -Content{
New-UDParagraph -Text "Status des Nodes sur Hyper-V" -Color "#fff"
New-UDCounter -BackgroundColor "cornflowerblue" -Title "$nodes Nodes" -Icon server -TextSize 2 -AutoRefresh -RefreshInterval 60 -Endpoint {$nodes}
New-UDCounter -FontColor '#333' -BackgroundColor "lightgreen" -Title "$nodesup Node(s) Online" -Icon server -TextSize 2 -AutoRefresh -RefreshInterval 60 -Endpoint {$nodesup}
New-UDCounter -FontColor '#fff' -BackgroundColor "#e95555" -Title "$nodesdown Node(s) Offline" -Icon server -TextSize 2 -AutoRefresh -RefreshInterval 60 -Endpoint {$nodesdown}
New-UDParagraph -Text "Status des VMs sur Hyper-V" -Color "#fff"
New-UDCounter -BackgroundColor "cornflowerblue" -Title "$vmnumbers VM" -Icon laptop -TextSize 2 -AutoRefresh -RefreshInterval 60 -Endpoint {$vmnumbers}
New-UDCounter -FontColor '#333' -BackgroundColor "lightgreen" -Title "$vmnumbersup VM Online" -Icon laptop -TextSize 2 -AutoRefresh -RefreshInterval 60 -Endpoint {$vmnumbersup}
New-UDCounter -FontColor '#fff' -BackgroundColor "#e95555" -Title "$vmnumbersdown VM Offline" -Icon laptop -TextSize 2 -AutoRefresh -RefreshInterval 60 -Endpoint {$vmnumbersdown}
New-UDParagraph -Text "Status VCARD LAN VMs" -Color "#fff"
New-UDCounter -BackgroundColor "cornflowerblue" -Title "$vmvlan VLANCard" -Icon link -TextSize 2 -AutoRefresh -RefreshInterval 60 -Endpoint {$vmvlan}
New-UDCounter -FontColor '#333' -BackgroundColor "lightgreen" -Title "$vmvlanup VLANCard Online" -Icon link -TextSize 2 -AutoRefresh -RefreshInterval 60 -Endpoint {$vmvlanup}
New-UDCounter -FontColor '#fff' -BackgroundColor "#ec7331" -Title "$vmvlanwarn VLANCard à mettre à jour" -Icon link -TextSize 2 -AutoRefresh -RefreshInterval 60 -Endpoint {$vmvlanwarn}
New-UDCounter -FontColor '#fff' -BackgroundColor "#e95555" -Title "$vmvlandown VLANCard Offline" -Icon link -TextSize 2 -AutoRefresh -RefreshInterval 60 -Endpoint {$vmvlandown}
}#fin column Status des noeuds
New-UDColumn -Size 3 -Content{
    New-UDParagraph -Text "VMs up et Utilisation CPU(%) par Noeuds" -Color "#fff"
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
New-UdGrid -Title "Noeuds Hyper-V" -Headers @("Nom", "ID", "State") -Properties @("Name", "ID", "State") -FontColor '#fff' -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-ClusterNode -Cluster  $Hyperviseur | Select Name,ID,State | Out-UDGridData
}####### fin liste des serveurs applications
New-UdGrid -Title "homes VSAN Hyper-V" -Headers @("Nom", "State") -Properties @("Name", "State") -FontColor '#fff' -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-ClusterResource -Cluster $Hyperviseur -Name "Serveur de fichiers (\\homes)" | Select Name,State | Out-UDGridData
}####### fin liste des serveurs applications
New-UdGrid -Title "Quorum Noeuds Hyper-V" -Headers @("Nom", "Status") -Properties @("Name", "State") -FontColor '#fff' -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-ClusterResource -Cluster $Hyperviseur -Name "Quorum" | Select Name,State | Out-UDGridData
}####### fin liste des serveurs applications
New-UdGrid -Title "VLAN Noeuds Hyper-V" -Headers @("Nom", "Status") -Properties @("Name", "State") -FontColor '#fff' -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-ClusterResource -Cluster $Hyperviseur | where ResourceType -EQ "IP Address" | where Name -NotLike "sin-city" | Select Name,State | Out-UDGridData
       }####### fin liste des serveurs applications
}#fin column
New-UDColumn -Size 6 -Content{
            New-UdGrid -Title "Liste des Serveurs Windows (hors VM's O.S client, thor, ares, ...)" -Headers @("Nom", "O.S") -Properties @("Name", "OperatingSystem") -PageSize 9 -AutoRefresh -RefreshInterval 60 -Endpoint {
                Get-ADComputer -Properties Name,OperatingSystem -Filter {OperatingSystem -like "*Server*" -AND Name -notlike "*XenApp-34*"} | Select Name,OperatingSystem  | Out-UDGridData
            }####### fin udgrid
    }
New-UDColumn -Size 6 -Content{
New-UdGrid -BackgroundColor '#333' -FontColor '#fff' -Title "Liste des VMs Hyper-V" -Headers @("Nom de la VM", "Etât") -Properties @("Name", "State") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-Cluster –Name $Hyperviseur | Get-ClusterGroup | Select Name, State  | Out-UDGridData
}####### fin liste des vms
New-UdGrid -BackgroundColor '#333' -FontColor '#fff' -Title "Liste des Rôles Hyper-V" -Headers @("Nom de la VM", "Etât") -Properties @("Name", "State") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-Cluster –Name $Hyperviseur | Get-ClusterGroup | Get-ClusterResource | Select Name,State | Out-UDGridData
}####### fin liste des vms
New-UdGrid -BackgroundColor '#333' -FontColor '#fff' -Title "Détails des VMs Hyper-V" -Headers @("Nom de la VM", "Etât", "Utilisation CPU %", "Mémoire Allouée", "Version Hyper-V") -Properties @("Name", "Status", "CPUUsage", "MemoryAssigned", "Version") -AutoRefresh -RefreshInterval 60 -Endpoint {
       Get-VM –ComputerName (Get-ClusterNode –Cluster $Hyperviseur) | Select Name,Status,CPUUsage,MemoryAssigned,Version | Out-UDGridData
}####### fin liste des vms
New-UdGrid -BackgroundColor '#333' -FontColor '#fff' -Title "Détails Réseau des VMs Hyper-V" -Headers @("Nom de la VM", "Nom du VSwitch", "Adresse MAC") -Properties @("VMName", "SwitchName", "MacAddress") -AutoRefresh -RefreshInterval 10 -Endpoint {
$vmconf = Get-VM -ComputerName (Get-ClusterNode -Cluster sin-city.iemn.fr) | select Name 
ForEach($itemvmconf in $vmconf)
{Get-VMNetworkAdapter -ComputerName (Get-ClusterNode -Cluster sin-city.iemn.fr) -VMName $itemvmconf.Name | select VMName,SwitchName,MacAddress | Out-UDGridData} 
}####### fin liste confs réseau des vms
}#fin column
}# fin row
} -AuthorizedRole @("Direction", "Admin", "dash") #fin page cluster
$page_filers = New-UDPage -Name "Filers Infos" -Icon file -Content {
New-UDCard -Title "$filer1" -Content{
New-UDRow -Columns{
$cim2 = New-CimSession -ComputerName $Node1
New-UDColumn -Size 3 -Content{
$lciserv2count = (Get-SMBOpenFile -CimSession $cim2).count
$lciserv2count2 = (Get-SMBShare -CimSession $cim2).count
if ($lciserv2count -ge 11) {New-UDCounter -BackgroundColor "lightgreen" -FontColor "#333" -Icon print -Title "$lciserv2count Dossier(s) ouvert(s)" -TextSize 2 -AutoRefresh -RefreshInterval 60 -Endpoint {$lciserv2count}} elseif ($lciserv2count -le 10 -ge 6) {New-UDCounter -BackgroundColor "orange" -FontColor "#333" -Icon print -Title "$lciserv2count Dossier(s) ouvert(s)" -TextSize 2 -AutoRefresh -RefreshInterval 60 -Endpoint {$lciserv2count}} elseif ($lciserv2count -le 5 -ge 0) {New-UDCounter -BackgroundColor "red" -FontColor "#333" -Icon print -Title "$lciserv2count Dossier(s) ouvert(s)" -TextSize 2 -AutoRefresh -RefreshInterval 60 -Endpoint {$lciserv2count}}
if ($lciserv2count2 -ge 30) {New-UDCounter -BackgroundColor "lightgreen" -FontColor "#333" -Icon print -Title "$lciserv2count2 Dossier(s) partagé(s)" -TextSize 2 -AutoRefresh -RefreshInterval 60 -Endpoint {$lciserv2count2}} elseif ($lciserv2count2 -le 29 -ge 5) {New-UDCounter -BackgroundColor "orange" -FontColor "#333" -Icon print -Title "$lciserv2count2 Dossier(s) partagé(s)" -TextSize 2 -AutoRefresh -RefreshInterval 60 -Endpoint {$lciserv2count2}} elseif ($lciserv2count2 -le 5 -ge 0) {New-UDCounter -BackgroundColor "red" -FontColor "#333" -Icon print -Title "$lciserv2count2 Dossier(s) partagé(s)" -TextSize 2 -AutoRefresh -RefreshInterval 60 -Endpoint {$lciserv2count2}}
}#fin udcolumn 1
New-UDColumn -Size 9 -Content{
New-UdGrid -Title "Dossier(s) ouvert(s) $filer1" -Headers @("Nom") -Properties @("Path") -PageSize 3 -AutoRefresh -RefreshInterval 60 -Endpoint {
    Get-SMBOpenFile -CimSession $cim2 | select Path | Out-UDGridData
}#fin grid
}#fin udcolumn 2
}#fin Row
New-UDRow -Columns{
$cim1 = New-CimSession -ComputerName $Node1
New-UDColumn -Size 7 -Content{
New-UdGrid -Title "Dossiers Partagés $filer1" -Headers @("Nom", "Description", "Data cryptée", "Utilisateurs connectés", "Chemin") -Properties @("Name", "Description", "EncryptData", "CurrentUsers", "Path") -PageSize 6 -AutoRefresh -RefreshInterval 60 -Endpoint {
Get-SmbShare -CimSession $cim1 | where {$_.ScopeName -like "homes"} | Select * | Out-UDGridData 
}#fin udgrid
}#fin udcolumn
New-UDColumn -Size 5 -Content{
New-UdChart -Title "Espace disques" -Type Bar -AutoRefresh -Endpoint {
   Get-CimInstance -ClassName Win32_LogicalDisk -ComputerName $Node1 | Where {$_.VolumeName -like "LCIServ"} | ForEach-Object {
          [PSCustomObject]@{ DeviceId = $_.DeviceID;
                        Size = [Math]::Round($_.Size / 1GB, 2);
                        FreeSpace = [Math]::Round($_.FreeSpace / 1GB, 2); } } | Out-UDChartData -LabelProperty "DeviceID" -Dataset @(
       New-UdChartDataset -DataProperty "FreeSpace" -Label "Espace Libre." -BackgroundColor "lightgreen" -HoverBackgroundColor "lightgreen"
       New-UdChartDataset -DataProperty "Size" -Label "Espace Disque." -BackgroundColor "cornflowerblue" -HoverBackgroundColor "cornflowerblue"
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
                ticks = @{
                        beginAtZero = $true
                    }
            }
        )
    }
}###### fin charts séssions
}#fin column 2
}#fin row
}#fin card
New-UDCard -Title "$filer2" -Content{
New-UDRow -Columns{
$clustcim2 = New-CimSession -ComputerName $filer2
New-UDColumn -Size 3 -Content{
$clustcount = (Get-SMBOpenFile -CimSession $clustcim2).count
$clustcount2 = (Get-SMBShare -CimSession $clustcim2 | Where {$_.Path -like "G:\Shares\*"}).count
if ($clustcount -ge 100) {New-UDCounter -BackgroundColor "lightgreen" -FontColor "#333" -Icon print -Title "$clustcount fichier(s) ouvert(s)" -TextSize 2 -AutoRefresh -RefreshInterval 60 -Endpoint {$clustcount}} elseif ($clustcount -le 99 -ge 1) {New-UDCounter -BackgroundColor "orange" -FontColor "#333" -Icon print -Title "$clustcount Fichier(s) ouvert(s)" -TextSize 2 -AutoRefresh -RefreshInterval 60 -Endpoint {$clustcount}} elseif ($clustcount -le 1 -ge 0) {New-UDCounter -BackgroundColor "red" -FontColor "#333" -Icon print -Title "$clustcount Fichiers(s) ouvert(s)" -TextSize 2 -AutoRefresh -RefreshInterval 60 -Endpoint {$clustcount}}
if ($clustcount2 -ge 2) {New-UDCounter -BackgroundColor "lightgreen" -FontColor "#333" -Icon print -Title "$clustcount2 Dossier(s) partagé(s)" -TextSize 2 -AutoRefresh -RefreshInterval 60 -Endpoint {$clustcount2}} elseif ($clustcount2 -le 1 -ge 1) {New-UDCounter -BackgroundColor "orange" -FontColor "#333" -Icon print -Title "$clustcount2 Dossier(s) partagé(s)" -TextSize 2 -AutoRefresh -RefreshInterval 60 -Endpoint {$clustcount2}} elseif ($clustcount2 -le 0) {New-UDCounter -BackgroundColor "red" -FontColor "#333" -Icon print -Title "$clustcount2 Dossier(s) partagé(s)" -TextSize 2 -AutoRefresh -RefreshInterval 60 -Endpoint {$clustcount2}}
}#fin udcolumn 1
New-UDColumn -Size 9 -Content{
New-UdGrid -Title "Dossier(s) ouvert(s) $filer2" -Headers @("Nom", "Utilisateur", "PC") -Properties @("Path", "ClientUserName", "ClientComputerName") -PageSize 3 -AutoRefresh -RefreshInterval 60 -Endpoint {
    Get-SMBOpenFile -CimSession $clustcim2 | select Path,ClientUserName,ClientComputerName | Out-UDGridData
}#fin grid
}#fin udcolumn 2
}#fin Row
New-UDRow -Columns{
$clustcim1 = New-CimSession -ComputerName $filer2
New-UDColumn -Size 7 -Content{
New-UdGrid -Title "Dossiers Partagés $filer2" -Headers @("Nom", "Description", "Data cryptée", "Utilisateurs connectés", "Chemin") -Properties @("Name", "Description", "EncryptData", "CurrentUsers", "Path") -PageSize 6 -AutoRefresh -RefreshInterval 60 -Endpoint {
Get-SmbShare -CimSession $clustcim1 | where {$_.Path -like "*Shares*"} | Select * | Out-UDGridData 
}#fin udgrid
}#fin udcolumn
New-UDColumn -Size 5 -Content{
New-UdChart -Title "Espace disques" -Type Bar -AutoRefresh -Endpoint {
   Get-CimInstance -ClassName Win32_LogicalDisk -ComputerName $filer2 | Where {$_.DeviceID -eq "G:" -or $_.DeviceID -eq "H:"} | ForEach-Object {
          [PSCustomObject]@{ DeviceId = $_.DeviceID;
                        Size = [Math]::Round($_.Size / 1GB, 2);
                        FreeSpace = [Math]::Round($_.FreeSpace / 1GB, 2); } } | Out-UDChartData -LabelProperty "DeviceID" -Dataset @(
       New-UdChartDataset -DataProperty "FreeSpace" -Label "Espace Libre." -BackgroundColor "lightgreen" -HoverBackgroundColor "lightgreen"
       New-UdChartDataset -DataProperty "Size" -Label "Espace Disque." -BackgroundColor "cornflowerblue" -HoverBackgroundColor "cornflowerblue"
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
                ticks = @{
                        beginAtZero = $true
                    }
            }
        )
    }
}###### fin charts séssions
}#fin column 2
}#fin row
}#fin card
} -AuthorizedRole @("Admin", "carac", "Direction", "dash") #fin page filers

$page_Teletexte = New-UDPage -Name "Teletexte IEMN" -Icon gamepad -AutoRefresh $true -RefreshInterval 60 -Content {
    $teletexte_names = Get-ADComputer -Filter * -Properties * | Where {$_.DNSHostName -like "Vim*.iemn.fr"} | Select DNSHostName
    $teletexte_count = ($teletexte_names).count
    New-UDRow -Columns {
        New-UDColumn -Size 6 -Content{
            New-UDCounter -BackgroundColor "cornflowerblue" -Title "$teletexte_count Téletexte(s)" -Icon desktop -TextSize 2 -AutoRefresh -RefreshInterval 60 -Endpoint {$teletexte_count}
            New-UDButton -Icon cloud_upload -Text "Uploader la vidéo par défaut" -OnClick{
                Show-UDToast -Icon cloud_upload -IconColor "white" -MessageColor "#ec7331" -BackgroundColor "#ccc" -Duration 17000 -Message "On my Way !"
                $teletexte_vid = new-PSsession -ComputerName 'vim1.iemn.fr','vim2.iemn.fr','vim3.iemn.fr','vim4.iemn.fr','vim5.iemn.fr'
                Show-UDToast -Icon cloud_upload -IconColor "white" -MessageColor "#ec7331" -BackgroundColor "#ccc" -Duration 5000 -Message "Je me suis connecté à toutes les TV allumées !"
                Start-Sleep -Seconds 5 
                Show-UDToast -Icon cloud_upload -IconColor "white" -MessageColor "#ec7331" -BackgroundColor "#ccc" -Duration 5000 -Message "J'arrête VLC sur toutes les TV allumées !" 
                Invoke-Command -Session $teletexte_vid -ScriptBlock {Get-Process | Where {$_.ProcessName -like 'vlc'} | Stop-Process -Force}
                Start-Sleep -Seconds 5
                Show-UDToast -Icon cloud_upload -IconColor "white" -MessageColor "#ec7331" -BackgroundColor "#ccc" -Duration 5000 -Message "Encore une étape de franchie, je suis trop bon !"
                Start-Sleep -Seconds 5
                Show-UDToast -Icon cloud_upload -IconColor "white" -MessageColor "#ec7331" -BackgroundColor "#ccc" -Duration 5000 -Message "J'upload la nouvelle vidéo.mp4 par défaut ! (partage-dao\38-TELETEXTE\Films\)"
                Start-Sleep -Seconds 5
                $teletexte_vid1 = New-PSSession -ComputerName 'vim1.iemn.fr'
                $teletexte_vid2 = New-PSSession -ComputerName 'vim2.iemn.fr'
                $teletexte_vid3 = New-PSSession -ComputerName 'vim3.iemn.fr'
                $teletexte_vid4 = New-PSSession -ComputerName 'vim4.iemn.fr'
                $teletexte_vid5 = New-PSSession -ComputerName 'vim5.iemn.fr'
                Copy-Item –Path '\\lciserv2.iemn.fr\partage-dao\38-TELETEXTE\Films\video.mp4' –Destination 'C:\Logo\' -Force –ToSession $teletexte_vid1
                Show-UDToast -Icon cloud_upload -IconColor "white" -MessageColor "#ec7331" -BackgroundColor "#ccc" -Duration 5000 -Message "vidéo copiée sur vim1"
                Copy-Item –Path '\\lciserv2.iemn.fr\partage-dao\38-TELETEXTE\Films\video.mp4' –Destination 'C:\Logo\' -Force –ToSession $teletexte_vid2
                Show-UDToast -Icon cloud_upload -IconColor "white" -MessageColor "#ec7331" -BackgroundColor "#ccc" -Duration 5000 -Message "vidéo copiée sur vim2"
                Copy-Item –Path '\\lciserv2.iemn.fr\partage-dao\38-TELETEXTE\Films\video.mp4' –Destination 'C:\Logo\' -Force –ToSession $teletexte_vid3
                Show-UDToast -Icon cloud_upload -IconColor "white" -MessageColor "#ec7331" -BackgroundColor "#ccc" -Duration 5000 -Message "vidéo copiée sur vim3"
                Copy-Item –Path '\\lciserv2.iemn.fr\partage-dao\38-TELETEXTE\Films\video.mp4' –Destination 'C:\Logo\' -Force –ToSession $teletexte_vid4
                Show-UDToast -Icon cloud_upload -IconColor "white" -MessageColor "#ec7331" -BackgroundColor "#ccc" -Duration 5000 -Message "vidéo copiée sur vim4"
                Copy-Item –Path '\\lciserv2;iemn.fr\partage-dao\38-TELETEXTE\Films\video.mp4' –Destination 'C:\Logo\' -Force –ToSession $teletexte_vid5
                Show-UDToast -Icon cloud_upload -IconColor "white" -MessageColor "#ec7331" -BackgroundColor "#ccc" -Duration 5000 -Message "vidéo copiée sur vim5"
                Show-UDToast -Icon cloud_upload -IconColor "white" -MessageColor "#ec7331" -BackgroundColor "#ccc" -Duration 5000 -Message "c'est ok, en tous cas, j'ai fais le max, il suffit de cliquer sur rédémarrer toutes les TV" 
                
            }
            New-UDButton -Icon recycle -Text "Redémarrer toutes les TV" -OnClick{
                # foreach TV reboot
                Show-UDToast -Icon cloud_upload -IconColor "white" -MessageColor "#ec7331" -BackgroundColor "#ccc" -Duration 5000 -Message "Je lance la demande !" 
                shutdown -r -m '\\vim1.iemn.fr' -t 0 -f
                Start-Sleep -Seconds 5
                Show-UDToast -Icon cloud_upload -IconColor "white" -MessageColor "#ec7331" -BackgroundColor "#ccc" -Duration 5000 -Message "demande lancée sur vim1"
                shutdown -r -m '\\vim2.iemn.fr' -t 0 -f
                Start-Sleep -Seconds 5
                Show-UDToast -Icon cloud_upload -IconColor "white" -MessageColor "#ec7331" -BackgroundColor "#ccc" -Duration 5000 -Message "demande lancée sur vim2"
                shutdown -r -m '\\vim3.iemn.fr' -t 0 -f
                Start-Sleep -Seconds 5
                Show-UDToast -Icon cloud_upload -IconColor "white" -MessageColor "#ec7331" -BackgroundColor "#ccc" -Duration 5000 -Message "demande lancée sur vim3"
                shutdown -r -m '\\vim4.iemn.fr' -t 0 -f
                Start-Sleep -Seconds 5
                Show-UDToast -Icon cloud_upload -IconColor "white" -MessageColor "#ec7331" -BackgroundColor "#ccc" -Duration 5000 -Message "demande lancée sur vim4"
                shutdown -r -m '\\vim5.iemn.fr' -t 0 -f
                Start-Sleep -Seconds 5
                Show-UDToast -Icon cloud_upload -IconColor "white" -MessageColor "#ec7331" -BackgroundColor "#ccc" -Duration 5000 -Message "demande lancée sur vim5"
                Start-Sleep -Seconds 5
                Show-UDToast -Icon cloud_upload -IconColor "white" -MessageColor "#ec7331" -BackgroundColor "#ccc" -Duration 5000 -Message "Compter 2 minutes, les TV redémarrent !" 

            }
            #$button_remote_teletexte = New-UDButton -Icon desktop -Text "Voir les écrans de TV (option non disponible)"
            #$button_remote_teletexte.Attributes.href = "http://lci-remote.iemn.fr"
            #$button_remote_teletexte
        }
        New-UDColumn -Size 6 -Content{
            New-UdGrid -Title "Noms des Tv" -Headers @("Nom", "IPv4Address", "Description") -Properties @("DNSHostName", "IPv4Address", "Description") -FontColor '#fff' -AutoRefresh -RefreshInterval 10 -Endpoint {
                Get-ADComputer -Filter * -Properties * | Where {$_.DNSHostName -like "Vim*.iemn.fr"} | Select DNSHostName,IPv4Address,Description | Out-UDGridData
            }
        }
        }
    New-UDRow  -Columns {
        New-UDColumn -Size 3 -Content{
            New-UDInput -Title “Jouer une vidéo différente sur une TV” -Id “formOtherPlay” -Content {
                New-UDInputField -Type ‘textbox’ -Name ‘OtherPlayTV’ -Placeholder ‘Entrer le nom de la TV sur laquelle la vidéo doit être jouée’
            } -Endpoint {
            param($OtherPlayTV)
                $teletexte_alone_vid = new-PSsession -ComputerName $OtherPlayTV
                    Invoke-Command -Session $teletexte_alone_vid -ScriptBlock {Get-Process | Where {$_.ProcessName -like 'vlc'} | Stop-Process -Force}
                    Copy-Item –Path '\\lciserv2\partage-dao\38-TELETEXTE\Films\tv_unique\video.mp4' –Destination 'C:\Logo\' –ToSession $teletexte_alone_vid
                    Show-UDToast -Icon cloud_upload -IconColor "white" -MessageColor "#ec7331" -BackgroundColor "#ccc" -Duration 5000 -Message "vidéo copiée, vous pouvez redémarrer la TV"
            }
            }# lancer une vidéo différente sur chaque TV
        New-UDColumn -Size 3 -Content{
            New-UDInput -Title “Redemarrer une TV” -Id “Formstickreboot” -Content {
                New-UDInputField -Type ‘textbox’ -Name ‘rebootstick’ -Placeholder ‘Entrer l ip du stick ou le nom complet’
            } -Endpoint {
            param($rebootstick)
                shutdown -r -m \\$rebootstick -f
                Show-UDToast -Icon cloud_upload -IconColor "white" -MessageColor "#ec7331" -BackgroundColor "#ccc" -Duration 5000 -Message "Redémarrage machine demandé, attendez 1 minute"
            }
            }# redémarrer une ComputeStick
        New-UDCOlumn -Size 3 -Content{
            New-UdGrid -Title "Videos disponibles" -Headers @("Nom") -Properties @("Name") -FontColor '#fff' -AutoRefresh -RefreshInterval 60 -Endpoint {
                Get-ChildItem '\\lciserv2\partage-dao\38-TELETEXTE\Films' | Select Name | Out-UDGridData
            }
        }# videos dispos sur le filer
        New-UDColumn -Size 3 -Content{
            New-UDCard -Title "Etât des TV" -TextSize Medium -Content{
            $vim1_ping = Test-Connection -BufferSize 32 -Count 1 -ComputerName 'vim1.iemn.fr' -Quiet
            $vim2_ping = Test-Connection -BufferSize 32 -Count 1 -ComputerName 'vim2.iemn.fr' -Quiet
            $vim3_ping = Test-Connection -BufferSize 32 -Count 1 -ComputerName 'vim3.iemn.fr' -Quiet
            $vim4_ping = Test-Connection -BufferSize 32 -Count 1 -ComputerName 'vim4.iemn.fr' -Quiet
            $vim5_ping = Test-Connection -BufferSize 32 -Count 1 -ComputerName 'vim5.iemn.fr' -Quiet
            if ($vim1_ping -like "True" ) {New-UDElement -tag "div" -Id "vim1_ping" -AutoRefresh -RefreshInterval 60 -Content{"La TV du hall est allumée"}} else{New-UDElement -tag "div" -Id "vim1_ping_down" -AutoRefresh -RefreshInterval 60 -Content{"La TV du hall est éteinte"}}
            if ($vim3_ping -like "True" ) {New-UDElement -tag "div" -Id "vim2_ping" -AutoRefresh -RefreshInterval 60 -Content{"La TV E.C.M est allumée"}} else{New-UDElement -tag "div" -Id "vim2_ping_down" -AutoRefresh -RefreshInterval 60 -Content{"La TV E.C.M est éteinte"}}
            if ($vim4_ping -like "True" ) {New-UDElement -tag "div" -Id "vim3_ping" -AutoRefresh -RefreshInterval 60 -Content{"La TV du 1er étage côté hall est allumée"}} else{New-UDElement -tag "div" -Id "vim3_ping_down" -AutoRefresh -RefreshInterval 60 -Content{"La TV du 1er étage côté hall est éteinte"}}
            if ($vim5_ping -like "True" ) {New-UDElement -tag "div" -Id "vim4_ping" -AutoRefresh -RefreshInterval 60 -Content{"La TV du 2nd étage côté hall est allumée"}} else{New-UDElement -tag "div" -Id "vim4_ping_down" -AutoRefresh -RefreshInterval 60 -Content{"La TV du 2nd étage côté hall est éteinte"}}
            if ($vim2_ping -like "True" ) {New-UDElement -tag "div" -Id "vim5_ping" -AutoRefresh -RefreshInterval 60 -Content{"La TV du 3eme étage côté hall est allumée"}} else{New-UDElement -tag "div" -Id "vim5_ping_down" -AutoRefresh -RefreshInterval 60 -Content{"La TV du 3eme étage côté hall est éteinte"}}
            }
        }# état des sticks
    }
} -AuthorizedRole @("Direction", "ECM", "dash", "Admin")  #fin page Teletexte
$page_TeleNew = New-UDPage -Name "Teletext IEMN" -Icon gamepad -AutoRefresh $true -RefreshInterval 60 -Content {
    $teletexte_names = Get-ADComputer -Filter * -Properties * | Where {$_.DNSHostName -like "Vim*.iemn.fr"} | Select DNSHostName
    $teletexte_count = ($teletexte_names).count
    New-UDRow -Columns {
        New-UDColumn -Size 6 -Content{
            New-UDCounter -BackgroundColor "cornflowerblue" -Title "$teletexte_count Téletexte(s)" -Icon desktop -TextSize 2 -AutoRefresh -RefreshInterval 60 -Endpoint {$teletexte_count}
            New-UDButton -Icon cloud_upload -Text "Uploader la vidéo par défaut" -OnClick{
                Show-UDToast -Icon cloud_upload -IconColor "white" -MessageColor "#ec7331" -BackgroundColor "#ccc" -Duration 17000 -Message "On my Way !"
                $teletexte_vid = new-PSsession -ComputerName 'vim1.iemn.fr','vim2.iemn.fr','vim3.iemn.fr','vim4.iemn.fr','vim5.iemn.fr'
                Show-UDToast -Icon cloud_upload -IconColor "white" -MessageColor "#ec7331" -BackgroundColor "#ccc" -Duration 5000 -Message "Je me suis connecté à toutes les TV allumées !"
                Start-Sleep -Seconds 5 
                Show-UDToast -Icon cloud_upload -IconColor "white" -MessageColor "#ec7331" -BackgroundColor "#ccc" -Duration 5000 -Message "J'arrête VLC sur toutes les TV allumées !" 
                Invoke-Command -Session $teletexte_vid -ScriptBlock {Get-Process | Where {$_.ProcessName -like 'vlc'} | Stop-Process -Force}
                Start-Sleep -Seconds 5
                Show-UDToast -Icon cloud_upload -IconColor "white" -MessageColor "#ec7331" -BackgroundColor "#ccc" -Duration 5000 -Message "Encore une étape de franchie, je suis trop bon !"
                Start-Sleep -Seconds 5
                Show-UDToast -Icon cloud_upload -IconColor "white" -MessageColor "#ec7331" -BackgroundColor "#ccc" -Duration 5000 -Message "J'upload la nouvelle vidéo.mp4 par défaut ! (partage-dao\38-TELETEXTE\Films\)"
                Start-Sleep -Seconds 5
                $teletexte_vid1 = New-PSSession -ComputerName 'vim1.iemn.fr'
                $teletexte_vid2 = New-PSSession -ComputerName 'vim2.iemn.fr'
                $teletexte_vid3 = New-PSSession -ComputerName 'vim3.iemn.fr'
                $teletexte_vid4 = New-PSSession -ComputerName 'vim4.iemn.fr'
                $teletexte_vid5 = New-PSSession -ComputerName 'vim5.iemn.fr'
                Copy-Item –Path '\\clust-file01\Teletexte\Films\Fichier_travail\video.mp4' –Destination 'C:\Logo\' -Force –ToSession $teletexte_vid1
                Show-UDToast -Icon cloud_upload -IconColor "white" -MessageColor "#ec7331" -BackgroundColor "#ccc" -Duration 5000 -Message "vidéo copiée sur vim1"
                Copy-Item –Path '\\clust-file01\Teletexte\Films\Fichier_travail\video.mp4' –Destination 'C:\Logo\' -Force –ToSession $teletexte_vid2
                Show-UDToast -Icon cloud_upload -IconColor "white" -MessageColor "#ec7331" -BackgroundColor "#ccc" -Duration 5000 -Message "vidéo copiée sur vim2"
                Copy-Item –Path '\\clust-file01\Teletexte\Films\Fichier_travail\video.mp4' –Destination 'C:\Logo\' -Force –ToSession $teletexte_vid3
                Show-UDToast -Icon cloud_upload -IconColor "white" -MessageColor "#ec7331" -BackgroundColor "#ccc" -Duration 5000 -Message "vidéo copiée sur vim3"
                Copy-Item –Path '\\clust-file01\Teletexte\Films\Fichier_travail\video.mp4' –Destination 'C:\Logo\' -Force –ToSession $teletexte_vid4
                Show-UDToast -Icon cloud_upload -IconColor "white" -MessageColor "#ec7331" -BackgroundColor "#ccc" -Duration 5000 -Message "vidéo copiée sur vim4"
                Copy-Item –Path '\\clust-file01\Teletexte\Films\Fichier_travail\video.mp4' –Destination 'C:\Logo\' -Force –ToSession $teletexte_vid5
                Show-UDToast -Icon cloud_upload -IconColor "white" -MessageColor "#ec7331" -BackgroundColor "#ccc" -Duration 5000 -Message "vidéo copiée sur vim5"
                Show-UDToast -Icon cloud_upload -IconColor "white" -MessageColor "#ec7331" -BackgroundColor "#ccc" -Duration 5000 -Message "c'est ok, en tous cas, j'ai fais le max, il suffit de cliquer sur rédémarrer toutes les TV" 
                
            }
            New-UDButton -Icon recycle -Text "Redémarrer toutes les TV" -OnClick{
                # foreach TV reboot
                Show-UDToast -Icon cloud_upload -IconColor "white" -MessageColor "#ec7331" -BackgroundColor "#ccc" -Duration 5000 -Message "Je lance la demande !" 
                shutdown -r -m '\\vim1.iemn.fr' -t 0 -f
                Start-Sleep -Seconds 5
                Show-UDToast -Icon cloud_upload -IconColor "white" -MessageColor "#ec7331" -BackgroundColor "#ccc" -Duration 5000 -Message "demande lancée sur vim1"
                shutdown -r -m '\\vim2.iemn.fr' -t 0 -f
                Start-Sleep -Seconds 5
                Show-UDToast -Icon cloud_upload -IconColor "white" -MessageColor "#ec7331" -BackgroundColor "#ccc" -Duration 5000 -Message "demande lancée sur vim2"
                shutdown -r -m '\\vim3.iemn.fr' -t 0 -f
                Start-Sleep -Seconds 5
                Show-UDToast -Icon cloud_upload -IconColor "white" -MessageColor "#ec7331" -BackgroundColor "#ccc" -Duration 5000 -Message "demande lancée sur vim3"
                shutdown -r -m '\\vim4.iemn.fr' -t 0 -f
                Start-Sleep -Seconds 5
                Show-UDToast -Icon cloud_upload -IconColor "white" -MessageColor "#ec7331" -BackgroundColor "#ccc" -Duration 5000 -Message "demande lancée sur vim4"
                shutdown -r -m '\\vim5.iemn.fr' -t 0 -f
                Start-Sleep -Seconds 5
                Show-UDToast -Icon cloud_upload -IconColor "white" -MessageColor "#ec7331" -BackgroundColor "#ccc" -Duration 5000 -Message "demande lancée sur vim5"
                Start-Sleep -Seconds 5
                Show-UDToast -Icon cloud_upload -IconColor "white" -MessageColor "#ec7331" -BackgroundColor "#ccc" -Duration 5000 -Message "Compter 2 minutes, les TV redémarrent !" 

            }
            #$button_remote_teletexte = New-UDButton -Icon desktop -Text "Voir les écrans de TV (option non disponible)"
            #$button_remote_teletexte.Attributes.href = "http://lci-remote.iemn.fr"
            #$button_remote_teletexte
        }
        New-UDColumn -Size 6 -Content{
            New-UdGrid -Title "Noms des Tv" -Headers @("Nom", "IPv4Address", "Description") -Properties @("DNSHostName", "IPv4Address", "Description") -FontColor '#fff' -AutoRefresh -RefreshInterval 10 -Endpoint {
                Get-ADComputer -Filter * -Properties * | Where {$_.DNSHostName -like "Vim*.iemn.fr"} | Select DNSHostName,IPv4Address,Description | Out-UDGridData
            }
        }
        }
    New-UDRow  -Columns {
        New-UDColumn -Size 3 -Content{
            New-UDInput -Title “Jouer une vidéo différente sur une TV” -Id “formOtherPlay” -Content {
                New-UDInputField -Type ‘textbox’ -Name ‘OtherPlayTV’ -Placeholder ‘Entrer le nom de la TV sur laquelle la vidéo doit être jouée’
            } -Endpoint {
            param($OtherPlayTV)
                $teletexte_alone_vid = new-PSsession -ComputerName $OtherPlayTV
                    Invoke-Command -Session $teletexte_alone_vid -ScriptBlock {Get-Process | Where {$_.ProcessName -like 'vlc'} | Stop-Process -Force}
                    Copy-Item –Path '\\clust-file01\Teletexte\Films\tv_unique\video.mp4' –Destination 'C:\Logo\' –ToSession $teletexte_alone_vid
                    Show-UDToast -Icon cloud_upload -IconColor "white" -MessageColor "#ec7331" -BackgroundColor "#ccc" -Duration 5000 -Message "vidéo copiée, vous pouvez redémarrer la TV"
            }
            }# lancer une vidéo différente sur chaque TV
        New-UDColumn -Size 3 -Content{
            New-UDInput -Title “Redemarrer une TV” -Id “Formstickreboot” -Content {
                New-UDInputField -Type ‘textbox’ -Name ‘rebootstick’ -Placeholder ‘Entrer l ip du stick ou le nom complet’
            } -Endpoint {
            param($rebootstick)
                shutdown -r -m \\$rebootstick -f
                Show-UDToast -Icon cloud_upload -IconColor "white" -MessageColor "#ec7331" -BackgroundColor "#ccc" -Duration 5000 -Message "Redémarrage machine demandé, attendez 1 minute"
            }
            }# redémarrer une ComputeStick
        New-UDCOlumn -Size 3 -Content{
            New-UdGrid -Title "Videos disponibles" -Headers @("Nom") -Properties @("Name") -FontColor '#fff' -AutoRefresh -RefreshInterval 60 -Endpoint {
                Get-ChildItem '\\clust-file01\Teletexte\Films' | Select Name | Out-UDGridData
            }
        }# videos dispos sur le filer
        New-UDColumn -Size 3 -Content{
            New-UDCard -Title "Etât des TV" -TextSize Medium -Content{
            $vim1_ping = Test-Connection -BufferSize 32 -Count 1 -ComputerName 'vim1.iemn.fr' -Quiet
            $vim2_ping = Test-Connection -BufferSize 32 -Count 1 -ComputerName 'vim2.iemn.fr' -Quiet
            $vim3_ping = Test-Connection -BufferSize 32 -Count 1 -ComputerName 'vim3.iemn.fr' -Quiet
            $vim4_ping = Test-Connection -BufferSize 32 -Count 1 -ComputerName 'vim4.iemn.fr' -Quiet
            $vim5_ping = Test-Connection -BufferSize 32 -Count 1 -ComputerName 'vim5.iemn.fr' -Quiet
            if ($vim1_ping -like "True" ) {New-UDElement -tag "div" -Id "vim1_ping" -AutoRefresh -RefreshInterval 60 -Content{"La TV du hall est allumée"}} else{New-UDElement -tag "div" -Id "vim1_ping_down" -AutoRefresh -RefreshInterval 60 -Content{"La TV du hall est éteinte"}}
            if ($vim3_ping -like "True" ) {New-UDElement -tag "div" -Id "vim2_ping" -AutoRefresh -RefreshInterval 60 -Content{"La TV E.C.M est allumée"}} else{New-UDElement -tag "div" -Id "vim2_ping_down" -AutoRefresh -RefreshInterval 60 -Content{"La TV E.C.M est éteinte"}}
            if ($vim4_ping -like "True" ) {New-UDElement -tag "div" -Id "vim3_ping" -AutoRefresh -RefreshInterval 60 -Content{"La TV du 1er étage côté hall est allumée"}} else{New-UDElement -tag "div" -Id "vim3_ping_down" -AutoRefresh -RefreshInterval 60 -Content{"La TV du 1er étage côté hall est éteinte"}}
            if ($vim5_ping -like "True" ) {New-UDElement -tag "div" -Id "vim4_ping" -AutoRefresh -RefreshInterval 60 -Content{"La TV du 2nd étage côté hall est allumée"}} else{New-UDElement -tag "div" -Id "vim4_ping_down" -AutoRefresh -RefreshInterval 60 -Content{"La TV du 2nd étage côté hall est éteinte"}}
            if ($vim2_ping -like "True" ) {New-UDElement -tag "div" -Id "vim5_ping" -AutoRefresh -RefreshInterval 60 -Content{"La TV du 3eme étage côté hall est allumée"}} else{New-UDElement -tag "div" -Id "vim5_ping_down" -AutoRefresh -RefreshInterval 60 -Content{"La TV du 3eme étage côté hall est éteinte"}}
            }
        }# état des sticks
    }
} -AuthorizedRole @("Direction", "ECM", "dash", "Admin")  #fin page Teletexte

# Lancement de la DashBoard
$iemn_dashboard = New-UDDashboard -Title "$titre" -NavBarColor $bgcolor -BackgroundColor $bgcolor -Footer $Footer -Theme $Theme -Stylesheets $css -LoginPage $LoginPage -Pages @($page_status, $page_Hyperv, $page_infoclustmonitor, $page_ActiveDirectory, $page_infoADmonitor, $page_ADCarac, $page_rds, $page_intranet, $page_WSUS, $page_WDS, $page_WPS, $page_Ysoft, $page_CA, $page_wapt, $page_kasc, $page_filers, $page_urbackup, $page_Bitlocker, $page_Accueil, $page_TeleNew)
Start-UDDashboard -Port 443 -Dashboard $iemn_dashboard -Certificate $cert -AutoReload # Je lance la tâche sur le port 8080 avec le nom de variable ci-dessus avec l'option d'actualisation des datas.
Start-Sleep -Seconds 3580 # Je lance un pause pour 59min 50secs
Get-PSSession | Remove-PSSession # je kill les sessions PS a distance
Get-UDDashboard | Stop-UDDashboard #je kill l'instance pour laisser place à la future (cronjob) [contournement de la limite de 1h d'utilisation].