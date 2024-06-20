<#
    this uploads files
    creats a vector store
    adds the files to the vector store
    creates an assistant 
        sets the model 
        with the file search tool enabled
        adds the vector store id
    it updates the vector store name with the assistant id
    and outputs the assistant and vector store
#> 

function New-OAIAssistantWithVectorStore {
    [CmdletBinding()]
    param(   
        [Parameter(Mandatory)]     
        $Path
    )

    $vectorStore = Add-OAIVectorStore -Path $Path

    $assistantParams = @{
        Model         = "gpt-4-turbo-preview"
        Tools         = Enable-OAIFileSearchTool
        ToolResources = @{
            file_search = @{
                vector_store_ids = @($vectorStore.id)
            }
        }
    }

    Write-Host "Creating assistant..." -ForegroundColor Cyan
    $Assistant = New-OAIAssistant @assistantParams

    $vectorStoreName = "Vector Store for $($Assistant.id)"
    $vectorStore = Update-OAIVectorStore -VectorStoreId $vectorStore.id -Name $vectorStoreName
    
    [PSCustomObject]@{
        Assistant   = $Assistant
        VectorStore = $vectorStore
    }
}