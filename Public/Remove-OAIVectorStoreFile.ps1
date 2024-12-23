<#
.SYNOPSIS
Removes a file from a vector store.

.DESCRIPTION
The Remove-OAIVectorStoreFile function removes a file from a vector store specified by the VectorStoreId and FileId parameters.

.PARAMETER VectorStoreId
The ID of the vector store from which the file will be removed.

.PARAMETER FileId
The ID of the file to be removed from the vector store.

.EXAMPLE
Remove-OAIVectorStoreFile -VectorStoreId "12345" -FileId "67890"
Removes the file with ID "67890" from the vector store with ID "12345".

.LINK
https://platform.openai.com/docs/api-reference/vector-stores-files/deleteFile
#>
function Remove-OAIVectorStoreFile {
    param (
        [Parameter(Mandatory)]
        $VectorStoreId,
        [Parameter(Mandatory)]
        $FileId
    )

    $params = @{
        Uri    = "vector_stores/$VectorStoreId/files/$FileId"
        Method = "DELETE"
    }

    Invoke-OAIBeta @params | Select-Object -ExpandProperty ResponseObject
}
