<#
    .Example
    ./02-calculatorTool.ps1 -ShowToolCalls

    😎 : 3*5+6
    😎 : is it prime
    😎 : bye
#>
param(
    [string]$prompt = 'is 5 * 2 + 1 a prime number?',
    [Switch]$ShowToolCalls,
    [Switch]$Interactive
)

Import-Module $PSScriptRoot\..\..\PSAI.psd1 -Force

$agent = New-Agent -Tools (New-CalculatorTool) -ShowToolCalls:$ShowToolCalls

if ($prompt) {
    $agent | Invoke-InteractiveCLI
}
else {
    $agent | Get-AgentResponse $prompt
}