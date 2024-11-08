param(
    $prompt = 'write detailed usage documentation including realistic examples',
    $targetPath = "$PSScriptRoot\__tests__"
)

Import-Module $PSScriptRoot\PSAI.psd1 -Force

$agent = New-Agent -LLM (New-OpenAIChat 'o1-preview') -Instructions (Invoke-FilesToPrompt $targetPath) 
$result = $agent | Get-AgentResponse $prompt

$ts = Get-Date -Format "yyMMdd-hhmmss"
$result | Set-Content -Path "$PSScriptRoot\docs-$($ts).md" 