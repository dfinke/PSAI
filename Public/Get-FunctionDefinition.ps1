function Get-FunctionDefinition {
    <#
    .SYNOPSIS
    Returns the definition of one or more PowerShell functions.

    .DESCRIPTION
    The Get-FunctionDefinition function takes an array of CommandInfo objects representing PowerShell functions and returns their definitions as strings.

    .PARAMETER FunctionInfo
    An array of CommandInfo objects representing PowerShell functions.

    .EXAMPLE    
    Get-FunctionDefinition (Get-Command Get-FunctionDefinition)
    #>
    [CmdletBinding()]
    param (
        [System.Management.Automation.CommandInfo[]]$FunctionInfo
    )

    foreach ($functionTarget in $FunctionInfo) {
        "
function $($functionTarget.Name) {
$($functionTarget.Definition)
}"
    }
}