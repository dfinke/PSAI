<#
.SYNOPSIS
    Tests the LLM model.

.DESCRIPTION
    This function tests the LLM model by checking if the specified model is valid based on the provider.
    
.NOTES
    Used in the ValidateScript attribute of the -Model parameter in multiple functions.
#>
function Test-LLMModel {    
    $provider = Get-OAIProvider
    if ($provider -eq 'OpenAI') {
        $modelList = 'gpt-4', 'gpt-3.5-turbo', 'gpt-3.5-turbo-16k', 'gpt-4-turbo-preview', 'gpt-4-1106-preview', 'gpt-3.5-turbo-1106'
        if ($_ -in $modelList) {
            $true
        }
        else {
            throw 'Invalid model. Valid models are: ' + $modelList
        }
    }
    elseif ($provider -eq 'AzureOpenAI') {
        $true
    }
}