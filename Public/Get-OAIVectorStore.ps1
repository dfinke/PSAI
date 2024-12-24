<#
.SYNOPSIS
Retrieves vector stores from the specified base URL.

.DESCRIPTION
The Get-OAIVectorStore function retrieves vector stores from the specified base URL. It supports various parameters such as limit, order, after, before, and raw output.

.PARAMETER limit
A limit on the number of objects to be returned. Limit can range between 1 and 100, and the default is 20.

.PARAMETER order
Sort order by the created_at timestamp of the objects. asc for ascending order and desc for descending order.

.PARAMETER after
A cursor for use in pagination. after is an object ID that defines your place in the list. For instance, if you make a list request and receive 100 objects, ending with obj_foo, your subsequent call can include after=obj_foo in order to fetch the next page of the list.

.PARAMETER before
A cursor for use in pagination. before is an object ID that defines your place in the list. For instance, if you make a list request and receive 100 objects, ending with obj_foo, your subsequent call can include before=obj_foo in order to fetch the previous page of the list.

.PARAMETER Raw
Switch parameter. If specified, the function returns the raw response object. Otherwise, it returns only the data property of the response.

.EXAMPLE
Get-OAIVectorStore -limit 10 -order desc
Retrieves the 10 most recent vector stores in descending order.

.OUTPUTS
The function returns an array of vector stores or the raw response object, depending on the value of the Raw parameter.

.LINK
https://platform.openai.com/docs/api-reference/vector-stores/list
#>

function Get-OAIVectorStore {
    [CmdletBinding()]
    param (
        $limit,
        [ValidateSet('asc', 'desc')]
        $order = 'desc',
        $after,
        $before,
        [Switch]$Raw
    )

    process {
        $uri = "/vector_stores"
        $Method = "Get"

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

        if ($queryParams.Count -gt 0) {
            $uri += "?" + ($queryParams -join "&")
        }

        $params = @{
            Uri    = $uri
            Method = $Method
        }

        $response = Invoke-OAIBeta @params | Select-Object -ExpandProperty ResponseObject

        if ($Raw) {
            return $response
        }
        else {
            return $response.data
        }
    }
}