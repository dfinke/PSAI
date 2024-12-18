<#
Create vector store file batch Beta
POST
 
https://api.openai.com/v1/vector_stores/{vector_store_id}/file_batches

Create a vector store file batch.

Path parameters
vector_store_id
string

Required
The ID of the vector store for which to create a File Batch.

Request body
file_ids
array

Required
A list of File IDs that the vector store should use. Useful for tools like file_search that can access files.

.LINK
https://platform.openai.com/docs/api-reference/vector-stores-file-batches/createBatch
#>

function New-OAIVectorStoreFileBatch {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        $VectorStoreId,
        [Parameter(Mandatory)]
        $FileIds
    )
    
    $params = @{
        Uri    = "vector_stores/$VectorStoreId/file_batches"
        Method = "Post"
        Body   = @{file_ids = $FileIds }
    }

    Invoke-OAIBeta @params
}