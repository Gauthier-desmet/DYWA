<#
    
    .SYNOPSIS
        Return subkeys based on the path.
    
    .DESCRIPTION
        Return subkeys based on the path. The supported Operating Systems are
        Window Server 2012 and Windows Server 2012R2 and Windows Server 2016.

    .NOTES
        This function is pulled directly from the real Microsoft Windows Admin Center

        PowerShell scripts use rights (according to Microsoft):
        We grant you a non-exclusive, royalty-free right to use, modify, reproduce, and distribute the scripts provided herein.

        ANY SCRIPTS PROVIDED BY MICROSOFT ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED,
        INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS OR A PARTICULAR PURPOSE.
    
    .ROLE
        Readers

    .PARAMETER path
        This parameter is MANDATORY.

        TODO

    .EXAMPLE
        # Open an elevated PowerShell Session, import the module, and -

        PS C:\Users\zeroadmin> Get-RegistrySubkeys -path "HKLM:\SOFTWARE\OpenSSH"
    
#>
function Get-RegistrySubKeys {
    Param([Parameter(Mandatory = $true)][string]$path)
    
    $ErrorActionPreference = "Stop"
    
    $Error.Clear()
    $keyArray = @()
    $key = Get-Item $path
    foreach ($sub in $key.GetSubKeyNames() | Sort-Object)
    {
        $keyEntry = New-Object System.Object
        $keyEntry | Add-Member -type NoteProperty -name Name -value $sub  
        $subKeyPath = $key.PSPath+'\'+$sub
        $keyEntry | Add-Member -type NoteProperty -name Path -value $subKeyPath
        $keyEntry | Add-Member -type NoteProperty -name childCount -value @( Get-ChildItem $subKeyPath -ErrorAction SilentlyContinue ).Length
        $keyArray += $keyEntry
    }
    $keyArray
    
}
