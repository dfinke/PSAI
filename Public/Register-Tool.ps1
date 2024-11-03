<#
.SYNOPSIS
Registers a tool by name.

.DESCRIPTION
The Register-Tool function is used to register a tool by name. It retrieves the command specification for the specified function and registers it as a tool.

.PARAMETER FunctionName
The name of the function to register as a tool.

.PARAMETER Strict
Specifies strict mode for the server side OpenAPI.

.EXAMPLE
Register-Tool -FunctionName "MyFunction" -Strict
Registers the function named "MyFunction" as a tool and enforces strict mode.

#>
function Register-Tool {
    [CmdletBinding()]
    param(
        [parameter(Mandatory)]
        [string[]]
        $FunctionName,
        $ParameterSet=0,
        [Switch]$Strict
    )
    foreach ($f in $FunctionName) {
        Write-Verbose "Registering tool $f"
        Get-OAIFunctionCallSpec $f -Strict:$Strict -ParameterSet $ParameterSet
    }
}