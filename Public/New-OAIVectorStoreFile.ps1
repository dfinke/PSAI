<#
.SYNOPSIS
Creates a new file in the specified vector store.

.DESCRIPTION
The New-OAIVectorStoreFile function creates a new file in the specified vector store. It takes the VectorStoreId and FileIds as mandatory parameters. The function sends a POST request to the specified vector store's files endpoint to create the file.

.PARAMETER VectorStoreId
The ID of the vector store where the file will be created.

.PARAMETER FileIds
The ID(s) of the file(s) to be created in the vector store. This parameter accepts pipeline input by property name.

.EXAMPLE
New-OAIVectorStoreFile -VectorStoreId "12345" -FileIds "file1", "file2"

This example creates two files with IDs "file1" and "file2" in the vector store with ID "12345".

.EXAMPLE
dir *.md | Invoke-OAIUploadFile | New-OAIVectorStoreFile -VectorStoreId "12345"

This example uploads all Markdown files in the current directory to OpenAI and creates files in the vector store with ID "12345" for each uploaded file.

.LINK
https://platform.openai.com/docs/api-reference/vector-stores-files/createFile

#>
function New-OAIVectorStoreFile {
    param(
        [Parameter(Mandatory)]
        $VectorStoreId,
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [Alias('id')]
        $FileIds
    )

    Begin {
        $params = @{
            Uri    = "vector_stores/$VectorStoreId/files"
            Method = "Post"
        }

        $targetFileIds = @()
    }

    Process {
        $targetFileIds += $FileIds
    }

    End {
        foreach ($fileId in $targetFileIds) {    
            $params.Body = @{file_id = $FileId }
            Invoke-OAIBeta @params
        }
    }
}