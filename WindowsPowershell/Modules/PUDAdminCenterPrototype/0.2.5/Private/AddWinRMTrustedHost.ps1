<#
    .SYNOPSIS
        This function adds an IP or hostname/fqdn to "WSMan:\localhost\Client\TrustedHosts". It also ensures
        that the WSMan Client is configured to allow for remoting.

    .DESCRIPTION
        See .SYNOPSIS

    .NOTES

    .PARAMETER NewRemoteHost
        This parameter is MANDATORY.

        This parameter takes a string that represents the IP Address, HostName, or FQDN of the Remote Host
        that you would like to PSRemote to.

    .EXAMPLE
        # Open an elevated PowerShell Session, import the module, and -

        PS C:\Users\zeroadmin> AddWinRMTrustedHost -NewRemoteHost 192.168.2.49
        
#>
function AddWinRMTrustedHost {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$True)]
        [string[]]$NewRemoteHost
    )

    # Make sure WinRM in Enabled and Running on $env:ComputerName
    try {
        $null = Enable-PSRemoting -Force -ErrorAction Stop
    }
    catch {
        $NICsWPublicProfile = @(Get-NetConnectionProfile | Where-Object {$_.NetworkCategory -eq 0})
        if ($NICsWPublicProfile.Count -gt 0) {
            foreach ($Nic in $NICsWPublicProfile) {
                Set-NetConnectionProfile -InterfaceIndex $Nic.InterfaceIndex -NetworkCategory 'Private'
            }
        }

        try {
            $null = Enable-PSRemoting -Force
        }
        catch {
            Write-Error $_
            Write-Error "Problem with Enabble-PSRemoting WinRM Quick Config! Halting!"
            $global:FunctionResult = "1"
            return
        }
    }

    # If $env:ComputerName is not part of a Domain, we need to add this registry entry to make sure WinRM works as expected
    if (!$(Get-CimInstance Win32_Computersystem).PartOfDomain) {
        $null = reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v LocalAccountTokenFilterPolicy /t REG_DWORD /d 1 /f
    }

    # Add the New Server's IP Addresses to $env:ComputerName's TrustedHosts
    $CurrentTrustedHosts = $(Get-Item WSMan:\localhost\Client\TrustedHosts).Value
    [System.Collections.ArrayList][array]$CurrentTrustedHostsAsArray = $CurrentTrustedHosts -split ','

    $HostsToAddToWSMANTrustedHosts = @($NewRemoteHost)
    foreach ($HostItem in $HostsToAddToWSMANTrustedHosts) {
        if ($CurrentTrustedHostsAsArray -notcontains $HostItem) {
            $null = $CurrentTrustedHostsAsArray.Add($HostItem)
        }
        else {
            Write-Warning "Current WinRM Trusted Hosts Config already includes $HostItem"
            continue
        }
    }
    $UpdatedTrustedHostsString = $($CurrentTrustedHostsAsArray | Where-Object {![string]::IsNullOrWhiteSpace($_)}) -join ','
    Set-Item WSMan:\localhost\Client\TrustedHosts $UpdatedTrustedHostsString -Force
}
