<#
.SYNOPSIS
Removes an OAI Vector Store.

.DESCRIPTION
The Remove-OAIVectorStore function removes an OAI (OpenAI) Vector Store by sending a DELETE request to the specified URI.

.PARAMETER VectorStoreId
The ID of the Vector Store to be removed.

.EXAMPLE
Remove-OAIVectorStore -VectorStoreId "12345"
Removes the OAI Vector Store with the ID "12345".

.LINK
https://platform.openai.com/docs/api-reference/vector-stores/delete
#>
function Remove-OAIVectorStore {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [Alias('Id')]
        $VectorStoreId
    )

    Process {
        $params = @{
            Uri    = "vector_stores/$VectorStoreId"
            Method = 'DELETE'
        }

        Invoke-OAIBeta @params
    }
}