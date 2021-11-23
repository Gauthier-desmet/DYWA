function GetWorkingCredentials {
    [CmdletBinding(DefaultParameterSetName='PSCredential')]
    Param(
        [Parameter(Mandatory=$False)]
        [string]$RemoteHostNameOrIP,

        [Parameter(
            Mandatory=$False,
            ParameterSetName='PSCredential'
        )]
        [System.Management.Automation.PSCredential]$AltCredentials,

        [Parameter(
            Mandatory=$False,
            ParameterSetName='NoCredentialObject'
        )]
        [string]$UserName,

        [Parameter(
            Mandatory=$False,
            ParameterSetName='NoCredentialObject'
        )]
        [System.Security.SecureString]$Password
    )

    #region >> Helper Functions

    function Check-CredsAndLockStatus {
        [CmdletBinding()]
        Param(
            [Parameter(Mandatory=$True)]
            $RemoteHostNetworkInfo,

            [Parameter(
                Mandatory=$True,
                ParameterSetName='PSCredential'
            )]
            [System.Management.Automation.PSCredential]$AltCredentials
        )

        $CurrentlyLoadedAssemblies = [System.AppDomain]::CurrentDomain.GetAssemblies()

        if (![bool]$($CurrentlyLoadedAssemblies -match "System.DirectoryServices.AccountManagement")) {
            Add-Type -AssemblyName System.DirectoryServices.AccountManagement
        }
        $SimpleDomain = $RemoteHostNetworkInfo.Domain
        $SimpleDomainWLDAPPort = $SimpleDomain + ":3268"
        $DomainLDAPContainers = "DC=" + $($SimpleDomain -split "\.")[0] + "," + "DC=" + $($SimpleDomain -split "\.")[1]

        try {
            $SimpleUserName = $($AltCredentials.UserName -split "\\")[1]
            $PrincipleContext = [System.DirectoryServices.AccountManagement.PrincipalContext]::new(
                [System.DirectoryServices.AccountManagement.ContextType]::Domain,
                "$SimpleDomainWLDAPPort",
                "$DomainLDAPContainers",
                [System.DirectoryServices.AccountManagement.ContextOptions]::SimpleBind,
                "$($AltCredentials.UserName)",
                "$([Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($AltCredentials.Password)))"
            )

            try {
                $UserPrincipal = [System.DirectoryServices.AccountManagement.UserPrincipal]::FindByIdentity($PrincipleContext, [System.DirectoryServices.AccountManagement.IdentityType]::SamAccountName, "$SimpleUserName")
                $AltCredentialsAreValid = $True
            }
            catch {
                $AltCredentialsAreValid = $False
            }

            if ($AltCredentialsAreValid) {
                # Determine if the User Account is locked
                $AccountLocked = $UserPrincipal.IsAccountLockedOut()

                if ($AccountLocked -eq $True) {
                    Write-Error "The provided UserName $($AltCredentials.Username) is locked! Please unlock it before additional attempts at getting working credentials!"
                    $global:FunctionResult = "1"
                    return
                }
            }
        }
        catch {
            Write-Error $_
            $global:FunctionResult = "1"
            return
        }

        $Output = [ordered]@{
            AltCredentialsAreValid = $AltCredentialsAreValid
        }
        if ($AccountLocked) {
            $Output.Add("AccountLocked",$AccountLocked)
        }

        [pscustomobject]$Output
    }

    #endregion >> Helper Functions


    #region >> Variable/Parameter Transforms and PreRun Prep

    $CurrentlyLoadedAssemblies = [System.AppDomain]::CurrentDomain.GetAssemblies()

    $ResolveHostSplatParams = @{
        ErrorAction         = "Stop"
    }

    if ($RemoteHostNameOrIP) {
        $ResolveHostSplatParams.Add("HostNameOrIP",$RemoteHostNameOrIP)
    }
    else {
        $ResolveHostSplatParams.Add("HostNameOrIP",$env:ComputerName)
    }

    try {
        $RemoteHostNetworkInfo = ResolveHost @ResolveHostSplatParams
    }
    catch {
        if ($env:ComputerName -eq $($RemoteHostNameOrIP -split "\.")[0]) {
            $ResolveHostSplatParams = @{
                ErrorAction         = "Stop"
            }
            $ResolveHostSplatParams.Add("HostNameOrIP",$env:ComputerName)

            try {
                $RemoteHostNetworkInfo = ResolveHost @ResolveHostSplatParams
            }
            catch {
                Write-Error $_
                Write-Error "Unable to resolve $RemoteHostNameOrIP! Halting!"
                $global:FunctionResult = "1"
                return
            }
        }
        else {
            Write-Error $_
            Write-Error "Unable to resolve $RemoteHostNameOrIP! Halting!"
            $global:FunctionResult = "1"
            return
        }
    }

    [System.Collections.ArrayList]$WinRMEntriesToAdd = @()
    $null = $WinRMEntriesToAdd.Add($RemoteHostNetworkInfo.HostName)
    $null = $WinRMEntriesToAdd.Add($RemoteHostNetworkInfo.FQDN)
    $RemoteHostNetworkInfo.IPAddressList | foreach {$null = $WinRMEntriesToAdd.Add($_)}
    AddWinRMTrustedHost -NewRemoteHost $WinRMEntriesToAdd

    if (!$Username -and !$AltCredentials -and $RemoteHostNetworkInfo.HostName -eq $env:ComputerName) {
        #Write-Warning "The Remote Host is actually the Local Host (i.e. $env:ComputerName)!"

        $Output = [ordered]@{
            LogonType                               = "LocalAccount"
            DeterminedCredsThatWorkedOnRemoteHost   = $True
            WorkingCredsAreValidOnDomain            = $False
            WorkingCredentials                      = "$(whoami)"
            RemoteHostWorkingLocation               = $RemoteHostNetworkInfo.FQDN
            CurrentLoggedInUserCredsWorked          = $True
        }

        [pscustomobject]$Output
        return
    }

    $EnvironmentInfo = Get-ItemProperty 'Microsoft.PowerShell.Core\Registry::HKEY_CURRENT_USER\Volatile Environment\'
    $CurrentUserLogonServer = $EnvironmentInfo.LogonServer -replace '\\\\',''
    if ($CurrentUserLogonServer -eq $env:ComputerName) {
        $LogonServerIsDomainController = $False
        $LoggedInAsLocalUser = $True
    }
    else {
        $LogonServerIsDomainController = $True
        $LoggedInAsLocalUser = $False
    }

    if ($UserName) {
        while ($UserName -notmatch "\\") {
            $UserName = Read-Host -Prompt "The provided UserName is NOT in the correct format! Please enter a UserName with access to $($RemoteHostNetworkInfo.FQDN) using format <DomainPrefix_Or_$($RemoteHostNetworkInfo.HostName)>\<UserName>"
        }
        if (!$Password) {
            $Password = Read-Host -Prompt "Please enter the password for $UserName" -AsSecureString
        }
        $AltCredentials = [System.Management.Automation.PSCredential]::new($UserName,$Password)
    }

    #endregion >> Variable/Parameter Transforms and PreRun Prep

    #region >> Main Body

    if ($AltCredentials) {
        while ($AltCredentials.UserName -notmatch "\\") {
            $AltUserName = Read-Host -Prompt "The provided UserName is NOT in the correct format! Please enter a UserName with access to $($RemoteHostNetworkInfo.FQDN) using format <DomainPrefix_Or_$($RemoteHostNetworkInfo.HostName)>\<UserName>"
            $AltPassword = Read-Host -Prompt "Please enter the password for $AltUserName" -AsSecureString
            $AltCredentials = [System.Management.Automation.PSCredential]::new($AltUserName,$AltPassword)
        }

        if ($($AltCredentials.UserName -split "\\")[0] -ne $RemoteHostNetworkInfo.HostName -and 
        $($AltCredentials.UserName -split "\\")[0] -ne $($RemoteHostNetworkInfo.Domain -split "\.")[0]
        ) {
            $ErrMsg = "Using the credentials provided we will not be able to find a Logon Server. The credentials do not " +
            "indicate a Local Logon (i.e. $($RemoteHostNetworkInfo.HostName)\$($($AltCredentials.UserName -split "\\")[1]) " +
            "or a Domain Logon (i.e. $($($($RemoteHostNetworkInfo.Domain) -split "\.")[0])\$($($AltCredentials.UserName -split "\\")[1])! " +
            "Halting!"
            Write-Error $ErrMsg
            $global:FunctionResult = "1"
            return
        }

        if ($LoggedInAsLocalUser) {
            # If we ARE trying a Local Account on the Remote Host
            if ($($AltCredentials.Username -split "\\")[0] -eq $RemoteHostNetworkInfo.HostName) {
                $LogonType = "LocalAccount"
                $AltCredentialsUncertain = $True
                $CurrentUserCredentialsMightWork = $False
            }
            # If we ARE NOT trying a Local Account on the Remote Host, we are necessarily trying Domain Credentials
            if ($($AltCredentials.Username -split "\\")[0] -ne $RemoteHostNetworkInfo.HostName) {
                $LogonType = "DomainAccount"
                $CurrentUserCredentialsMightWork = $False

                $CredsAndLockStatus = Check-CredsAndLockStatus -RemoteHostNetworkInfo $RemoteHostNetworkInfo -AltCredentials $AltCredentials

                $AltCredentialsAreValid = $CredsAndLockStatus.AltCredentialsAreValid
                if ($AltCredentialsAreValid) {
                    $AccountLocked = $CredsAndLockStatus.AccountLocked
                }
            }
        }

        if (!$LoggedInAsLocalUser) {
            if ($AltCredentials.Username -eq $(whoami)) {
                # If we ARE trying a Local Account on the Remote Host
                if ($($AltCredentials.Username -split "\\")[0] -eq $RemoteHostNetworkInfo.HostName) {
                    $LogonType = "LocalAccount"
                    $AltCredentialsUncertain = $True
                    $CurrentUserCredentialsMightWork = $False
                }

                # If we ARE NOT trying a Local Account on the Remote Host, we are necessarily trying Domain Credentials
                if ($($AltCredentials.Username -split "\\")[0] -ne $RemoteHostNetworkInfo.HostName) {
                    $LogonType = "DomainAccount"

                    # We know we're staying within the same Domain...
                    $CurrentUserCredentialsMightWork = $True
                }
            }

            if ($AltCredentials.Username -ne $(whoami)) {
                # If we ARE trying a Local Account on the Remote Host
                if ($($AltCredentials.Username -split "\\")[0] -eq $RemoteHostNetworkInfo.HostName) {
                    $LogonType = "LocalAccount"
                    $AltCredentialsUncertain = $True
                    $CurrentUserCredentialsMightWork = $False
                }

                # If we ARE NOT trying a Local Account on the Remote Host, we are necessarily trying Domain Credentials
                if ($($AltCredentials.Username -split "\\")[0] -ne $RemoteHostNetworkInfo.HostName) {
                    $LogonType = "DomainAccount"

                    # If we're staying in the same Domain...
                    if ($EnvironmentInfo.UserDNSDomain -eq $RemoteHostNetworkInfo.Domain) {
                        $CurrentUserCredentialsMightWork = $True
                    }

                    # If we're trying a machine on a different Domain...
                    if ($EnvironmentInfo.UserDNSDomain -ne $RemoteHostNetworkInfo.Domain) {
                        $CredsAndLockStatus = Check-CredsAndLockStatus -RemoteHostNetworkInfo $RemoteHostNetworkInfo -AltCredentials $AltCredentials

                        $AltCredentialsAreValid = $CredsAndLockStatus.AltCredentialsAreValid
                        if ($AltCredentialsAreValid) {
                            $AccountLocked = $CredsAndLockStatus.AccountLocked
                        }
                    } # end Different Domain 'if' block
                } # end Domain Creds 'if' block
            } # end $AltCredentials.Username -ne $(whoami) 'if block'
        } # end !$LoggedInAsLocalUser 'if' block
    } # end $AltCredentials 'if' block
    if (!$AltCredentials) {
        # $AltCredentialsAreValid -eq $False because they are not provided...
        $AltCredentialsAreValid = $False
        
        if ($LoggedInAsLocalUser) {
            $CurrentUserCredentialsMightWork = $False
        }
        else {
            if ($RemoteHostNetworkInfo.Domain -eq $EnvironmentInfo.UserDNSDomain) {
                $LogonType = "DomainAccount"
                $CurrentUserCredentialsMightWork = $True
            }
            else {
                $CurrentUserCredentialsMightWork = $False
            }
        }
    }

    if ($AltCredentialsAreValid -or $AltCredentialsUncertain -or $AltCredentials) {
        # NOTE: For some reason, there are situations where FQDN works over HostName or visa versa. So we use
        # logic to try FQDN, and if that fails, try HostName
        try {
            $InvokeCommandOutput = Invoke-Command -ComputerName $RemoteHostNetworkInfo.FQDN -Credential $AltCredentials -ScriptBlock {"Success"} -ErrorAction Stop
            $TargetHostLocation = $RemoteHostNetworkInfo.FQDN
            $CredentialsWorked = $True
            $ProvidedCredsWorked = $True
        }
        catch {
            try {
                $InvokeCommandOutput = Invoke-Command -ComputerName $RemoteHostNetworkInfo.HostName -Credential $AltCredentials -ScriptBlock {"Success"} -ErrorAction Stop
                $TargetHostLocation = $RemoteHostNetworkInfo.HostName
                $CredentialsWorked = $True
                $ProvidedCredsWorked = $True
            }
            catch {
                if ($CurrentUserCredentialsMightWork) {
                    $TryCurrentUserCreds = $True
                }
                else {
                    Write-Warning "Unable to determine working credentials for $RemoteHostNameOrIP!"
                }
            }
        }
    }

    if ($($AltCredentialsAreValid -and $TryCurrentUserCreds) -or
    $(!$AltCredentials -and $CurrentUserCredentialsMightWork) -or
    $(!$LoggedInAsLocalUser -and $AltCredentials.Username -eq $(whoami))
    ) {
        try {
            $InvokeCommandOutput = Invoke-Command -ComputerName $RemoteHostNetworkInfo.FQDN -ScriptBlock {"Success"} -ErrorAction Stop
            $TargetHostLocation = $RemoteHostNetworkInfo.FQDN
            $CredentialsWorked = $True
            $TriedCurrentlyLoggedInUser = $True
        }
        catch {
            try {
                $InvokeCommandOutput = Invoke-Command -ComputerName $RemoteHostNetworkInfo.HostName -ScriptBlock {"Success"} -ErrorAction Stop
                $TargetHostLocation = $RemoteHostNetworkInfo.HostName
                $CredentialsWorked = $True
                $TriedCurrentlyLoggedInUser = $True
            }
            catch {
                Write-Warning "Unable to determine working credentials for $RemoteHostNameOrIP!"
            }
        }
    }

    # Create Output
    $Output = [ordered]@{
        LogonType       = $LogonType
    }

    $CredentialsWorked = if ($CredentialsWorked) {$True} else {$False}
    $Output.Add("DeterminedCredsThatWorkedOnRemoteHost",$CredentialsWorked)

    if ($CredentialsWorked) {
        if ($LogonType -eq "LocalAccount") {
            $Output.Add("WorkingCredsAreValidOnDomain",$False)
        }
        else {
            $Output.Add("WorkingCredsAreValidOnDomain",$True)
        }

        if ($AltCredentials -and $ProvidedCredsWorked) {
            $WorkingCredentials = $AltCredentials
        }
        else {
            $WorkingCredentials = "$(whoami)"
        }

        $Output.Add("WorkingCredentials",$WorkingCredentials)
        $Output.Add("RemoteHostWorkingLocation",$TargetHostLocation)
    }
    
    if ($WorkingCredentials.UserName -eq "$(whoami)" -or $WorkingCredentials -eq "$(whoami)") {
        $Output.Add("CurrentLoggedInUserCredsWorked",$True)
    }
    else {
        if (!$TriedCurrentlyLoggedInUser) {
            $Output.Add("CurrentLoggedInUserCredsWorked","NotTested")
        }
        elseif ($TriedCurrentlyLoggedInUser -and $CredentialsWorked) {
            $Output.Add("CurrentLoggedInUserCredsWorked",$True)
        }
        elseif ($TriedCurrentlyLoggedInUser -and !$CredentialsWorked) {
            $Output.Add("CurrentLoggedInUserCredsWorked",$False)
        }
    }

    if ($AltCredentials) {
        if ($LogonType -eq "LocalAccount" -or $AltCredentialsAreValid -eq $False) {
            $Output.Add("ProvidedCredsAreValidOnDomain",$False)
        }
        elseif ($AltCredentialsAreValid -eq $True -or $ProvidedCredsWorked) {
            $Output.Add("ProvidedCredsAreValidOnDomain",$True)
        }
        elseif ($ProvidedCredsWorked -eq $null) {
            $Output.Add("ProvidedCredsAreValidOnDomain","NotTested")
        }
        elseif ($ProvidedCredsWorked -eq $False) {
            $Output.Add("ProvidedCredsAreValidOnDomain",$False)
        }
        else {
            $Output.Add("ProvidedCredsAreValidOnDomain",$AltCredentialsAreValid)
        }
    }

    if ($AltCredentialsAreValid -and !$CredentialsWorked) {
        $FinalWarnMsg = "Either $($RemoteHostNetworkInfo.FQDN) and/or $($RemoteHostNetworkInfo.HostName) " +
        "and/or $($RemoteHostNetworkInfo.IPAddressList[0]) is not part of the WinRM Trusted Hosts list " +
        "(see '`$(Get-ChildItem WSMan:\localhost\Client\TrustedHosts).Value'), or the WinRM Service on " +
        "$($RemoteHostNetworkInfo.FQDN) is not running, or $($AltCredentials.UserName) specifically " +
        "does not have access to $($RemoteHostNetworkInfo.FQDN)! If $($RemoteHostNetworkInfo.FQDN) is " +
        "not part of a Domain, then you may also need to add this regsitry setting on $($RemoteHostNetworkInfo.FQDN):`n" +
        "    reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v LocalAccountTokenFilterPolicy /t REG_DWORD /d 1 /f" +
        "Lastly, use the 'Get-NetConnectionProfile' cmdlet on $($RemoteHostNetworkInfo.FQDN) to determine if any " +
        "network adapters have a 'NetworkCategory' of 'Public'. If so you must change them to 'Private' via:`n" +
        "    Get-NetConnectionProfile | Where-Object {`$_.NetworkCategory -eq 'Public'} | Set-NetConnectionProfile -NetworkCategory 'Private'"
        Write-Warning $FinalWarnMsg
    }

    [pscustomobject]$Output

    #endregion >> Main Body
}
