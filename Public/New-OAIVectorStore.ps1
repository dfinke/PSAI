<#
.SYNOPSIS
Creates a new vector store in OpenAI.

.DESCRIPTION
The New-OAIVectorStore function creates a new vector store in OpenAI using the OpenAI API. It allows you to specify the name, file IDs, expiration time, and metadata for the vector store.

.PARAMETER Name
The name of the vector store.

.PARAMETER FileIds
An array of file IDs to associate with the vector store.

.PARAMETER ExpiresAfter
The expiration time for the vector store. After this time, the vector store will be deleted. 
"expires_after": { "anchor": "last_active_at", "days": 7 }

.PARAMETER Metadata
A hashtable containing additional metadata for the vector store.

.EXAMPLE
New-OAIVectorStore -Name "MyVectorStore" -FileIds "file1", "file2" -ExpiresAfter (Get-Date).AddDays(7) -Metadata @{ "key1" = "value1"; "key2" = "value2" }

This example creates a new vector store named "MyVectorStore" with two file IDs, an expiration time of 7 days from the current date, and additional metadata.

.LINK
https://platform.openai.com/docs/api-reference/vector-stores/create
#>

function New-OAIVectorStore {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline)]
        $Name,
        [string[]]$FileIds,
        $ExpiresAfter,
        [hashtable]$Metadata
    )

    process {
        $body = @{}
            
        if ($Name) {
            $body.name = $Name
        }

        if ($FileIds) {
            $body.file_ids = $FileIds
        }

        if ($ExpiresAfter) {
            $body.expires_after = $ExpiresAfter
        }

        if ($Metadata) {
            $body.metadata = $Metadata
        }

        $params = @{
            Uri    = "vector_stores"
            Method = "Post"
            Body   = $body
        }

        $response = Invoke-OAIBeta @params
        $response.ResponseObject
    }
}