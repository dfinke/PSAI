# Only OpenAI and Azure OpenAI support Assistants with the RAG model. Also not all models support the RAG model.
# For OpenAI you can use gpt-3.5-turbo, gpt-4-turbo-preview or later supported models

# Assistants, vector databases and files live on after you use them. This is how you create a new assistant with a new vector store containing data from your files

# Add some files to the Vector Store
$vectorStore = Add-OAIVectorStore -Path  $PSScriptRoot/Files/

# Indexing takes some time depending on the size of the files. You can check the status of the vector store with the following command:
while (($res = Get-OAIVectorStoreItem $vectorStore.id).status -ne "completed") {
    Write-Verbose "Vector Store status: $($res.status)"
    Start-Sleep -Seconds 5
}

# Create a new Assistant with the vector store
$assistantParams = @{
    Tools         = Enable-OAIFileSearchTool
    ToolResources = @{
        file_search = @{
            vector_store_ids = @($vectorStore.id)
        }
    }
}

$Assistant = New-OAIAssistant @assistantParams

# Now you can query your Assistant:

$Assistant | Get-OAIAssistantResponse -Prompt "How do I clean the tray"

$Assistant | Get-OAIAssistantResponse -Prompt "How do clean my dishwasher"

# Cleanup resources after use - or save them for later use

$Assistant | Remove-OAIAssistant

$vectorStore | Remove-OAIVectorStore

Get-OAIFile | Remove-OAIFile