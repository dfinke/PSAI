<#
.SYNOPSIS
Retrieves a specific file item from an OpenAI Vector Store.

.DESCRIPTION
The Get-OAIVectorStoreFileItem function retrieves a specific file item from an OpenAI Vector Store based on the provided VectorStoreId and FileId.

.PARAMETER VectorStoreId
The ID of the Vector Store from which to retrieve the file item. This parameter is mandatory.

.PARAMETER FileId
The ID of the file item to retrieve. This parameter is mandatory.

.EXAMPLE
Get-OAIVectorStoreFileItem -VectorStoreId "12345" -FileId "67890"
Retrieves the file item with the ID "67890" from the Vector Store with the ID "12345".

.LINK
https://platform.openai.com/docs/api-reference/vector-stores-files/getFile
#>

function Get-OAIVectorStoreFileItem {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        $VectorStoreId,
        [Parameter(Mandatory)]
        $FileId
    )

    $params = @{
        Uri    = $baseUrl + "/vector_stores/$VectorStoreId/files/$FileId"
        Method = "Get"
    }

    Invoke-OAIBeta @params
}