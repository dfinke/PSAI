<#
.SYNOPSIS
Converts an object to JSON format.

.DESCRIPTION
The `dumpJson` function converts an object to JSON format using the `ConvertTo-Json` cmdlet.

.PARAMETER obj
Specifies the object to be converted to JSON format.

.INPUTS
System.Object

.OUTPUTS
System.String

.EXAMPLE
$obj = @{
    Name = "John Doe"
    Age = 30
    Email = "johndoe@example.com"
}
dumpJson $obj

This example converts a hashtable object to JSON format.

#>
function dumpJson {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline)]
        [object]$obj,
        $Depth = 10,
        [Switch]$Compress
    )
    begin {
        $pscExists = $null -ne (Get-Module -list PwshSpectreConsole -ErrorAction SilentlyContinue)
    }
    Process {

        $result = ConvertTo-Json $obj -Depth $Depth -Compress:$Compress
        # if ($pscExists) {
        #     $result | Format-SpectreJson
        # }
        # else {
        #     $result        
        # }
        $result
    }
}