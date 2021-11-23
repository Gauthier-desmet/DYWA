function EnableWinRMViaRPC {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$True)]
        [string]$RemoteHostNameOrIP,

        [Parameter(Mandatory=$True)]
        [pscredential]$Credential
    )

    #region >> Prep
    
    try {
        $RemoteHostNetworkInfo = ResolveHost -HostNameOrIP $RemoteHostNameOrIP -ErrorAction Stop
    }
    catch {
        Write-Error $_
        Write-Error "Unable to resolve '$RemoteHostNameOrIP'! Halting!"
        $global:FunctionResult = "1"
        return
    }

    #endregion >> Prep
    
    #region >> Main

    $InvWmiMethodSplatParams = @{
        ComputerName        = $RemoteHostNetworkInfo.FQDN
        Namespace           = "root\cimv2"
        Class               = "Win32_Process"
        Name                = "Create"
        Credential          = $Credential
        Impersonation       = 3
        EnableAllPrivileges = $True
        ArgumentList        = "powershell -Command `"Start-Process powershell -Verb RunAs -ArgumentList 'Enable-PSRemoting -Force'`""
    }
    Invoke-WmiMethod @InvWmiMethodSplatParams

    #endregion >> Main
}
