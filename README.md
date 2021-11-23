# Dashboard Powershell IEMN

https://dywa.iemn.fr

https://dywa-dev.iemn.fr

* Machines virtuelles sous Hyper-V

## 2 choix

 * Installation from scratch
 * Export / Import vm sortie du domaine (à ré-intégrer ailleurs.) *mode GUI ou mode core, au choix*

### 1) Installation

```powershell
# Make sure you have .Net 4.7.2 (or later) installed
# NOTE: The Install-DotNet472 function will not do anything if you already have .Net 4.7.2 installed.
# NOTE: If you do NOT already have .Net 4.7.2 installed, you will need to restart computer post-install!
$InstallDotNet472FunctionUrl = "https://raw.githubusercontent.com/pldmgg/misc-powershell/master/MyFunctions/Install-DotNet472.ps1"
$OutFilePath = "$HOME\Downloads\Install-DotNet472.ps1"
Invoke-WebRequest -Uri $InstallDotNet472FunctionUrl -OutFile $OutFilePath
. $OutFilePath
Install-DotNet472

# If you need to restart, do so now.

# Install and Import the UniversalDashboard.Community Module
Install-Module UniversalDashboard.Community
# Accept the license agreement
Import-Module UniversalDashboard.Community

# Finally, install and import the PUDAdminCenterPrototype Module
Install-Module PUDAdminCenterPrototype
Import-Module PUDAdminCenterPrototype
```

#### Installation UniversalDashboard

```powershell
Install-Module UniversalDashboard.CodeEditor
```