<#
Retrieve run step Beta
GET
 
https://api.openai.com/v1/threads/{thread_id}/runs/{run_id}/steps/{step_id}

Retrieves a run step.

Path parameters
thread_id
string

Required
The ID of the thread to which the run and run step belongs.

run_id
string

Required
The ID of the run to which the run step belongs.

step_id
string

Required
The ID of the run step to retrieve.

Returns
The run step object matching the specified ID.
#>

function Get-OAIRunStepItem {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        $ThreadId,
        [Parameter(Mandatory)]
        $RunId,
        [Parameter(Mandatory)]
        $StepId
    )
    
    $url = "threads/$ThreadId/runs/$RunId/steps/$StepId"
    $Method = 'Get'

    Invoke-OAIBeta -Url $url -Method $Method
}