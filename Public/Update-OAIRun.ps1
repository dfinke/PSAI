<#
Modify runBeta
POST
 
https://api.openai.com/v1/threads/{thread_id}/runs/{run_id}

Modifies a run.

Path parameters
thread_id
string

Required
The ID of the thread that was run.

run_id
string

Required
The ID of the run to modify.

Request body
metadata
map

Optional
Set of 16 key-value pairs that can be attached to an object. This can be useful for storing additional information about the object in a structured format. Keys can be a maximum of 64 characters long and values can be a maxium of 512 characters long.

Returns
The modified run object matching the specified ID.
#>

function Update-OAIRun {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('thread_id')]        
        $ThreadId,
        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('run_id')]
        $RunId,
        $Metadata
    )

    Process {
        if ($null -eq $ThreadId -or $null -eq $RunId) {
            return
        }

        $url = "threads/$ThreadId/runs/$RunId"
        $Method = 'Post'

        $body = @{}
        if ($Metadata) {
            $body['metadata'] = $Metadata
        }

        Invoke-OAIBeta -Uri $url -Method $Method -Body $body | Select-Object -ExpandProperty ResponseObject
    }
}