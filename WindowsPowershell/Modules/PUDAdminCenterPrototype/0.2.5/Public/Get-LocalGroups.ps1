<#
    
    .SYNOPSIS
        Gets the local groups.
    
    .DESCRIPTION
        Gets the local groups. The supported Operating Systems are Window Server 2012,
        Windows Server 2012R2, Windows Server 2016.

    .NOTES
        This function is pulled directly from the real Microsoft Windows Admin Center

        PowerShell scripts use rights (according to Microsoft):
        We grant you a non-exclusive, royalty-free right to use, modify, reproduce, and distribute the scripts provided herein.

        ANY SCRIPTS PROVIDED BY MICROSOFT ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED,
        INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS OR A PARTICULAR PURPOSE.
    
    .ROLE
        Readers

    .PARAMETER SID
        This parameter is OPTIONAL.

        TODO

    .EXAMPLE
        # Open an elevated PowerShell Session, import the module, and -

        PS C:\Users\zeroadmin> Get-LocalGroups
    
#>
function Get-LocalGroups {
    param (
        [Parameter(Mandatory = $false)]
        [String]
        $SID
    )
    
    Import-Module Microsoft.PowerShell.LocalAccounts -ErrorAction SilentlyContinue
    
    $isWinServer2016OrNewer = [Environment]::OSVersion.Version.Major -ge 10;
    # ADSI does NOT support 2016 Nano, meanwhile New-LocalUser, Get-LocalUser, Set-LocalUser do NOT support downlevel
    if ($SID)
    {
        if ($isWinServer2016OrNewer)
        {
            Get-LocalGroup -SID $SID | Select-Object Description,Name,SID,ObjectClass | foreach {
                [pscustomobject]@{
                    Description         = $_.Description
                    Name                = $_.Name
                    SID                 = $_.SID.Value
                    ObjectClass         = $_.ObjectClass
                    Members             = Get-LocalGroupUsers -group $_.Name
                }
            }
        }
        else
        {
            Get-WmiObject -Class Win32_Group -Filter "LocalAccount='True' AND SID='$SID'" | Select-Object Description,Name,SID,ObjectClass | foreach {
                [pscustomobject]@{
                    Description         = $_.Description
                    Name                = $_.Name
                    SID                 = $_.SID
                    ObjectClass         = $_.ObjectClass
                    Members             = Get-LocalGroupUsers -group $_.Name
                }
            }
        }
    }
    else
    {
        if ($isWinServer2016OrNewer)
        {
            Get-LocalGroup | Microsoft.PowerShell.Utility\Select-Object Description,Name,SID,ObjectClass | foreach {
                [pscustomobject]@{
                    Description         = $_.Description
                    Name                = $_.Name
                    SID                 = $_.SID.Value
                    ObjectClass         = $_.ObjectClass
                    Members             = Get-LocalGroupUsers -group $_.Name
                }
            }
        }
        else
        {
            Get-WmiObject -Class Win32_Group -Filter "LocalAccount='True'" | Microsoft.PowerShell.Utility\Select-Object Description,Name,SID,ObjectClass | foreach {
                [pscustomobject]@{
                    Description         = $_.Description
                    Name                = $_.Name
                    SID                 = $_.SID
                    ObjectClass         = $_.ObjectClass
                    Members             = Get-LocalGroupUsers -group $_.Name
                }
            }
        }
    }    
}
