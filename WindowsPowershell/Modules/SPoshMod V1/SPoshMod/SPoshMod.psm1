########################################
#   SharePoint  PowerShell   Module
#
#               (SPoshMod)
#
#   Version: 1.0
#   Date:  2009-01-20
#
#   Authors:
#      Eric Kraus [MSFT]
#      Christian Glessner [MCTS]
########################################
# BUG FIXES:
#
#
#
#
# FUTURE ENHANCEMENTS:
#
#
#
########################################

$global:SPHome = "${env:CommonProgramFiles}\Microsoft Shared\web server extensions\12\"

[void][System.Reflection.Assembly]::LoadFrom("$SPHome\ISAPI\Microsoft.SharePoint.dll")

set-alias -name stsadm -value "${env:CommonProgramFiles}\microsoft shared\web server extensions\12\bin\stsadm.exe"
set-alias -name makecab -value "$psScriptRoot\makecab.exe"

$SPoshModAliases = @("stsadm","makecab")
Export-ModuleMember -Alias $SPoshModAliases

#CALL SUB SCRIPTS IN MODULE
Get-ChildItem "$psScriptRoot\xSPoshMod.*" | ForEach-Object { . $_.FullName }


