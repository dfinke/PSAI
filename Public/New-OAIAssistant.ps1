<#
.SYNOPSIS
Creates a new OpenAI Assistant.

.DESCRIPTION
The New-OAIAssistant function is used to create a new OpenAI Assistant. It sends a POST request to the OpenAI API to create the assistant with the specified parameters.

.PARAMETER Name
The name of the assistant.

.PARAMETER Instructions
The instructions to provide to the assistant.

.PARAMETER Description
The description of the assistant.

.PARAMETER Tools
The tools used by the assistant. There can be a maximum of 128 tools per assistant. Tools can be of types code_interpreter, file_search, or function.

.PARAMETER ToolResources
The resources required by the tools used by the assistant. The resources are specific to the type of tool. For example, the code_interpreter tool requires a list of file IDs, while the file_search tool requires a list of vector store IDs.

.PARAMETER Model
The model to use for the assistant. Valid values are 'gpt-4', 'gpt-3.5-turbo', 'gpt-3.5-turbo-16k', 'gpt-4-turbo-preview', 'gpt-4-1106-preview', and 'gpt-3.5-turbo-1106'. The default value is 'gpt-3.5-turbo'.

.PARAMETER Metadata
The metadata associated with the assistant.

.PARAMETER Temperature
The temperature parameter for generating responses. Must be a value between 0 and 2.

.PARAMETER TopP
The top-p parameter for generating responses. Must be a value between 0 and 1.

.PARAMETER ResponseFormat
The format of the response. Valid values are 'auto', 'json', and 'text'. The default value is 'auto'.

.EXAMPLE
New-OAIAssistant -Name 'MyAssistant' -Instructions 'How can I help you?' -Description 'An assistant to answer questions' -Tools 'Calculator' -ToolResources 'https://example.com/calculator' -Model 'gpt-3.5-turbo' -Metadata @{ 'version' = '1.0' } -Temperature 0.8 -TopP 0.5 -ResponseFormat 'json'

This example creates a new OpenAI Assistant named 'MyAssistant' with the specified parameters.

.LINK
https://platform.openai.com/docs/api-reference/assistants/createAssistant
#>
function New-OAIAssistant {
    [CmdletBinding()]
    param(
        $Name,
        $Instructions,
        $Description,
        $Tools,
        $ToolResources,
        $Model,
        $Metadata,
        [ValidateScript({ $_ -ge 0 -and $_ -le 2 })]
        $Temperature = $null,
        [ValidateScript({ $_ -ge 0 -and $_ -le 1 })]
        $TopP = $null,
        [ValidateSet('auto', 'json', 'text')]
        $ResponseFormat = 'auto'
    )
    
    $url = 'assistants'
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

    if ($ToolResources) {
        $body['tool_resources'] = $ToolResources
    }

    if ($Metadata) {
        $body['metadata'] = $Metadata        
    }

    if ($Temperature) {
        $body['temperature'] = $Temperature
    }

    if ($TopP) {
        $body['top_p'] = $TopP
    }

    if ($ResponseFormat -eq 'json') {
        $body['response_format'] = @{ 'type' = 'json_object' }
    }
    elseif ($ResponseFormat -eq 'text') {
        $body['response_format'] = @{ 'type' = 'text' }
    }

    Invoke-OAIBeta -Uri $url -Method $Method -Body $body
}