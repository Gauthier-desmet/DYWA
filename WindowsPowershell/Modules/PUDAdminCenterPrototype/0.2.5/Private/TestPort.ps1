function TestPort {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$False)]
        $HostName = $env:COMPUTERNAME,

        [Parameter(Mandatory=$False)]
        [int]$Port = $(Read-Host -Prompt "Please enter the port number you would like to check.")
    )

    #region >> Main

    try {
        $HostNameNetworkInfo = ResolveHost -HostNameOrIP $HostName -ErrorAction Stop
    }
    catch {
        Write-Error "Unable to resolve $HostName! Halting!"
        $global:FunctionResult = "1"
        return
    }

    $tcp = New-Object Net.Sockets.TcpClient
    $RemoteHostFQDN = $HostNameNetworkInfo.FQDN
    

    try {
        $tcp.Connect($RemoteHostFQDN, $Port)
    }
    catch {}

    if ($tcp.Connected) {
        $tcp.Close()
        $open = $true
    }
    else {
        $open = $false
    }

    $PortTestResult = [pscustomobject]@{
        Address = $RemoteHostFQDN
        Port    = $Port
        Open    = $open
    }
    $PortTestResult

    #endregion >> Main
}
