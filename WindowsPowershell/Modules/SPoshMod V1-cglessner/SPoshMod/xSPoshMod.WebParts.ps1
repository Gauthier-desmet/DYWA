
function Get-SPWebPartManager($pageUrl=$(throw "parameter $pageUrl is missing!"), $scope="Shared")
{
	$site =  New-Object -TypeName "Microsoft.SharePoint.SPSite" -ArgumentList $pageUrl;
	$web = $site.OpenWeb();
	$file = $web.GetFile($pageUrl)
	$wpm = $file.GetLimitedWebPartManager([System.Web.UI.WebControls.WebParts.PersonalizationScope]::$scope)

	return $wpm
}

function Dispose-SPWebPartManager([Microsoft.SharePoint.WebPartPages.SPLimitedWebPartManager]$wpm=$(throw "parameter -$wpm is missing!"))
{
	$wpm.Web.Site.Dispose()
	$wpm.Web.Dispose()
	$wpm.Dispose()
}

$SPoshModFunctions = @("Get-SPWebPartManager","Dispose-SPWebPartManager")
Export-ModuleMember -Function $SPoshModFunctions -Variable InvalidClasses



