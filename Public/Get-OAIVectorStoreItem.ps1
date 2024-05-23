<#
.SYNOPSIS
Retrieves an item from the OpenAI Vector Store.

.DESCRIPTION
The Get-OAIVectorStoreItem function retrieves an item from the OpenAI Vector Store based on the specified VectorStoreId.

.PARAMETER VectorStoreId
The ID of the vector store item to retrieve.

.INPUTS
None. You cannot pipe objects to this function.

.OUTPUTS
System.Object

.EXAMPLE
Get-OAIVectorStoreItem -VectorStoreId vs_SvMW6In5Y5D5Sl44Aae05eho
Retrieves the vector store item with the specified ID.

.LINK
https://platform.openai.com/docs/api-reference/vector-stores/retrieve
#>

function Get-OAIVectorStoreItem {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('Id')]
        $VectorStoreId
    )

    process {
        $uri = $baseUrl + "/vector_stores/$($VectorStoreId)"
        $Method = "Get"

        Invoke-OAIBeta -Uri $uri -Method $Method 
    }
}