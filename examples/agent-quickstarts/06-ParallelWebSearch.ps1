param(
    [string]$Prompt = 'Find the current stable PowerShell release and cite your sources.',
    [switch]$ShowToolCalls
)

Import-Module "$PSScriptRoot/../../PSAI.psd1" -Force
$agent = New-Agent -Tools 'Search-ParallelWeb', 'Get-ParallelWebContent' `
    -Instructions 'Search for current facts. Fetch only when excerpts are insufficient. Cite source URLs.' `
    -ShowToolCalls:$ShowToolCalls
$agent | Get-AgentResponse -Prompt $Prompt
