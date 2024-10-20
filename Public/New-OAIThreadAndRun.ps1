<#
.SYNOPSIS
Creates a new OpenAI thread and runs it.

.DESCRIPTION
The New-OAIThreadAndRun function creates a new thread and runs it using the OpenAI API. It allows you to specify various parameters such as the assistant ID, thread, model, instructions, tools, tool resources, metadata, temperature, top-p, stress, max prompt tokens, max completion tokens, truncation strategy, tool choices, and response format.

.PARAMETER AssistantId
The ID of the assistant to use for the thread.

.PARAMETER Thread
The thread to be used for the conversation.

.PARAMETER Model
The model to use for generating responses.

.PARAMETER Instructions
The instructions to provide to the model.

.PARAMETER Tools
The tools to be used during the conversation.

.PARAMETER ToolResources
The resources required by the tools.

.PARAMETER Metadata
Additional metadata to include with the request.

.PARAMETER Temperature
The temperature parameter controls the randomness of the model's output. Higher values (e.g., 0.8) make the output more random, while lower values (e.g., 0.2) make it more focused and deterministic.

.PARAMETER TopP
The top-p parameter controls the diversity of the model's output. It specifies the cumulative probability threshold for generating tokens. Higher values (e.g., 0.9) result in more diverse output, while lower values (e.g., 0.3) make it more focused.

.PARAMETER Stress
The stress parameter controls how much the model is "pushed" to generate a response. Higher values (e.g., 0.8) make the model more likely to generate a response, even if it's not confident. Lower values (e.g., 0.2) make it more cautious.

.PARAMETER MaxPromptTokens
The maximum number of tokens allowed in the prompt.

.PARAMETER MaxCompletionTokens
The maximum number of tokens allowed in the completion.

.PARAMETER TruncationStrategy
The truncation strategy to use when the input exceeds the maximum token limit.

.PARAMETER ToolChoices
The choices for the tools to be used during the conversation.

.PARAMETER ResponseFormat
The format in which the response should be returned. Valid values are 'auto', 'json', and 'text'.

.EXAMPLE
New-OAIThreadAndRun -AssistantId 'assistant-123' -Thread 'Hello' -Model 'gpt-3.5-turbo' -Instructions 'Translate the following English text to French: "Hello, how are you?"' -Tools 'translation' -ToolResources @{ translation = @{ source_language = 'en' ; target_language = 'fr' } } -Temperature 0.8 -TopP 0.9 -Stress 0.5 -MaxPromptTokens 100 -MaxCompletionTokens 50 -TruncationStrategy 'longest_first' -ToolChoices @{ translation = 'translation' } -ResponseFormat 'json'

.NOTES
This function requires the Invoke-OAIBeta function to be available in the current session.

.LINK
https://platform.openai.com/docs/api-reference/runs/createThreadAndRun

#>

function New-OAIThreadAndRun {
    param (
        [Parameter(Mandatory)]
        $AssistantId,
        $Thread,
        $Model,
        $Instructions,
        $Tools,
        $ToolResources,
        $Metadata,
        [ValidateScript({ $_ -ge 0 -and $_ -le 2 })]
        $Temperature,
        [ValidateScript({ $_ -ge 0 -and $_ -le 1 })]
        $TopP,
        $Stress,
        $MaxPromptTokens,
        $MaxCompletionTokens,
        $TruncationStrategy,
        $ToolChoices,
        [ValidateSet('auto', 'json', 'text')]
        $ResponseFormat
    )

    $body = @{
        assistant_id = $AssistantId
    }

    if($null -ne $Thread) {
        $body.thread = $Thread
    }

    if($null -ne $Model) {
        $body.model = $Model
    }
     
    if($null -ne $Instructions) {
        $body.instructions = $Instructions
    }

    if($null -ne $Tools) {
        $body.tools = $Tools
    }

    if($null -ne $ToolResources) {
        $body.tool_resources = $ToolResources
    }

    if($null -ne $Metadata) {
        $body.metadata = $Metadata
    }

    if($null -ne $Temperature) {
        $body.temperature = $Temperature
    }

    if($null -ne $TopP) {
        $body.top_p = $TopP
    }

    if($null -ne $Stress) {
        $body.stress = $Stress
    }

    if($null -ne $MaxPromptTokens) {
        $body.max_prompt_tokens = $MaxPromptTokens
    }

    if($null -ne $MaxCompletionTokens) {
        $body.max_completion_tokens = $MaxCompletionTokens
    }

    if($null -ne $TruncationStrategy) {
        $body.truncation_strategy = $TruncationStrategy
    }

    if($null -ne $ToolChoices) {
        $body.tool_choices = $ToolChoices
    }

    if($null -ne $ResponseFormat) {
        $body.response_format = $ResponseFormat
    }

    $url = 'threads/runs'
    $Method = 'Post'

    Invoke-OAIBeta -Uri $url -Method $Method -Body $body
}