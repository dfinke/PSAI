# ToDo: add optional parameters for thread
<#
.SYNOPSIS
Creates a new thread using the OpenAI API.

.DESCRIPTION
The New-OAIThread function sends a POST request to the OpenAI API to create a new thread.

.PARAMETER None

.INPUTS
None. You cannot pipe input to this function.

.OUTPUTS
None. The function does not generate any output.

.EXAMPLE
New-OAIThread
Creates a new thread using the OpenAI API.

.LINK
https://platform.openai.com/docs/api-reference/threads/createThread
#>

function New-OAIThread {
    [CmdletBinding()]

    $url = Get-OAIEndpoint -Url 'threads'
    $Method = 'Post'

    if ($OAIProvider -eq 'AzureOpenAI') {
        $url += '?api-version={0}' -f $AzOAISecrets.apiVersion 
    }

    Invoke-OAIBeta -Uri $url -Method $Method
}
