<#
    .SYNOPSIS
        This function gathers information about programs installed on the specified Hosts by inspecting
        the Windows Registry.

        If you do NOT use the -ProgramTitleSearchTerm parameter, information about ALL programs installed on
        the specified hosts will be returned.

    .DESCRIPTION
        See .SYNOPSIS

    .NOTES

        If you're looking for detailed information about an installed Program, or if you're looking to generate a list
        that closely resembles what you see in the 'Control Panel' 'Programs and Features' GUI, use this function.

    .PARAMETER ProgramTitleSearchTerm
        This parameter is OPTIONAL.

        This parameter takes a string that loosely matches the Program Name that you would like
        to gather information about. You can use regex with with this parameter.

        If you do NOT use this parameter, a list of ALL programs installed on the 

    .PARAMETER HostName
        This parameter is OPTIONAL, but is defacto mandatory since it defaults to $env:ComputerName.

        This parameter takes an array of string representing DNS-Resolveable host names that this function will
        attempt to gather Program Installation information from.

    .PARAMETER AllADWindowsComputers
        This parameter is OPTIONAL.

        This parameter is a switch. If it is used, this function will use the 'Get-ADComputer' cmdlet from the ActiveDirectory
        PowerShell Module (from RSAT) in order to generate a list of Computers on the domain. It will then get program information
        from each of those computers.

    .EXAMPLE
        # Open an elevated PowerShell Session, import the module, and -

        PS C:\Users\zeroadmin> Get-InstalledProgramsFromRegistry -ProgramTitleSearchTerm openssh
#>
function Get-InstalledProgramsFromRegistry {
    [CmdletBinding(
        PositionalBinding=$True,
        DefaultParameterSetName='Default Param Set'
    )]
    Param(
        [Parameter(
            Mandatory=$False,
            ParameterSetName='Default Param Set'
        )]
        [string]$ProgramTitleSearchTerm,

        [Parameter(
            Mandatory=$False,
            ParameterSetName='Default Param Set'
        )]
        [string[]]$HostName,

        [Parameter(
            Mandatory=$False,
            ParameterSetName='Secondary Param Set'
        )]
        [switch]$AllADWindowsComputers
    )

    ##### BEGIN Variable/Parameter Transforms and PreRun Prep #####

    if (!$HostName -and !$AllADWindowsComputers) {
        [string[]]$HostName = @($env:ComputerName)
    }

    $uninstallWow6432Path = "\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*"
    $uninstallPath = "\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*"

    $RegPaths = @(
        "HKLM:$uninstallWow6432Path",
        "HKLM:$uninstallPath",
        "HKCU:$uninstallWow6432Path",
        "HKCU:$uninstallPath"
    )
    
    ##### END Variable/Parameter Transforms and PreRun Prep #####

    ##### BEGIN Main Body #####
    # Get a list of Windows Computers from AD
    if ($AllADWindowsComputers) {
        if (!$(Get-Module -ListAvailable ActiveDirectory)) {
            Write-Error "The ActiveDirectory PowerShell Module (from RSAT) is not installed on this machine (i.e. $env:ComputerName)! Unable to get a list of Computers from Active Directory. Halting!"
            $global:FunctionResult = "1"
            return
        }
        if (!$(Get-Module ActiveDirectory)) {
            try {
                Import-Module ActiveDirectory -ErrorAction Stop
            }
            catch {
                Write-Error $_
                Write-Error "Problem importing the PowerShell Module 'ActiveDirectory'! Halting!"
                $global:FunctionResult = "1"
                return
            }
        }
        if (!$(Get-Command Get-ADComputer)) {
            Write-Error "Unable to find the cmdlet 'Get-ADComputer'! Unable to get a list of Computers from Active Directory. Halting!"
            $global:FunctionResult = "1"
            return
        }
        [array]$ComputersArray = $(Get-ADComputer -Filter * -Property * | Where-Object {$_.OperatingSystem -like "*Windows*"}).Name
    }
    else {
        [array]$ComputersArray = $HostName
    }

    foreach ($computer in $ComputersArray) {
        if ($computer -eq $env:ComputerName -or $computer.Split("\.")[0] -eq $env:ComputerName) {
            try {
                $InstalledPrograms = foreach ($regpath in $RegPaths) {if (Test-Path $regpath) {Get-ItemProperty $regpath}}
                if (!$InstalledPrograms) {
                    throw
                }
            }
            catch {
                Write-Warning "Unable to find registry path(s) on $computer. Skipping..."
                continue
            }
        }
        else {
            try {
                $InstalledPrograms = Invoke-Command -ComputerName $computer -ScriptBlock {
                    foreach ($regpath in $RegPaths) {
                        if (Test-Path $regpath) {
                            Get-ItemProperty $regpath
                        }
                    }
                } -ErrorAction SilentlyContinue
                if (!$InstalledPrograms) {
                    throw
                }
            }
            catch {
                Write-Warning "Unable to connect to $computer. Skipping..."
                continue
            }
        }

        if ($ProgramTitleSearchTerm) {
            $InstalledPrograms | Where-Object {$_.DisplayName -match "$ProgramTitleSearchTerm"}
        }
        else {
            $InstalledPrograms
        }
    }

    ##### END Main Body #####

}
