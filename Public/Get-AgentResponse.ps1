<#
.SYNOPSIS
Retrieves a response from a PSAIAgent based on a given prompt.

.DESCRIPTION
The Get-AgentResponse function takes a prompt string and an agent object, validates the agent, and retrieves a response from the agent. The agent must be of type 'PSAIAgent'.

.PARAMETER Prompt
The prompt string to be sent to the agent.

.PARAMETER Agent
The agent object from which the response is to be retrieved. This parameter accepts input from the pipeline.

.EXAMPLE
PS C:\> Get-AgentResponse -Prompt "Hello, how are you?" -Agent $myAgent

.EXAMPLE
PS C:\> $myAgent | Get-AgentResponse -Prompt "What is the weather today?"

.NOTES
The agent object must be of type 'PSAIAgent'. If the agent is not valid, an error will be thrown.
#>
function Get-AgentResponse {
    [CmdletBinding()]
    param(
        [string]$Prompt,
        [Parameter(ValueFromPipeline)]
        $Agent
    )
    
    Process {
        if (!($agent.psobject.TypeNames -contains 'PSAIAgent')) {
            Write-Error "Agent is not a valid PSAIAgent"
            return
        }

        $agent.PrintResponse($Prompt)
    }
}