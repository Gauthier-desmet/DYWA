<#
    
    .SYNOPSIS
        Get Windows Update History.
    
    .DESCRIPTION
        See .SYNOPSIS

    .NOTES
        From: https://stackoverflow.com/a/41626130

    .EXAMPLE
        # Open an elevated PowerShell Session, import the module, and -

        PS C:\Users\zeroadmin> Get-WuaHistory
    
#>
function Get-WuaHistory {
    #region >> Helper Functions

    function Convert-WuaResultCodeToName {
        param(
            [Parameter(Mandatory=$True)]
            [int]$ResultCode
        )
    
        $Result = $ResultCode
        switch($ResultCode) {
          2 {$Result = "Succeeded"}
          3 {$Result = "Succeeded With Errors"}
          4 {$Result = "Failed"}
        }
    
        return $Result
    }

    #endregion >> Helper Functions

    # Get a WUA Session
    $session = (New-Object -ComObject 'Microsoft.Update.Session')

    # Query the latest 1000 History starting with the first recordp     
    $history = $session.QueryHistory("",0,1000) | foreach {
        $Result = Convert-WuaResultCodeToName -ResultCode $_.ResultCode

        # Make the properties hidden in com properties visible.
        $_ | Add-Member -MemberType NoteProperty -Value $Result -Name Result
        $Product = $_.Categories | Where-Object {$_.Type -eq 'Product'} | Select-Object -First 1 -ExpandProperty Name
        $_ | Add-Member -MemberType NoteProperty -Value $_.UpdateIdentity.UpdateId -Name UpdateId
        $_ | Add-Member -MemberType NoteProperty -Value $_.UpdateIdentity.RevisionNumber -Name RevisionNumber
        $_ | Add-Member -MemberType NoteProperty -Value $Product -Name Product -PassThru

        Write-Output $_
    } 

    #Remove null records and only return the fields we want
    $history | Where-Object {![String]::IsNullOrWhiteSpace($_.title)}
}
