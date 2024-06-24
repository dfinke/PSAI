<#
.SYNOPSIS
    Invokes the OpenAI Chat Completions API.

.DESCRIPTION
    This function sends a request to the OpenAI Chat Completions API to generate a chat-based completion.

.PARAMETER Messages
    Specifies the list of messages in the conversation. Each message should have a 'role' (either 'system', 'user', or 'assistant') and 'content' (the content of the message).

.PARAMETER Model
    Specifies the model to use for generating completions. Default is 'gpt-4o'.

.PARAMETER FrequencyPenalty
    Specifies the frequency penalty to apply. Higher values will make the model avoid repeating the same completions. Default is not set.

.PARAMETER LogitBias
    Specifies the logit bias to apply. Positive values will make the model more likely to generate completions similar to the examples in the training set, while negative values will make it less likely. Default is not set.

.PARAMETER Logprobs
    Specifies whether to include log probabilities in the response. Default is not set.

.PARAMETER TopLogprobs
    Specifies the number of log probabilities to include in the response. Default is not set.

.PARAMETER MaxTokens
    Specifies the maximum number of tokens to generate in the response. Default is not set.

.PARAMETER N
    Specifies the number of completions to generate. Default is not set.

.PARAMETER PresencePenalty
    Specifies the presence penalty to apply. Higher values will make the model more cautious and avoid generating completions that overlap with the input. Default is not set.

.PARAMETER ResponseFormat
    Specifies the format of the response. Valid values are 'auto', 'json', or 'text'. Default is not set.

.PARAMETER Seed
    Specifies the random seed to use for generating completions. Default is not set.

.PARAMETER Stop
    Specifies the stop sequence to use for generating completions. Default is not set.

.PARAMETER Stream
    Specifies whether to enable streaming of the API response. Default is not set.

.PARAMETER StreamOptions
    Specifies the options for streaming. Default is not set.

.PARAMETER Temperature
    Specifies the temperature to use for generating completions. Higher values will make the output more random, while lower values will make it more deterministic. Default is not set.

.PARAMETER TopP
    Specifies the top-p value to use for generating completions. Default is not set.

.PARAMETER Tools
    Specifies the list of tools to use for generating completions. Default is not set.

.PARAMETER ToolChoice
    Specifies the tool choice to use for generating completions. Default is not set.

.PARAMETER User
    Specifies the user for the conversation. Default is not set.

.EXAMPLE
    $messages = @(
        @{
            'role' = 'user'
            'content' = 'Hello, how are you?'
        },
        @{
            'role' = 'assistant'
            'content' = 'I am doing well, thank you!'
        }
    )

    Invoke-OAIChatCompletion -Messages $messages -Model 'gpt-4o' -MaxTokens 50

    This example generates a chat-based completion using the 'gpt-4o' model with a maximum of 50 tokens.

#>

function Invoke-OAIChatCompletion {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        $Messages,
        $Model = 'gpt-4o',
        $FrequencyPenalty,
        $LogitBias,
        $Logprobs,
        $TopLogprobs,
        $MaxTokens,
        $N,
        $PresencePenalty,
        [ValidateSet('auto', 'json', 'text')]        
        $ResponseFormat,
        $Seed,
        $Stop,
        $Stream,
        $StreamOptions,
        [ValidateScript({ $_ -ge 0 -and $_ -le 2 })]
        $Temperature,
        [ValidateScript({ $_ -ge 0 -and $_ -le 1 })]
        $TopP,
        $Tools,
        $ToolChoice,
        $ParallelToolCalls,
        $User
    )
    
    $body = @{}

    if ($null -ne $Messages) { 
        $body['messages'] = @($Messages)
    }

    if ($null -ne $Model) { 
        $body['model'] = $Model
    }

    if ($null -ne $FrequencyPenalty) { 
        $body['frequency_penalty'] = $FrequencyPenalty
    }

    if ($null -ne $LogitBias) { 
        $body['logit_bias'] = $LogitBias
    }

    if ($null -ne $Logprobs) { 
        $body['logprobs'] = $Logprobs
    }

    if ($null -ne $TopLogprobs) { 
        $body['top_logprobs'] = $TopLogprobs
    }

    if ($null -ne $MaxTokens) { 
        $body['max_tokens'] = $MaxTokens
    }

    if ($null -ne $N) { 
        $body['n'] = $N
    }

    if ($null -ne $PresencePenalty) { 
        $body['presence_penalty'] = $PresencePenalty
    }

    if ($null -ne $ResponseFormat) { 
        $body['response_format'] = $ResponseFormat
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

    if ($null -ne $StreamOptions) { 
        $body['stream_options'] = $StreamOptions
    }

    if ($null -ne $Temperature) { 
        $body['temperature'] = $Temperature
    }

    if ($null -ne $TopP) { 
        $body['top_p'] = $TopP
    }

    if ($null -ne $Tools) { 
        $body['tools'] = @($Tools)
    }

    if ($null -ne $ToolChoice) { 
        $body['tool_choice'] = $ToolChoice
    }

    if ($null -ne $ParallelToolCalls) { 
        $body['parallel_tool_calls'] = $ParallelToolCalls
    }

    if ($null -ne $User) { 
        $body['user'] = $User
    }

    <#
curl "https://openai-gpt-latest.openai.azure.com/openai/deployments/gpt-4o/chat/completions?api-version=2024-02-15-preview" \
-H "Content-Type: application/json" \
-H "api-key: YOUR_API_KEY" \
-d "{
\"messages\": [],
\"max_tokens\": 800,
\"temperature\": 0.7,
\"frequency_penalty\": 0,
\"presence_penalty\": 0,
\"top_p\": 0.95,
\"stop\": null
}
    #>

    $url = $baseUrl + '/chat/completions'
    
    if ((Get-OAIProvider) -eq 'AzureOpenAI') {
        $AzOAISecrets = Get-AzOAISecrets

        $url = $baseUrl + '/deployments/' + $AzOAISecrets.deploymentName + '/chat/completions'
    }
    
    $Method = 'Post'

    Invoke-OAIBeta -Uri $url -Method $Method -Body $body
}