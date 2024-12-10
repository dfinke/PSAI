<#
Delete message Beta
DELETE
 
https://api.openai.com/v1/threads/{thread_id}/messages/{message_id}

Deletes a message.

Path parameters
thread_id
string

Required
The ID of the thread to which this message belongs.

message_id
string

Required
The ID of the message to delete.

Returns
Deletion status
#>

function Remove-OAIMessage {
    param(
        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('thread_id')]        
        $ThreadId,
        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('id')]
        $MessageId
    )

    Process {

        if ($null -eq $ThreadId -or $null -eq $MessageId) {
            return
        }

        $Method = 'Delete'
        $url = "threads/$ThreadId/messages/$MessageId"

        Invoke-OAIBeta -Uri $url -Method $Method
    }
}