<#
.SYNOPSIS
A PowerShell script to interact with an AI agent for web search tasks.

.DESCRIPTION
This script utilizes the PSAI module to create an AI agent with the TavilyAI tool. 
It can either invoke an interactive CLI or get a response to a provided prompt.

.PARAMETER prompt
A string parameter that specifies the query to be sent to the AI agent. 
Defaults to 'what is the latest news on PowerShell?' if not provided.

.PARAMETER ShowToolCalls
A switch parameter that, when specified, enables the display of tool calls made by the agent.

.EXAMPLE
.\03-WebSearchTool.ps1 -prompt "What is the weather today?"

This example runs the script with a prompt asking for the weather today.

.EXAMPLE
.\03-WebSearchTool.ps1 -ShowToolCalls

This example runs the script with the ShowToolCalls switch enabled, displaying the tool calls made by the agent.

.NOTES
The script imports the PSAI module from a relative path and creates a new agent using the TavilyAI tool.
If no prompt is provided, it invokes an interactive CLI for user interaction.
#>
param(
    [string]$prompt = 'what is the latest news on PowerShell?',
    [Switch]$ShowToolCalls
)

# Import the PSAI module from the relative path
Import-Module $PSScriptRoot\..\..\PSAI.psd1 -Force

# Create a new agent with the TavilyAI tool and set the ShowToolCalls switch
$agent = New-Agent -Tools (New-TavilyAITool) -ShowToolCalls:$ShowToolCalls

# If no prompt is provided, invoke the interactive CLI
if (!$prompt) {
    $agent | Invoke-InteractiveCLI
}
# Otherwise, get the agent's response to the provided prompt
else {
    $agent | Get-AgentResponse $prompt
}