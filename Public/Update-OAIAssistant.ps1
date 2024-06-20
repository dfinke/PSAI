<#
.SYNOPSIS
Updates an OpenAI Assistant.

.DESCRIPTION
This function updates an OpenAI Assistant with the specified parameters.

.PARAMETER Id
The ID of the OpenAI Assistant to update.

.PARAMETER Model
The model to use for the OpenAI Assistant.

.PARAMETER Name
The name of the OpenAI Assistant.

.PARAMETER Description
The description of the OpenAI Assistant.

.PARAMETER Instructions
The instructions for using the OpenAI Assistant.

.PARAMETER Tools
The tools required for using the OpenAI Assistant.

.PARAMETER FileIds
The IDs of the files associated with the OpenAI Assistant.

.PARAMETER Metadata
The metadata for the OpenAI Assistant.

.EXAMPLE
Update-OAIAssistant -Id "assistant123" -Model "gpt-3.5-turbo" -Name "My Assistant" -Description "This is my assistant" -Instructions "Use this assistant to perform various tasks" -Tools "PowerShell", "Visual Studio Code" -FileIds "file1", "file2" -Metadata @{ "key1" = "value1"; "key2" = "value2" }

.LINK
https://platform.openai.com/docs/api-reference/assistants/modifyAssistant
#>
function Update-OAIAssistant {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipelineByPropertyName)]
        $Id,
        $Model,
        $Name,
        $Description,
        $Instructions,        
        $Tools,  
        $ToolResources,
        $Metadata,
        [ValidateScript({ $_ -ge 0 -and $_ -le 2 })]
        $Temperature = $null,
        [ValidateScript({ $_ -ge 0 -and $_ -le 1 })]
        $TopP = $null,
        [ValidateSet('auto', 'json', 'text')]
        $ResponseFormat = 'auto'
    )

    Process {
        $url = Get-OAIEndpoint -Url "assistants/$Id"
        $Method = 'Post'

        $body = @{}

        if ($Model) {
            $body['model'] = $Model
        }
        if ($Name) {
            $body['name'] = $Name
        }
        if ($Description) {
            $body['description'] = $Description
        }
        if ($Instructions) {
            $body['instructions'] = $Instructions
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
}