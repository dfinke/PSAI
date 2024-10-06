Import-Module $PSScriptRoot\..\..\PSAI.psd1 -Force

$SecretAgent = New-Agent -Instructions "Recipes should be under 5 ingredients"
$SecretAgent | Get-AgentResponse 'Share a breakfast recipe.'
