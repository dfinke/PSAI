<#
.SYNOPSIS
Opens the OpenAI Platform Vector Stores page in the default web browser.

.DESCRIPTION
The Show-OAIVectorStoreWebPage function opens the OpenAI Platform Vector Stores page in the default web browser. If a vector store ID is provided, it opens the specific vector store's page; otherwise, it opens the general vector stores page.

.PARAMETER vectorStoreId
Specifies the ID of the vector store to open. If not provided, the function opens the general vector stores page.

.EXAMPLE
Show-OAIVectorStoreWebPage -vectorStoreId "12345"
Opens the web browser and navigates to the OpenAI Platform Vector Store with ID "12345".

.EXAMPLE
Show-OAIVectorStoreWebPage
Opens the web browser and navigates to the general OpenAI Platform Vector Stores page.

#>
function Show-OAIVectorStoreWebPage {
    param(
        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias("id")]
        $vectorStoreId 
    )

    if ($vectorStoreId) {
        $uri = 'https://platform.openai.com/storage/vector_stores/{0}' -f $vectorStoreId
    }
    else {
        $uri = 'https://platform.openai.com/storage/vector_stores'
    }

    Start-Process $uri
}