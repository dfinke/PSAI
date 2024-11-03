<#
.SYNOPSIS
Retrieves the properties of a specified tool.

.DESCRIPTION
The Get-ToolProperty function retrieves the properties of a specified tool from a given parameter.

.PARAMETER Parameter

Gets the type from the parameter and returns a tool property object.

.EXAMPLE
Get-ToolProperty -Parameter "FilePath"

Returns a string type property for the FilePath parameter.
#>
function Get-ToolProperty {
    [CmdletBinding()]
    param (
        [Parameter(
            Mandatory,
            ValueFromPipeline
        )]
        $Parameter
    )
    
    begin {
        
    }
    
    process {
        
        $property = [ordered]@{}
        switch ($Parameter.ParameterType -as [string]) {
            { $_ -match "string$|datetime" } { $property.Add("type", "string") }
            "string[]" { $property.Add("type", "array"), $property.Add("items", @{type = "string" }) }
            "System.IO.FileInfo" { $property.Add("type", "string") }
            "psobject" { $property.Add("type", "object") }
            "System.Object" { $property.Add("type", "object") }
            "psobject[]" { $property.Add("type", "object"), $property.Add("items", @{type = "object" }) }
            "System.Object[]" { $property.Add("type", "object"), $property.Add("items", @{type = "object" }) }
            { $_ -match 'decimal|float|single|int|long' } { $property.Add("type", "number") }
            { $_ -match 'switch|bool|boolean' } { $property.Add("type", "boolean") }
            default { $property.Add("type", "object") ; Write-Verbose "Unknown type: $_ - added as object" }
        }
        $ValidValues = $Parameter.Attributes.ValidValues
        if ($property["type"] -and $ValidValues) {
            $property["enum"] = $ValidValues
        }
        if ($Parameter.HelpMessage) {
            $property["description"] = $Parameter.HelpMessage
        }
    }
    
    end {
        if ($property.Count -gt 0) {
            $property
        }
    }
}