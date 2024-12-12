<#
Modify threadBeta
POST
 
https://api.openai.com/v1/threads/{thread_id}

Modifies a thread.

Path parameters
thread_id
string

Required
The ID of the thread to modify. Only the metadata can be modified.

Request body
tool_resources
object or null

Optional
A set of resources that are made available to the assistant's tools in this thread. The resources are specific to the type of tool. For example, the code_interpreter tool requires a list of file IDs, while the file_search tool requires a list of vector store IDs.


Show properties
metadata
map

Optional
Set of 16 key-value pairs that can be attached to an object. This can be useful for storing additional information about the object in a structured format. Keys can be a maximum of 64 characters long and values can be a maxium of 512 characters long.

Returns
The modified thread object matching the specified ID.
#>

<#
.SYNOPSIS
Updates an OAI thread with the specified thread ID, tool resources, and metadata.

.DESCRIPTION
The Update-OAIThread function is used to update an OAI (OpenAI) thread with the specified thread ID, tool resources, and metadata. It sends a POST request to the specified URL with the provided data.

.PARAMETER threadId
The ID of the thread to be updated. This parameter is mandatory.

.PARAMETER toolResources
The tool resources to be associated with the thread.

.PARAMETER metadata
The metadata to be associated with the thread.

.EXAMPLE
Update-OAIThread -threadId "12345" -toolResources "resource1, resource2" -metadata "key1=value1, key2=value2"

This example updates the OAI thread with the ID "12345" by associating it with the tool resources "resource1" and "resource2", and the metadata "key1=value1" and "key2=value2".

.LINK
https://platform.openai.com/docs/api-reference/threads/modifyThread
#>
function Update-OAIThread {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        $threadId,
        $toolResources,
        $metadata
    )

    $url = 'threads/' + $threadId
    $Method = 'Post'

    $body = @{
        tool_resources = $toolResources
        metadata       = $metadata
    }

    Invoke-OAIBeta -Uri $url -Method $Method -Body $body
}