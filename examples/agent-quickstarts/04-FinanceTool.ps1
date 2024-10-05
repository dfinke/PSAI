param(
    [string]$prompt,
    [Switch]$ShowToolCalls
)

# Import the PSAI module from the relative path
Import-Module $PSScriptRoot\..\..\PSAI.psd1 -Force

# Create a new agent with the TavilyAI tool and set the ShowToolCalls switch
$agent = New-Agent -Tools (New-StockTickerTool) -ShowToolCalls:$ShowToolCalls

# If no prompt is provided, invoke the interactive CLI
if (!$prompt) {
    $agent | Invoke-InteractiveCLI
}
# Otherwise, get the agent's response to the provided prompt
else {
    $agent | Get-AgentResponse $prompt
}