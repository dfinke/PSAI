<#
.SYNOPSIS
Retrieves files from a vector store.

.DESCRIPTION
The Get-OAIVectorStoreFile function retrieves files from a vector store based on the specified parameters. It sends a GET request to the vector store API endpoint and returns the files that match the specified criteria.

.PARAMETER VectorStoreId
The ID of the vector store from which to retrieve the files.

.PARAMETER Limit
The maximum number of files to retrieve. The default value is 20.

.PARAMETER Order
The order in which the files should be sorted. Valid values are 'asc' (ascending) and 'desc' (descending). The default value is 'desc'.

.PARAMETER After
Retrieve files that were created after the specified date and time.

.PARAMETER Before
Retrieve files that were created before the specified date and time.

.PARAMETER Filter
A filter to apply to the files. This can be used to narrow down the results based on specific criteria. One of in_progress, completed, failed, cancelled.

.EXAMPLE
Get-OAIVectorStoreFile -VectorStoreId "12345" -Limit 50 -Order "asc" -After "2022-01-01" -Filter "name eq 'example.txt'"
Retrieves the first 50 files from the vector store with ID "12345", sorted in ascending order, that were created after January 1, 2022, and have the name "example.txt".

.LINK
https://platform.openai.com/docs/api-reference/vector-stores-files/listFiles
#>

function Get-OAIVectorStoreFile {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        $VectorStoreId,
        $limit = 20,
        [ValidateSet('asc', 'desc')]
        $order = 'desc',
        $after,
        $before,
        [ValidateSet('in_progress', 'completed', 'failed', 'cancelled')]
        $filter
    )

    $params = @{
        Uri    = "vector_stores/$VectorStoreId/files"
        Method = "Get"
    }

    $queryParams = @()

    if ($limit) {
        $queryParams += "limit=$limit"
    }

    if ($order) {
        $queryParams += "order=$order"
    }

    if ($after) {
        $queryParams += "after=$after"
    }

    if ($before) {
        $queryParams += "before=$before"
    }

    if ($filter) {
        $queryParams += "filter=$filter"
    }

    if ($queryParams.Count -gt 0) {
        $params.Uri += "?" + ($queryParams -join "&")
    }

    $response = Invoke-OAIBeta @params | Select-Object -ExpandProperty ResponseObject

    if ($null -ne $response) {
        return $response.data
    }
}