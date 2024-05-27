<#
.SYNOPSIS
    This function tests if a given JSON string is valid by attempting to convert it using ConvertFrom-Json cmdlet.

.DESCRIPTION
    The Test-JsonReplacement function takes a JSON string as input and attempts to convert it using the ConvertFrom-Json cmdlet. If the conversion is successful, it returns $true; otherwise, it returns $false.

.PARAMETER JSON
    Specifies the JSON string to be tested.

.EXAMPLE
    Test-JsonReplacement -JSON '{"name": "John", "age": 30, "city": "New York"}'
    This example tests the validity of the given JSON string.

.INPUTS
    System.String

.OUTPUTS
    System.Boolean

#>

function Test-JsonReplacement {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        $JSON
    )

    Write-Verbose "Using ConvertFrom-Json"
    try {
        ConvertFrom-Json -InputObject $Json | Out-Null
        $true
    }
    catch {
        $false
    }

}