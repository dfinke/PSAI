<#
.SYNOPSIS
Stops a batch of files in an OpenAI Vector Store.

.DESCRIPTION
The Stop-OAIVectorStoreFileBatch function is used to stop a batch of files in an OpenAI Vector Store. It cancels the processing of the specified batch of files.

.PARAMETER VectorStoreId
The ID of the Vector Store where the batch of files is located.

.PARAMETER BatchId
The ID of the batch of files to be stopped.

.EXAMPLE
Stop-OAIVectorStoreFileBatch -VectorStoreId "12345" -BatchId "67890"
Stops the batch of files with ID "67890" in the Vector Store with ID "12345".

.LINK
https://platform.openai.com/docs/api-reference/vector-stores-file-batches/cancelBatch
#>

function Stop-OAIVectorStoreFileBatch {
    param (
        [Parameter(Mandatory)]
        $VectorStoreId,
        [Parameter(Mandatory)]
        $BatchId
    )

    $params = @{
        Uri    = $baseUrl + "/vector_stores/$VectorStoreId/file_batches/$BatchId/cancel"
        Method = 'POST'
    }

    Invoke-OAIBeta @params
}