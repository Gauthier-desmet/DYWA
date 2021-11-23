# generates typed objects from list item/s. 
# Needs to get a SPItem array (e.g. SPListItemCollection) piped in. Works with internal name.
# when $internalFieldNames=$null then select all fields
function Select-SPItemObject($internalFieldNames)
{
	process
	{			
		if($_ -isnot [Microsoft.SharePoint.SPItem])
		{
			throw "Object is not a SPItem!"
		}
		
		if($internalFieldNames -eq $null)
		{
			$internalFieldNames = $_.Fields | ForEach-Object { $_.InternalName }
		}
		
		$obj = New-Object System.Object
		
		foreach($fieldName in $internalFieldNames)
		{
			if($_.Fields.ContainsField($fieldName) -eq $true)
			{
				Add-Member -InputObject $obj -MemberType NoteProperty -Name $fieldName -Value $_.Item($fieldName)
			}				
		}
		
		Add-Member -InputObject $obj -MemberType NoteProperty -Name ListItem -Value $_
		Add-Member -InputObject $obj -MemberType ScriptMethod -Name Delete -Value { $this.ListItem.Delete()  }
		Add-Member -InputObject $obj -MemberType ScriptMethod -Name Update -Value {
			$properties = Get-Member -InputObject $this -MemberType NoteProperty	
			
			foreach($prop in $properties)
			{
				if($this.ListItem.Fields.ContainsField($prop.Name))
				{
					$field = $this.ListItem.Fields.GetFieldByInternalName($prop.Name)
					if($field.ReadOnlyField -eq $false)
					{
						$value = Invoke-Expression "`$this.$($prop.Name)"
						if($value -ne $null)
						{
							$this.ListItem.Item($field.ID) = $value
						}
					}
				}
			}
			
			$this.ListItem.Update()
		}
		
		return $obj
	}
}

# generates new typed objects from a new list item
function New-SPItemObject($collection, $internalFieldNames)
{
	return $collection.Add() | Select-SPItemObject $internalFieldNames
}

$SPoshModFunctions = @("Select-SPItemObject","New-SPItemObject")
Export-ModuleMember -Function $SPoshModFunctions -Variable InvalidClasses

