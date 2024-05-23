<#
.SYNOPSIS
    Invokes the OpenAI Chat Completions API.

.DESCRIPTION
    This function sends a request to the OpenAI Chat Completions API to generate a completion based on the provided messages.

.PARAMETER Messages
    Specifies the messages to use for generating the completion. This parameter is mandatory.

.PARAMETER Model
    Specifies the model to use for generating the completion. The default value is "gpt-4o".

.PARAMETER Seed
    Specifies the seed to use for generating the completion.

.PARAMETER Stop
    Specifies the stop sequence to use for generating the completion.

.PARAMETER Stream
    Specifies whether to use stream mode for generating the completion.

.PARAMETER Temperature
    Specifies the temperature to use for generating the completion.

.PARAMETER TopP
    Specifies the top-p value to use for generating the completion.

.PARAMETER Tools
    Specifies the tools to use for generating the completion.

.PARAMETER ToolChoice
    Specifies the tool choice to use for generating the completion.

.PARAMETER User
    Specifies the user to use for generating the completion.

.EXAMPLE
    $messages = @(
        @{
            'role' = 'system'
            'content' = 'You are a helpful assistant.'
        },
        @{
            'role' = 'user'
            'content' = 'What is the weather like today?'
        }
    )

    Invoke-OAIChatCompletion -Messages $messages -Model 'gpt-4o' -User 'John'

.NOTES
    This function requires the Invoke-OAIBeta function to be available.

.LINK
https://platform.openai.com/docs/api-reference/chat/create
#>  
function Invoke-OAIChatCompletion {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        $Messages,        
        $Model = "gpt-4o",
        $Seed,
        $Stop,
        $Stream,
        $Temperature,
        $TopP,
        $Tools,
        $ToolChoice,
        $User
    )
    
    $body = @{}

    if ($null -ne $Messages) { 
        $body['messages'] = @($Messages)
    }

    if ($null -ne $Model) { 
        $body['model'] = $Model
    }

    if ($null -ne $Seed) { 
        $body['seed'] = $Seed
    }

    if ($null -ne $Stop) { 
        $body['stop'] = $Stop 
    }

    if ($null -ne $Stream) { 
        $body['stream'] = $Stream 
    }

    if ($null -ne $Temperature) { 
        $body['temperature'] = $Temperature 
    }

    if ($null -ne $TopP) { 
        $body['top_p'] = $TopP 
    }

    if ($null -ne $Tools) { 
        $body['tools'] = $Tools 
    }

    if ($null -ne $ToolChoice) { 
        $body['tool_choice'] = $ToolChoice 
    }

    if ($null -ne $User) { 
        $body['user'] = $User 
    }

    $url = $baseUrl + '/chat/completions'
    $Method = 'Post'

    Invoke-OAIBeta -Uri $url -Method $Method -Body $body
}