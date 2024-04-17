<#
.SYNOPSIS
Converts an array of functions into a tool format.

.DESCRIPTION
The ConvertTo-ToolFormat function takes an array of functions and converts them into a tool format. Each function in the array is transformed into a hashtable with a 'type' key set to 'function' and a 'function' key set to the original function.

.PARAMETER functions
An array of hashtables representing functions.

.EXAMPLE
$functions = @(
    @{
        Name = 'Get-User'
        Description = 'Retrieves user information'
        Parameters = @(
            @{
                Name = 'Username'
                Type = 'String'
                Description = 'The username of the user'
            }
        )
    }
)

ConvertTo-ToolFormat -functions $functions
#>

function ConvertTo-ToolFormat {
    [CmdletBinding()]
    param(
        [hashtable[]]$functions
    )

    foreach ($function in $functions) {
        @{
            type     = 'function'
            function = $function
        }
    }
}