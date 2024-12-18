<#
.SYNOPSIS
Updates an OAI Vector Store.

.DESCRIPTION
The Update-OAIVectorStore function is used to update an OAI Vector Store with the specified parameters.

.PARAMETER VectorStoreId
The ID of the Vector Store to update.

.PARAMETER Name
The new name for the Vector Store.

.PARAMETER ExpiresAfter
A hashtable specifying the expiration time for the Vector Store. The hashtable should contain the following keys:
- 'anchor': The anchor date and time.
- 'day': The number of days after the anchor date.

.PARAMETER Metadata
A hashtable containing additional metadata for the Vector Store.

.EXAMPLE
Update-OAIVectorStore -VectorStoreId "12345" -Name "New Vector Store" -ExpiresAfter @{ 'anchor' = '2022-12-31T00:00:00Z'; 'day' = 30 } -Metadata @{ 'key' = 'value' }

This example updates the Vector Store with ID "12345" by changing its name to "New Vector Store", setting an expiration time of 30 days after December 31, 2022, and adding a metadata key-value pair.

#>

function Update-OAIVectorStore {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        $VectorStoreId,
        $Name,
        $ExpiresAfter,
        $Metadata
    )

    $body = @{}

    if ($Name) {
        $body.name = $Name
    }

    if ($ExpiresAfter) {
        $body.expires_after = $ExpiresAfter
    }

    if ($Metadata) {
        $body.metadata = $Metadata
    }

    $params = @{
        Uri    = "vector_stores/$VectorStoreId"
        Method = 'POST'
        body   = $body
    }

    Invoke-OAIBeta @params
}