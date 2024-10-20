<#
List vector store files in a batch Beta
GET
 
https://api.openai.com/v1/vector_stores/{vector_store_id}/file_batches/{batch_id}/files

Returns a list of vector store files in a batch.

Path parameters
vector_store_id
string

Required
The ID of the vector store that the files belong to.

batch_id
string

Required
The ID of the file batch that the files belong to.

Query parameters
limit
integer

Optional
Defaults to 20
A limit on the number of objects to be returned. Limit can range between 1 and 100, and the default is 20.

order
string

Optional
Defaults to desc
Sort order by the created_at timestamp of the objects. asc for ascending order and desc for descending order.

after
string

Optional
A cursor for use in pagination. after is an object ID that defines your place in the list. For instance, if you make a list request and receive 100 objects, ending with obj_foo, your subsequent call can include after=obj_foo in order to fetch the next page of the list.

before
string

Optional
A cursor for use in pagination. before is an object ID that defines your place in the list. For instance, if you make a list request and receive 100 objects, ending with obj_foo, your subsequent call can include before=obj_foo in order to fetch the previous page of the list.

filter
string

Optional
Filter by file status. One of in_progress, completed, failed, cancelled.

Returns
A list of vector store file objects.
#>

function Get-OAIVectorStoreFilesInBatch {
    param(
        [Parameter(Mandatory)]
        $VectorStoreId,
        [Parameter(Mandatory)]
        $BatchId,
        $limit,
        $order,
        $after,
        $before,
        $filter
    )

    $uri = "vector_stores/$VectorStoreId/file_batches/$BatchId/files"
    $query = @()

    if ($limit) {
        $query += "limit=$limit"
    }

    if ($order) {
        $query += "order=$order"
    }

    if ($after) {
        $query += "after=$after"
    }

    if ($before) {
        $query += "before=$before"
    }

    if ($filter) {
        $query += "filter=$filter"
    }

    if ($query.Count -gt 0) {
        $uri += "?" + ($query -join "&")
    }

    $params = @{
        Uri    = $uri
        Method = 'GET'
    }

    $response = Invoke-OAIBeta @params

    if ($null -ne $response) {
        return $response.data
    }
}