# generates typed objects from list item/s. 
# Needs to get a SPItem array (e.g. SPListItemCollection) piped in. Works with internal name.
# when $fieldNames=$null then select all fields
function global:Select-SPoshObj([string[]]$fieldNames, [switch]$useDisplayNames, [switch]$hiddenFields)
{	
	process
	{			
		if($_ -isnot [Microsoft.SharePoint.SPItem])
		{
			throw "Object is not a SPItem!"
		}       
		
		if($fieldNames -eq $null)
		{
			$script:fieldNames = $_.Fields | foreach-object{
				if($_.Hidden -eq $false -or $hiddenFields -eq $true)
				{
					if($useDisplayNames -eq $false){$_.InternalName}
					else{$_.Title}
				}
			}
		}
		
		$obj = New-Object System.Object
		
		foreach($fieldName in $script:fieldNames)
		{
            if($useDisplayNames -eq $true)
            {
                $script:field = $_.Fields[$fieldName]
            }
            else
            {
                $script:field = $_.Fields.GetFieldByInternalName($fieldName)
            }
            
			$id = $field.ID	
            $null = Invoke-Expression "Add-Member -InputObject `$obj -MemberType ScriptProperty -Name '$fieldName' -Value {`$this.BaseItem.Item([Guid]'$id')}{`$this.BaseItem.Item([Guid]'$id')=`$args[0]}"  
		}
		
		Add-Member -InputObject $obj -MemberType NoteProperty -Name BaseItem -Value $_ -Force
		Add-Member -InputObject $obj -MemberType ScriptMethod -Name Delete -Value { $this.BaseItem.Delete() }
        Add-Member -InputObject $obj -MemberType ScriptMethod -Name Update -Value { $this.BaseItem.Update() }
		Add-Member -InputObject $obj -MemberType ScriptMethod -Name SystemUpdate -Value { $this.BaseItem.Update($args[0]) }   
        
		return $obj
	}
}

$SPoshModFunctions = @("Select-SPoshObj")
Export-ModuleMember -Function $SPoshModFunctions -Variable InvalidClasses

#$web = get-spweb http://localhost/websites/PowerWebPart
#$list = $web.Lists["Test"] 
#$objects = $list.Items | select-sposhobj
#$objects | out-gridview
#$object = $objects[0]
#$newObject= $list.Items.Add() | select-sposhobj
#$newObject.Title = "test"
#$newObject.Update()