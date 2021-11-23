<#
    .SYNOPSIS
        Uninstalls the specified Program. The value provided to the -ProgramName parameter does NOT have
        to be an exact match. If multiple matches are found, the function prompts for a specific selection
        (one of which is 'all of the above').

    .DESCRIPTION
        See .SYNOPSIS

    .NOTES

    .PARAMETER ProgramName
        This parameter is MANDATORY.

        This parameter takes a string that represents the name of the program you would like to uninstall. The
        value provided to this parameter does not have to be an exact match. If multiple matches are found the
        function prompts for a specfic selection (one of which is 'all of the above').

    .PARAMETER UninstallAllSimilarlyNamedPackages
        This parameter is OPTIONAL.

        This parameter is a switch. If used, all programs that match the string provided to the -ProgramName
        parameter will be uninstalled. The user will NOT receive a prompt for specific selection.

    .EXAMPLE
        # Open an elevated PowerShell Session, import the module, and -

        PS C:\Users\zeroadmin> Uninstall-Program -ProgramName python

    .EXAMPLE
        # Open an elevated PowerShell Session, import the module, and -
        
        PS C:\Users\zeroadmin> Uninstall-Program -ProgramName python -UninstallAllSimilarlyNamedPackages

#>
function Uninstall-Program {
    [CmdletBinding()]
    Param (
        [Parameter(
            Mandatory=$True,
            Position=0
        )]
        [string]$ProgramName,

        [Parameter(Mandatory=$False)]
        [switch]$UninstallAllSimilarlyNamedPackages
    )

    #region >> Variable/Parameter Transforms and PreRun Prep

    if (!$(GetElevation)) {
        Write-Error "The $($MyInvocation.MyCommand.Name) function must be ran from an elevated PowerShell Session (i.e. 'Run as Administrator')! Halting!"
        $global:FunctionResult = "1"
        return
    }

    try {
        #$null = clist --local-only
        $PackageManagerInstallObjects = Get-AllPackageInfo -ProgramName $ProgramName -ErrorAction SilentlyContinue
        [array]$ChocolateyInstalledProgramObjects = $PackageManagerInstallObjects.ChocolateyInstalledProgramObjects
        [array]$PSGetInstalledPackageObjects = $PackageManagerInstallObjects.PSGetInstalledPackageObjects
        [array]$RegistryProperties = $PackageManagerInstallObjects.RegistryProperties
    }
    catch {
        Write-Error $_
        $global:FunctionResult = "1"
        return
    }

    #endregion >> Variable/Parameter Transforms and PreRun Prep
    

    #region >> Main Body
    if ($ChocolateyInstalledProgramObjects.Count -eq 0 -and $PSGetInstalledPackageObjects.Count -eq 0) {
        Write-Error "Unable to find an installed program matching the name $ProgramName! Halting!"
        $global:FunctionResult = "1"
        return
    }

    # We MIGHT be able to get the directory where the Program's binaries are by using Get-Command.
    # This info is only useful if the uninstall isn't clean for some reason
    $ProgramExePath = $(Get-Command $ProgramName -ErrorAction SilentlyContinue).Source
    if ($ProgramExePath) {
        $ProgramParentDirPath = $ProgramExePath | Split-Path -Parent
    }

    [System.Collections.ArrayList]$PSGetUninstallFailures = @()
    if ($PSGetInstalledPackageObjects.Count -gt 0) {
        if ($PSGetInstalledPackageObjects.Count -gt 1) {
            Write-Warning "Multiple packages matching the name '$ProgramName' have been found."

            for ($i=0; $i -lt $PSGetInstalledPackageObjects.Count; $i++) {
                Write-Host "$i) $($PSGetInstalledPackageObjects[$i].Name)"
            }
            Write-Host "$($PSGetInstalledPackageObjects.Count)) All of the Above"

            [int[]]$ValidChoiceNumbers = 0..$($PSGetInstalledPackageObjects.Count)
            $UninstallChoice = Read-Host -Prompt "Please enter one or more numbers (separated by commas) that correspond to the program(s) you would like to uninstall."
            if ($UninstallChoice -match ',') {
                [array]$UninstallChoiceArray = $($UninstallChoice -split ',').Trim()
            }
            else {
                [array]$UninstallChoiceArray = $UninstallChoice
            }

            [System.Collections.ArrayList]$InvalidChoices = @()
            foreach ($ChoiceNumber in $UninstallChoiceArray) {
                if ($ValidChoiceNumbers -notcontains $ChoiceNumber) {
                    $null = $InvalidChoices.Add($ChoiceNumber)
                }
            }

            while ($InvalidChoices.Count -ne 0) {
                Write-Warning "The following selections are NOT valid Choice Numbers: $($InvalidChoices -join ', ')"

                $UninstallChoice = Read-Host -Prompt "Please enter one or more numbers (separated by commas) that correspond to the program(s) you would like to uninstall."
                if ($UninstallChoice -match ',') {
                    [array]$UninstallChoiceArray = $($UninstallChoice -split ',').Trim()
                }
                else {
                    [array]$UninstallChoiceArray = $UninstallChoice
                }

                [System.Collections.ArrayList]$InvalidChoices = @()
                foreach ($ChoiceNumber in $UninstallChoiceArray) {
                    if ($ValidChoiceNumbers -notcontains $ChoiceNumber) {
                        $null = $InvalidChoices.Add($ChoiceNumber)
                    }
                }
            }

            # Make sure that $UninstallChoiceArray is an integer array sorted 0..N
            try {
                [int[]]$UninstallChoiceArray = $UninstallChoiceArray | Sort-Object
            }
            catch {
                Write-Error $_
                Write-Error "`$UninstallChoiceArray cannot be converted to an array of integers! Halting!"
                $global:FunctionResult = "1"
                return
            }

            if ($UninstallChoiceArray -notcontains $PSGetInstalledPackageObjects.Count) {
                [array]$FinalPackagesSelectedForUninstall = foreach ($ChoiceNumber in $UninstallChoiceArray) {
                    $PSGetInstalledPackageObjects[$ChoiceNumber]
                }
            }
            else {
                [array]$FinalPackagesSelectedForUninstall = $PSGetInstalledPackageObjects
            }
        }
        if ($PSGetInstalledPackageObjects.Count -eq 1) {
            [array]$FinalPackagesSelectedForUninstall = $PSGetInstalledPackageObjects
        }
            
        # Make sure that we uninstall Packages where 'ProviderName' is 'Programs' LAST
        foreach ($Package in $FinalPackagesSelectedForUninstall) {
            if ($Package.ProviderName -ne "Programs") {
                Write-Host "Uninstalling $($Package.Name)..."
                $UninstallResult = $Package | Uninstall-Package -Force -Confirm:$False -ErrorAction SilentlyContinue
            }
        }
        foreach ($Package in $FinalPackagesSelectedForUninstall) {
            if ($Package.ProviderName -eq "Programs") {
                Write-Host "Uninstalling $($Package.Name)..."
                $UninstallResult = $Package | Uninstall-Package -Force -Confirm:$False -ErrorAction SilentlyContinue
            }
        }
    }

    try {
        $PackageManagerInstallObjects = Get-AllPackageInfo -ProgramName $ProgramName -ErrorAction Stop
        [array]$ChocolateyInstalledProgramObjects = $PackageManagerInstallObjects.ChocolateyInstalledProgramObjects
        [array]$PSGetInstalledPackageObjects = $PackageManagerInstallObjects.PSGetInstalledPackageObjects
        [array]$RegistryProperties = $PackageManagerInstallObjects.RegistryProperties
    }
    catch {
        Write-Error $_
        $global:FunctionResult = "1"
        return
    }

    # If we still have lingering packages, we need to try uninstall via what the Registry says the uninstall command is...
    if ($PSGetInstalledPackageObjects.Count -gt 0) {
        if ($RegistryProperties.Count -gt 0) {
            foreach ($Program in $RegistryProperties) {
                if ($Program.QuietUninstallString -ne $null) {
                    Invoke-Expression "& $($Program.QuietUninstallString)"
                }
            }
        }
    }

    try {
        $PackageManagerInstallObjects = Get-AllPackageInfo -ProgramName $ProgramName -ErrorAction Stop
        [array]$ChocolateyInstalledProgramObjects = $PackageManagerInstallObjects.ChocolateyInstalledProgramObjects
        [array]$PSGetInstalledPackageObjects = $PackageManagerInstallObjects.PSGetInstalledPackageObjects
        [array]$RegistryProperties = $PackageManagerInstallObjects.RegistryProperties
    }
    catch {
        Write-Error $_
        $global:FunctionResult = "1"
        return
    }

    # If we STILL have lingering packages, we'll just delete from the registry directly and clean up any binaries on the filesystem...
    if ($PSGetInstalledPackageObjects.Count -gt 0) {
        [System.Collections.ArrayList]$DirectoriesThatMightNeedToBeRemoved = @()
        
        if ($RegistryProperties.Count -gt 0) {
            foreach ($Program in $RegistryProperties) {
                if (Test-Path $Program.PSPath) {
                    $null = $DirectoriesThatMightNeedToBeRemoved.Add($Program.PSPath)
                    #Remove-Item -Path $Program.PSPath -Recurse -Force
                }
            }
        }

        if ($ProgramParentDirPath) {
            if (Test-Path $ProgramParentDirPath) {
                $null = $DirectoriesThatMightNeedToBeRemoved.Add($ProgramParentDirPath)
                #Remove-Item $ProgramParentDirPath -Recurse -Force -ErrorAction SilentlyContinue
            }
        }
    }

    try {
        $PackageManagerInstallObjects = Get-AllPackageInfo -ProgramName $ProgramName -ErrorAction Stop
        [array]$ChocolateyInstalledProgramObjects = $PackageManagerInstallObjects.ChocolateyInstalledProgramObjects
        [array]$PSGetInstalledPackageObjects = $PackageManagerInstallObjects.PSGetInstalledPackageObjects
        [array]$RegistryProperties = $PackageManagerInstallObjects.RegistryProperties
    }
    catch {
        Write-Error $_
        $global:FunctionResult = "1"
        return
    }

    # Now take care of chocolatey if necessary...
    if ($ChocolateyInstalledProgramObjects.Count -gt 0) {
        $ChocoUninstallAttempt = $True
        [System.Collections.ArrayList]$ChocoUninstallFailuresPrep = @()
        [System.Collections.ArrayList]$ChocoUninstallSuccesses = @()

        $ErrorFile = [IO.Path]::Combine([IO.Path]::GetTempPath(), [IO.Path]::GetRandomFileName())
        #$ErrorFile
        foreach ($ProgramObj in $ChocolateyInstalledProgramObjects) {
            #Write-Host "Running $($(Get-Command choco).Source) uninstall $($ProgramObj.ProgramName) -y"
            $ProcessInfo = New-Object System.Diagnostics.ProcessStartInfo
            #$ProcessInfo.WorkingDirectory = $BinaryPath | Split-Path -Parent
            $ProcessInfo.FileName = $(Get-Command choco).Source
            $ProcessInfo.RedirectStandardError = $true
            $ProcessInfo.RedirectStandardOutput = $true
            $ProcessInfo.UseShellExecute = $false
            $ProcessInfo.Arguments = "uninstall $($ProgramObj.ProgramName) -y --force" # optionally -n --remove-dependencies
            $Process = New-Object System.Diagnostics.Process
            $Process.StartInfo = $ProcessInfo
            $Process.Start() | Out-Null
            # Below $FinishedInAlottedTime returns boolean true/false
            $FinishedInAlottedTime = $Process.WaitForExit(60000)
            if (!$FinishedInAlottedTime) {
                $Process.Kill()
            }
            $stdout = $Process.StandardOutput.ReadToEnd()
            $stderr = $Process.StandardError.ReadToEnd()
            $AllOutput = $stdout + $stderr

            if ($AllOutput -match "failed") {
                $null = $ChocoUninstallFailuresPrep.Add($ProgramObj)
            }
            else {
                $null = $ChocoUninstallSuccesses.Add($ProgramObj)
            }
        }
    }

    # Re-Check all PackageManager Objects because an uninstall action may/may not have happened
    try {
        $PackageManagerInstallObjects = Get-AllPackageInfo -ProgramName $ProgramName -ErrorAction Stop
        [array]$ChocolateyInstalledProgramObjects = $PackageManagerInstallObjects.ChocolateyInstalledProgramObjects
        [array]$PSGetInstalledPackageObjects = $PackageManagerInstallObjects.PSGetInstalledPackageObjects
        [array]$RegistryProperties = $PackageManagerInstallObjects.RegistryProperties
    }
    catch {
        Write-Error $_
        $global:FunctionResult = "1"
        return
    }

    if ($ChocolateyInstalledProgramObjects.Count -gt 0 -or $PSGetInstalledPackageObjects.Count -gt 0 -or $RegistryProperties.Count -gt 0) {
        Write-Warning "The program '$ProgramName' did NOT cleanly uninstall. Please review output of the Uninstall-Program function for details about lingering references."
    }
    else {
        Write-Host "The program '$ProgramName' was uninstalled successfully!" -ForegroundColor Green
    }

    [pscustomobject]@{
        DirectoriesThatMightNeedToBeRemoved = [array]$DirectoriesThatMightNeedToBeRemoved
        ChocolateyInstalledProgramObjects   = [array]$ChocolateyInstalledProgramObjects
        PSGetInstalledPackageObjects        = [array]$PSGetInstalledPackageObjects
        RegistryProperties                  = [array]$RegistryProperties
    }

    #endregion >> Main Body
}
