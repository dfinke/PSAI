<#
Cancel a run Beta
POST
 
https://api.openai.com/v1/threads/{thread_id}/runs/{run_id}/cancel

Cancels a run that is in_progress.

Path parameters
thread_id
string

Required
The ID of the thread to which this run belongs.

run_id
string

Required
The ID of the run to cancel.

Returns
The modified run object matching the specified ID.
#>

function Stop-OAIRun {
    param(
        [Parameter(Mandatory)]
        $ThreadId,
        [Parameter(Mandatory)]
        $RunId
    )

    $uri = "threads/$ThreadId/runs/$RunId/cancel"

    Invoke-OAIBeta -Method POST -Uri $uri
}