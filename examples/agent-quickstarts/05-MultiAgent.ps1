<#
.SYNOPSIS
This script initializes and runs a multi-agent system using the PSAI module.

.PARAMETER prompt
A string containing the prompt to which the agent should respond. If not provided, the script will invoke an interactive CLI.

.PARAMETER ShowToolCalls
A switch parameter that, when specified, will show the tool calls made by the agent.

.DESCRIPTION
The script imports the PSAI module and initializes a set of tools. It then creates an agent with the specified tools and optionally shows the tool calls. If a prompt is provided, the agent responds to it. If no prompt is provided, the script invokes an interactive CLI for user interaction.

.EXAMPLE
.\05-MultiAgent.ps1 -prompt "Hello, agent!"
This command runs the script and gets the agent's response to the prompt "Hello, agent!".

.EXAMPLE
.\05-MultiAgent.ps1 -ShowToolCalls
This command runs the script and invokes the interactive CLI, showing the tool calls made by the agent.

.NOTES
The script assumes that the PSAI module is located in a relative path from the script's directory.
#>
param(
    [string]$prompt = 'What did Microsoft close at and the latest news for them?',
    [Switch]$ShowToolCalls
)

# Import the PSAI module from the relative path
Import-Module $PSScriptRoot\..\..\PSAI.psd1 -Force

$tools = $(
    New-TavilyAITool
    New-StockTickerTool
)

$agent = New-Agent -Tools $tools -ShowToolCalls:$ShowToolCalls

# If no prompt is provided, invoke the interactive CLI
if (!$prompt) {
    $agent | Invoke-InteractiveCLI
}
# Otherwise, get the agent's response to the provided prompt
else {
    $agent | Get-AgentResponse $prompt
}