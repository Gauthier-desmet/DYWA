param($configuration)

if($configuration -eq "Debug")
{
    if((Test-Path ($Env:PSMODULEPATH -Split ";")[0]) -eq $false)
    {
    	New-Item –Type directory –Force –path ($Env:PSMODULEPATH -Split ";")[0]
    }

    $SPoshModPath = ($Env:PSMODULEPATH -Split ";")[0] + "\SPoshMod"

    if((Test-Path $SPoshModPath) -eq $false)
    {
        New-Item –Type directory –Force –path $SPoshModPath
    }
     
    Copy-Item ".\*.*"  "$SPoshModPath\" -include *.ps1, *.psm1, *.exe, *.dll -force -recurse -exclude "_*"
   
}

if($configuration -eq "Release")
{
    $zipName = "$(get-location)\SPoshModV1_" + [DateTime]::Now.ToString("yyyyMMyy") + ".zip"
    
    if (-not (test-path $zipName)) { 
        set-content $zipName ("PK" + [char]5 + [char]6 + ("$([char]0)" * 18)) 
    } 

    $zipFile = (new-object -com shell.application).NameSpace($zipName) 
    
    $files = get-childitem ".\*.*" -include *.ps1, *.psm1, *.exe, *.dll -force -recurse -exclude "_*"
    
    Out-Host "Create ZIP $zipName ..." 
    
    $files | foreach {$zipFile.CopyHere($_.fullname); $_.FullName} 
    
    Out-Host "ZIP created." 
    
    #HACK: When building with VS zip will be empty without sleep
    [System.Threading.Thread]::Sleep(1000)
}