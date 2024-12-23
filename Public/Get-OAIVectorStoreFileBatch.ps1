<#
.SYNOPSIS
Retrieves information about a specific file batch in an OpenAI Vector Store.

.DESCRIPTION
The Get-OAIVectorStoreFileBatch function retrieves information about a specific file batch in an OpenAI Vector Store. It requires the VectorStoreId and BatchId parameters to identify the file batch.

.PARAMETER VectorStoreId
Specifies the ID of the Vector Store that contains the file batch.

.PARAMETER BatchId
Specifies the ID of the file batch to retrieve information for.

.EXAMPLE
Get-OAIVectorStoreFileBatch -VectorStoreId "store1" -BatchId "batch1"
Retrieves information about the file batch with ID "batch1" in the Vector Store with ID "store1".

.LINK
https://platform.openai.com/docs/api-reference/vector-stores-file-batches/listFiles
#>

function Get-OAIVectorStoreFileBatch {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        $VectorStoreId,
        [Parameter(Mandatory)]
        $BatchId
    )
    
    $params = @{
        Uri    = "vector_stores/$VectorStoreId/file_batches/$BatchId"
        Method = "Get"
    }

    Invoke-OAIBeta @params | Select-Object -ExpandProperty ResponseObject
}