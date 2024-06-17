<#
.SYNOPSIS
Submits tool outputs for a specific thread and run.

.DESCRIPTION
The Submit-OAIToolOutputs function is used to submit tool outputs for a specific thread and run in an application. It sends a POST request to the specified URL with the provided tool outputs.

.PARAMETER threadId
The ID of the thread for which the tool outputs are being submitted.

.PARAMETER runId
The ID of the run for which the tool outputs are being submitted.

.PARAMETER toolOutputs
The tool outputs to be submitted. This parameter should be an object containing the tool outputs.

.EXAMPLE
Submit-OAIToolOutputs -threadId 123 -runId 456 -toolOutputs $outputs

.LINK
https://platform.openai.com/docs/api-reference/runs/submitToolOutputs
#>

function Submit-OAIToolOutputs {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        $ThreadId,
        [Parameter(Mandatory)]
        $RunId,
        [Parameter(Mandatory)]
        $ToolOutputs
    )

    $url = Get-OAIEndpoint -Url "threads/$ThreadId/runs/$RunId/submit_tool_outputs"
    $Method = 'Post'

    $body = @{
        tool_outputs = $ToolOutputs
    }

    Invoke-OAIBeta -Uri $url -Method $Method -Body $body
}