function InvokeModuleDependencies {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$False)]
        [string[]]$RequiredModules,

        [Parameter(Mandatory=$False)]
        [switch]$InstallModulesNotAvailableLocally
    )

    if ($InstallModulesNotAvailableLocally) {
        if ($PSVersionTable.PSEdition -ne "Core") {
            $null = Install-PackageProvider -Name Nuget -Force -Confirm:$False
            $null = Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
        }
        else {
            $null = Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
        }
    }

    if ($PSVersionTable.PSEdition -eq "Core") {
        $InvPSCompatSplatParams = @{
            ErrorAction                         = "SilentlyContinue"
            #WarningAction                       = "SilentlyContinue"
        }

        $MyInvParentScope = Get-Variable "MyInvocation" -Scope 1 -ValueOnly
        $PathToFile = $MyInvParentScope.MyCommand.Source
        $FunctionName = $MyInvParentScope.MyCommand.Name

        if ($PathToFile) {
            $InvPSCompatSplatParams.Add("InvocationMethod",$PathToFile)
        }
        elseif ($FunctionName) {
            $InvPSCompatSplatParams.Add("InvocationMethod",$FunctionName)
        }
        else {
            Write-Error "Unable to determine MyInvocation Source or Name! Halting!"
            $global:FunctionResult = "1"
            return
        }

        if ($PSBoundParameters['InstallModulesNotAvailableLocally']) {
            $InvPSCompatSplatParams.Add("InstallModulesNotAvailableLocally",$True)
        }
        if ($PSBoundParameters['RequiredModules']) {
            $InvPSCompatSplatParams.Add("RequiredModules",$RequiredModules)
        }

        $Output = InvokePSCompatibility @InvPSCompatSplatParams
    }
    else {
        [System.Collections.ArrayList]$SuccessfulModuleImports = @()
        [System.Collections.ArrayList]$FailedModuleImports = @()

        foreach ($ModuleName in $RequiredModules) {
            $ModuleInfo = [pscustomobject]@{
                ModulePSCompatibility   = "WinPS"
                ModuleName              = $ModuleName
            }

            if (![bool]$(Get-Module -ListAvailable $ModuleName) -and $InstallModulesNotAvailableLocally) {
                $searchUrl = "https://www.powershellgallery.com/api/v2/Packages?`$filter=Id eq '$ModuleName' and IsLatestVersion"
                $PSGalleryCheck = Invoke-RestMethod $searchUrl
                if (!$PSGalleryCheck -or $PSGalleryCheck.Count -eq 0) {
                    $searchUrl = "https://www.powershellgallery.com/api/v2/Packages?`$filter=Id eq '$ModuleName'"
                    $PSGalleryCheck = Invoke-RestMethod $searchUrl

                    if (!$PSGalleryCheck -or $PSGalleryCheck.Count -eq 0) {
                        Write-Warning "Unable to find Module '$ModuleName' in the PSGallery! Skipping..."
                        continue
                    }

                    $PreRelease = $True
                }

                try {
                    if ($PreRelease) {
                        ManualPSGalleryModuleInstall -ModuleName $ModuleName -DownloadDirectory "$HOME\Downloads" -PreRelease -ErrorAction Stop -WarningAction SilentlyContinue
                    }
                    else {
                        Install-Module $ModuleName -AllowClobber -Force -ErrorAction Stop -WarningAction SilentlyContinue
                    }
                }
                catch {
                    Write-Error $_
                    $global:FunctionResult = "1"
                    return
                }
            }

            if (![bool]$(Get-Module -ListAvailable $ModuleName)) {
                $ErrMsg = "The Module '$ModuleName' is not available on the localhost! Did you " +
                "use the -InstallModulesNotAvailableLocally switch? Halting!"
                Write-Error $ErrMsg
                continue
            }

            $ManifestFileItem = Get-Item $(Get-Module -ListAvailable $ModuleName).Path
            $ModuleInfo | Add-Member -Type NoteProperty -Name ManifestFileItem -Value $ManifestFileItem

            # Import the Module
            try {
                Import-Module $ModuleName -Scope Global -ErrorAction Stop
                $null = $SuccessfulModuleImports.Add($ModuleInfo)
            }
            catch {
                Write-Warning "Problem importing the $ModuleName Module!"
                $null = $FailedModuleImports.Add($ModuleInfo)
            }
        }

        $UnacceptableUnloadedModules = $FailedModuleImports

        $Output = [pscustomobject]@{
            SuccessfulModuleImports         = $SuccessfulModuleImports
            FailedModuleImports             = $FailedModuleImports
            UnacceptableUnloadedModules     = $UnacceptableUnloadedModules
        }
    }

    $Output
}
