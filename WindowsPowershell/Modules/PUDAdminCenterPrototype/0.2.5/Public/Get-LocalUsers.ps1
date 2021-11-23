<#
    
    .SYNOPSIS
        Gets the local users.
    
    .DESCRIPTION
        Gets the local users. The supported Operating Systems are
        Window Server 2012, Windows Server 2012R2, Windows Server 2016.

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

        PS C:\Users\zeroadmin> Get-LocalUsers
    
#>
function Get-LocalUsers {
    param (
        [Parameter(Mandatory = $false)]
        [String]
        $SID
    )
    
    $isWinServer2016OrNewer = [Environment]::OSVersion.Version.Major -ge 10;
    # ADSI does NOT support 2016 Nano, meanwhile New-LocalUser, Get-LocalUser, Set-LocalUser do NOT support downlevel
    if ($SID)
    {
        if ($isWinServer2016OrNewer)
        {
            Get-LocalUser -SID $SID | Microsoft.PowerShell.Utility\Select-Object @(
                "AccountExpires",
                "Description",
                "Enabled",
                "FullName",
                "LastLogon",
                "Name",
                "ObjectClass",
                "PasswordChangeableDate",
                "PasswordExpires",
                "PasswordLastSet",
                "PasswordRequired",
                "SID",
                "UserMayChangePassword"
            ) | foreach {
                [pscustomobject]@{
                    AccountExpires          = $_.AccountExpires
                    Description             = $_.Description
                    Enabled                 = $_.Enabled
                    FullName                = $_.FullName
                    LastLogon               = $_.LastLogon
                    Name                    = $_.Name
                    GroupMembership         = Get-LocalUserBelongGroups -UserName $_.Name
                    ObjectClass             = $_.ObjectClass
                    PasswordChangeableDate  = $_.PasswordChangeableDate
                    PasswordExpires         = $_.PasswordExpires
                    PasswordLastSet         = $_.PasswordLastSet
                    PasswordRequired        = $_.PasswordRequired
                    SID                     = $_.SID.Value
                    UserMayChangePassword   = $_.UserMayChangePassword
                }
            }
        }
        else
        {
            Get-WmiObject -Class Win32_UserAccount -Filter "LocalAccount='True' AND SID='$SID'" | Microsoft.PowerShell.Utility\Select-Object @(
                "AccountExpirationDate",
                "Description",
                "Disabled"
                "FullName",
                "LastLogon",
                "Name",
                "ObjectClass",
                "PasswordChangeableDate",
                "PasswordExpires",
                "PasswordLastSet",
                "PasswordRequired",
                "SID",
                "PasswordChangeable"
            ) | foreach {
                [pscustomobject]@{
                    AccountExpires          = $_.AccountExpirationDate
                    Description             = $_.Description
                    Enabled                 = !$_.Disabled
                    FullName                = $_.FullName
                    LastLogon               = $_.LastLogon
                    Name                    = $_.Name
                    GroupMembership         = Get-LocalUserBelongGroups -UserName $_.Name
                    ObjectClass             = $_.ObjectClass
                    PasswordChangeableDate  = $_.PasswordChangeableDate
                    PasswordExpires         = $_.PasswordExpires
                    PasswordLastSet         = $_.PasswordLastSet
                    PasswordRequired        = $_.PasswordRequired
                    SID                     = $_.SID.Value
                    UserMayChangePassword   = $_.PasswordChangeable
                }
            }
        }
    }
    else
    {
        if ($isWinServer2016OrNewer)
        {
            Get-LocalUser | Microsoft.PowerShell.Utility\Select-Object @(
                "AccountExpires",
                "Description",
                "Enabled",
                "FullName",
                "LastLogon",
                "Name",
                "ObjectClass",
                "PasswordChangeableDate",
                "PasswordExpires",
                "PasswordLastSet",
                "PasswordRequired",
                "SID",
                "UserMayChangePassword"
            ) | foreach {
                [pscustomobject]@{
                    AccountExpires          = $_.AccountExpires
                    Description             = $_.Description
                    Enabled                 = $_.Enabled
                    FullName                = $_.FullName
                    LastLogon               = $_.LastLogon
                    Name                    = $_.Name
                    GroupMembership         = Get-LocalUserBelongGroups -UserName $_.Name
                    ObjectClass             = $_.ObjectClass
                    PasswordChangeableDate  = $_.PasswordChangeableDate
                    PasswordExpires         = $_.PasswordExpires
                    PasswordLastSet         = $_.PasswordLastSet
                    PasswordRequired        = $_.PasswordRequired
                    SID                     = $_.SID.Value
                    UserMayChangePassword   = $_.UserMayChangePassword
                }
            }
        }
        else
        {
            Get-WmiObject -Class Win32_UserAccount -Filter "LocalAccount='True'" | Microsoft.PowerShell.Utility\Select-Object @(
                "AccountExpirationDate",
                "Description",
                "Disabled"
                "FullName",
                "LastLogon",
                "Name",
                "ObjectClass",
                "PasswordChangeableDate",
                "PasswordExpires",
                "PasswordLastSet",
                "PasswordRequired",
                "SID",
                "PasswordChangeable"
            ) | foreach {
                [pscustomobject]@{
                    AccountExpires          = $_.AccountExpirationDate
                    Description             = $_.Description
                    Enabled                 = !$_.Disabled
                    FullName                = $_.FullName
                    LastLogon               = $_.LastLogon
                    Name                    = $_.Name
                    GroupMembership         = Get-LocalUserBelongGroups -UserName $_.Name
                    ObjectClass             = $_.ObjectClass
                    PasswordChangeableDate  = $_.PasswordChangeableDate
                    PasswordExpires         = $_.PasswordExpires
                    PasswordLastSet         = $_.PasswordLastSet
                    PasswordRequired        = $_.PasswordRequired
                    SID                     = $_.SID.Value
                    UserMayChangePassword   = $_.PasswordChangeable
                }
            }
        }
    }    
}
