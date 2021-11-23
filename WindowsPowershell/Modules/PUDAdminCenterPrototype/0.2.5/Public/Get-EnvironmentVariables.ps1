<#
    
    .SYNOPSIS
        Gets 'Machine' and 'User' environment variables.
    
    .DESCRIPTION
        Gets 'Machine' and 'User' environment variables.

    .NOTES
        This function is pulled directly from the real Microsoft Windows Admin Center

        PowerShell scripts use rights (according to Microsoft):
        We grant you a non-exclusive, royalty-free right to use, modify, reproduce, and distribute the scripts provided herein.

        ANY SCRIPTS PROVIDED BY MICROSOFT ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED,
        INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS OR A PARTICULAR PURPOSE.
    
    .ROLE
        Readers

    .EXAMPLE
        # Open an elevated PowerShell Session, import the module, and -

        PS C:\Users\zeroadmin> Get-EnvironmentVariables
    
#>
function Get-EnvironmentVariables {
    Set-StrictMode -Version 5.0
    
    $data = @()
    
    $system = [Environment]::GetEnvironmentVariables([EnvironmentVariableTarget]::Machine)
    $user = [Environment]::GetEnvironmentVariables([EnvironmentVariableTarget]::User)
    
    foreach ($h in $system.GetEnumerator()) {
        $obj = [pscustomobject]@{"Name" = $h.Name; "Value" = $h.Value; "Type" = "Machine"}
        $data += $obj
    }
    
    foreach ($h in $user.GetEnumerator()) {
        $obj = [pscustomobject]@{"Name" = $h.Name; "Value" = $h.Value; "Type" = "User"}
        $data += $obj
    }
    
    $data
}
