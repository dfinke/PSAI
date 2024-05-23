<#
.SYNOPSIS
Updates an OAI message by sending a POST request to the specified thread and message IDs.

.DESCRIPTION
The Update-OAIMessage function updates an OAI message by sending a POST request to the specified thread and message IDs. It allows you to update the metadata of a message.

.PARAMETER ThreadId
The ID of the thread to which the message belongs. This parameter is also aliased as 'thread_id'.

.PARAMETER MessageId
The ID of the message to be updated. This parameter is also aliased as 'id'.

.PARAMETER Metadata
Optional. The updated metadata for the message.

.EXAMPLE
Update-OAIMessage -ThreadId 1234 -MessageId 5678 -Metadata @{ "key" = "value" }
Updates the message with ID 5678 in the thread with ID 1234, setting the metadata to {"key": "value"}.

.LINK
https://platform.openai.com/docs/api-reference/messages/modifyMessage
#>

function Update-OAIMessage {
    param(
        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('thread_id')]        
        $ThreadId,
        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('id')]
        $MessageId,
        $Metadata
    )

    Process {

        if ($null -eq $ThreadId -or $null -eq $MessageId) {
            return
        }

        $Method = 'Post'
        $url = $baseUrl + "/threads/$ThreadId/messages/$MessageId"

        $body = @{}
        if ($null -ne $Metadata) {
            $body.metadata = $Metadata
        }

        Invoke-OAIBeta -Uri $url -Method $Method -Body $body
    }
}