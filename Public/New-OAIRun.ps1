<#
.SYNOPSIS
Creates a new run for the OpenAI assistant.

.DESCRIPTION
The New-OAIRun function is used to create a new run for the OpenAI assistant. It sends a POST request to the specified URL with the provided thread ID and assistant ID.

.PARAMETER threadId
The ID of the thread for which the run is being created. This parameter is mandatory.

.PARAMETER assistantId
The ID of the assistant for which the run is being created. This parameter is mandatory.

.EXAMPLE
New-OAIRun -threadId "12345" -assistantId "67890"
Creates a new run for the OpenAI assistant with the specified thread ID and assistant ID.

.LINK
https://platform.openai.com/docs/api-reference/runs/createRun
#>

<#
Create run Beta
POST https://api.openai.com/v1/threads/{thread_id}/runs

Create a run.

Path parameters
thread_id
string
Required
The ID of the thread to run.

Request body
assistant_id
string
Required
The ID of the assistant to use to execute this run.

model
string or null
Optional
The ID of the Model to be used to execute this run. If a value is provided here, it will override the model associated with the assistant. If not, the model associated with the assistant will be used.

instructions
string or null
Optional
Override the default system message of the assistant. This is useful for modifying the behavior on a per-run basis.

tools
array or null
Optional
Override the tools the assistant can use for this run. This is useful for modifying the behavior on a per-run basis.


Show possible types
metadata
map
Optional
Set of 16 key-value pairs that can be attached to an object. This can be useful for storing additional information about the object in a structured format. Keys can be a maximum of 64 characters long and values can be a maxium of 512 characters long.

Returns
A run object.
#>

function New-OAIRun {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('thread_id')]
        $ThreadId,
        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('id')]
        $AssistantId,        
        [ValidateSet('gpt-4', 'gpt-3.5-turbo', 'gpt-3.5-turbo-16k', 'gpt-4-turbo-preview', 'gpt-4-1106-preview', 'gpt-3.5-turbo-1106')]
        $Model,
        $Instructions,
        $Tools,
        $Metadata
    )

    Process {
        if ($null -eq $ThreadId -or $null -eq $AssistantId) {
            break
        }

        $url = Get-OAIEndpoint -Url "threads/$ThreadId/runs"

        $Method = 'Post'

        $body = @{
            assistant_id = $AssistantId
        }

        if ($null -ne $Model) {
            $body['model'] = $Model
        }

        if ($null -ne $Instructions) {
            $body['instructions'] = $Instructions
        }

        if($null -ne $Metadata) {
            $body['metadata'] = $Metadata         
        }

        if ($Tools) {
            $body['tools'] = @($Tools)
        }   

        Invoke-OAIBeta -Uri $url -Method $Method -Body $body
    }   
}