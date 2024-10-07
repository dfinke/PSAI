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
            "string" { $property.Add("type", "string") }
            "string[]" { $property.Add("type", "array"), $property.Add("items", @{type = "string"}) }
            "System.IO.FileInfo" { $property.Add("type", "string") }
            "psobject" { $property.Add("type", "object") }
            "psobject[]" { $property.Add("type", "object"), $property.Add("items", @{type = "object"})}
            { $_ -match 'decimal|float|single|int' } {  $property.Add("type", "number")}
            { $_ -match 'switch|bool|boolean'} {  $property.Add("type", "boolean") }
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