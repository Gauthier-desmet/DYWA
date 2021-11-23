<#
    .SYNOPSIS
        This function updates $env:Path to include directories that contain programs installed via the Chocolatey
        Package Repository / Chocolatey CmdLine. It also loads Chocolatey PowerShell Modules required for package
        installation via a Chocolatey Package's 'chocoinstallscript.ps1'.

        NOTE: This function will remove paths in $env:Path that do not exist on teh filesystem.

    .DESCRIPTION
        See .SYNOPSIS

    .NOTES

    .PARAMETER ChocolateyDirectory
        This parameter is OPTIONAL.

        This parameter takes a string that represents the path to the location of the Chocolatey directory on your filesystem.
        Use this parameter ONLY IF Chocolatey packages are NOT located under "C:\Chocolatey" or "C:\ProgramData\chocolatey". 

    .PARAMETER UninstallAllSimilarlyNamedPackages
        This parameter is OPTIONAL.

        This parameter is a switch. If used, all programs that match the string provided to the -ProgramName
        parameter will be uninstalled. The user will NOT receive a prompt for specific selection.

    .EXAMPLE
        # Open an elevated PowerShell Session, import the module, and -
        
        PS C:\Users\zeroadmin> Update-ChocolateyEnv

#>
function Update-ChocolateyEnv {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$False)]
        [string]$ChocolateyDirectory
    )

    ##### BEGIN Main Body #####

    if (![bool]$(Get-Command choco -ErrorAction SilentlyContinue)) {
        [System.Collections.ArrayList]$PotentialChocolateyPaths = @()
        if ($ChocolateyDirectory) {
            $null = $PotentialChocolateyPaths.Add($ChocolateyDirectory)
        }
        else {
            if (Test-Path "C:\Chocolatey") {
                $null = $PotentialChocolateyPaths.Add("C:\Chocolatey")
            }
            if (Test-Path "C:\ProgramData\chocolatey") {
                $null = $PotentialChocolateyPaths.Add("C:\ProgramData\chocolatey")
            }
        }
    }
    else {
        $ChocolateyPath = "$($($(Get-Command choco).Source -split "chocolatey")[0])chocolatey"
    }
    
    [System.Collections.ArrayList]$ChocolateyPathsPrep = @()
    [System.Collections.ArrayList]$ChocolateyPathsToAddToEnvPath = @()
    foreach ($PotentialPath in $PotentialChocolateyPaths) {
        if (Test-Path $PotentialPath) {
            $($(Get-ChildItem $PotentialPath -Directory | foreach {
                Get-ChildItem $_.FullName -Recurse -File
            } | foreach {
                if ($_.Extension -eq ".exe" -or $_.Extension -eq ".bat") {
                    $_.Directory.FullName
                }
            }) | Sort-Object | Get-Unique) | foreach {
                $null = $ChocolateyPathsPrep.Add($_.Trim("\\"))
            }   
        }
    }
    foreach ($ChocoPath in $ChocolateyPathsPrep) {
        if ($(Test-Path $ChocoPath) -and $($env:Path -split ";") -notcontains $ChocoPath -and $ChocoPath -ne $null) {
            $null = $ChocolateyPathsToAddToEnvPath.Add($ChocoPath)
        }
    }

    foreach ($ChocoPath in $ChocolateyPathsToAddToEnvPath) {
        if ($env:Path[-1] -eq ";") {
            $env:Path = "$env:Path" + $ChocoPath + ";"
        }
        else {
            $env:Path = "$env:Path" + ";" + $ChocoPath
        }
    }

    # Remove any repeats in $env:Path
    $UpdatedEnvPath = $($($($env:Path -split ";") | foreach {
        if (-not [System.String]::IsNullOrWhiteSpace($_)) {
            if (Test-Path $_) {
                $_.Trim("\\")
            }
        }
    }) | Select-Object -Unique) -join ";"

    # Next, find chocolatey-core.psm1, chocolateysetup.psm1, chocolateyInstaller.psm1, and chocolateyProfile.psm1
    # and import them
    [System.Collections.ArrayList]$PotentialHelpersDirItems = @()
    foreach ($PotentialPath in $PotentialChocolateyPaths) {
        [array]$HelperDir = Get-ChildItem $PotentialPath -Recurse -Directory -Filter "helpers" | Where-Object {$_.FullName -match "chocolatey\\helpers"}
        if ($HelperDir.Count -gt 0) {
            $null = $PotentialHelpersDirItems.Add($HelperDir)
        }
    }
    if ($PotentialHelpersDirItems.Count -gt 0) {
        [array]$ChocoHelperDir = $($PotentialHelpersDirItems | Sort-Object -Property LastWriteTime)[-1]
    }

    if ($ChocoHelperDirItem -ne $null) {
        $ChocoCoreModule = $(Get-ChildItem -Path $ChocoHelperDirItem.FullName -Recurse -File -Filter "*chocolatey-core.psm1").FullName
        $ChocoSetupModule = $(Get-ChildItem -Path $ChocoHelperDirItem.FullName -Recurse -File -Filter "*chocolateysetup.psm1").FullName
        $ChocoInstallerModule = $(Get-ChildItem -Path $ChocoHelperDirItem.FullName -Recurse -File -Filter "*chocolateyInstaller.psm1").FullName
        $ChocoProfileModule = $(Get-ChildItem -Path $ChocoHelperDirItem.FullName -Recurse -File -Filter "*chocolateyProfile.psm1").FullName

        $ChocoModulesToImportPrep = @($ChocoCoreModule, $ChocoSetupModule, $ChocoInstallerModule, $ChocoProfileModule)
        [System.Collections.ArrayList]$ChocoModulesToImport = @()
        foreach ($ModulePath in $ChocoModulesToImportPrep) {
            if ($ModulePath -ne $null) {
                $null = $ChocoModulesToImport.Add($ModulePath)
            }
        }

        foreach ($ModulePath in $ChocoModulesToImport) {
            Remove-Module -Name $([System.IO.Path]::GetFileNameWithoutExtension($ModulePath)) -ErrorAction SilentlyContinue
            Import-Module -Name $ModulePath
        }
    }

    # Make sure we have ChocolateyInstall and ChocolateyPath environment variables are set
    $env:ChocolateyInstall = "C:\ProgramData\chocolatey"
    $env:ChocolateyPath = $env:ChocolateyInstall
    $null = [Environment]::SetEnvironmentVariable("ChocolateyInstall", $env:ChocolateyInstall, "User")
    $null = [Environment]::SetEnvironmentVariable("ChocolateyInstall", $env:ChocolateyInstall, "Machine")
    $null = [Environment]::SetEnvironmentVariable("ChocolateyPath", $env:ChocolateyPath, "User")
    $null = [Environment]::SetEnvironmentVariable("ChocolateyPath", $env:ChocolateyPath, "Machine")

    # Ensure that we have an "extensions" folder under $env:ProgramData\chocolatey
    if (Test-Path $env:ChocolateyPath) {
        $ChocoExtensionsFolder = "$env:ProgramData\chocolatey\extensions"
        if (!$(Test-Path $ChocoExtensionsFolder)) {
            $null = New-Item -ItemType Directory -Path $ChocoExtensionsFolder
        }
        $ExtensionModules = Get-ChildItem "$env:ProgramData\chocolatey\lib" -Directory | Where-Object {$_.Name -match "\.extension\."}
        foreach ($ModuleDirItem in $ExtensionModules) {
            if (Test-Path "$ChocoExtensionsFolder\$($ModuleDirItem.Name)") {
                $null = Remove-Item -Path "$ChocoExtensionsFolder\$($ModuleDirItem.Name)" -Recurse -Force
            }
            $null = Copy-Item -Path $ModuleDirItem.FullName -Destination $ChocoExtensionsFolder -Recurse -Force
        }
    }

    $UpdatedEnvPath

    ##### END Main Body #####

}
