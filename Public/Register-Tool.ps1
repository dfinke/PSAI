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
        $FunctionName,
        $ParameterSet=0,
        [Switch]$Strict
    )
    
    Write-Verbose "Registering tool $FunctionName"

    Get-OAIFunctionCallSpec $FunctionName -Strict:$Strict -ParameterSet $ParameterSet
}