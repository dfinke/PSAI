<#
.SYNOPSIS
Retrieves the OpenAI function call specification for a given function.

.DESCRIPTION
The Get-OAIFunctionCallSpec function retrieves the OpenAI function call specification for a given function. It takes a FunctionInfo object as input and returns the function call specification in a tool-specific format.

.PARAMETER functionInfo
Specifies the FunctionInfo object representing the function for which to retrieve the function call specification.

.EXAMPLE
Function Test-Func {param($x)}; $functionInfo = Get-Command -Name "Test-Func"
Get-OAIFunctionCallSpec -functionInfo $functionInfo

This example retrieves the function call specification for the "Get-Process" function.

.INPUTS
[System.Management.Automation.FunctionInfo]
Accepts a FunctionInfo object representing the function for which to retrieve the function call specification.

.OUTPUTS
[System.Object]
Returns the function call specification in a tool-specific format.
#>
function Get-OAIFunctionCallSpec {
    [CmdletBinding()]
    param(
        [System.Management.Automation.FunctionInfo]$functionInfo
    )

    if ($null -eq $functionInfo) {
        return
    }

    $functions = foreach ($function in $functionInfo) {
        $fnd = Get-FunctionDefinition $function
        ConvertTo-OpenAIFunctionSpec $fnd -Raw
    }

    ConvertTo-ToolFormat $functions
}
