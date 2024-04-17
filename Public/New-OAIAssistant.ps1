<#
.SYNOPSIS
Creates a new OpenAI Assistant.

.DESCRIPTION
The New-OAIAssistant function is used to create a new OpenAI Assistant. It sends a POST request to the OpenAI API to create the assistant with the specified parameters.

.PARAMETER Name
The name of the assistant.

.PARAMETER Instructions
The instructions for the assistant.

.PARAMETER Description
The description of the assistant.

.PARAMETER Tools
The tools used by the assistant.

.PARAMETER Model
The model to be used by the assistant. Valid values are 'gpt-4', 'gpt-3.5-turbo', 'gpt-3.5-turbo-16k', 'gpt-4-1106-preview', 'gpt-4-turbo-preview', and 'gpt-3.5-turbo-1106'. The default value is 'gpt-3.5-turbo'.

.PARAMETER FileIds
The file IDs associated with the assistant.

.PARAMETER Metadata
The metadata associated with the assistant.

.EXAMPLE
New-OAIAssistant -Name 'MyAssistant' -Instructions 'Please assist me with my tasks.' -Description 'An assistant to help with various tasks.' -Tools 'PowerShell', 'Azure CLI' -Model 'gpt-4' -FileIds 'file1', 'file2' -Metadata @{ 'key1' = 'value1'; 'key2' = 'value2' }

#>
function New-OAIAssistant {
    [CmdletBinding()]
    param(
        $Name,
        $Instructions,
        $Description,
        $Tools,        
        [ValidateSet('gpt-4', 'gpt-3.5-turbo', 'gpt-3.5-turbo-16k', 'gpt-4-turbo-preview', 'gpt-4-1106-preview', 'gpt-3.5-turbo-1106')]
        $Model = 'gpt-3.5-turbo',
        [Alias('file_ids')]
        $FileIds,
        $Metadata
    )
    
    $url = $baseUrl + '/assistants'
    $Method = 'Post'
    
    $body = @{
        name         = $Name
        instructions = $Instructions
        model        = $Model
    }

    if ($Description) {
        $body['description'] = $Description        
    }

    if ($Tools) {
        $body['tools'] = @($Tools)
    }

    if ($FileIds) {
        $body['file_ids'] = @($FileIds)
    }

    if ($Metadata) {
        $body['metadata'] = $Metadata        
    }

    Invoke-OAIBeta -Uri $url -Method $Method -Body $body
}