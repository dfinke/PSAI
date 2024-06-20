<#
Create run Beta
POST
 
https://api.openai.com/v1/threads/{thread_id}/runs

Create a run.

Path parameters
thread_id
string

Required
The ID of the thread to run.

Request body
assistant_id
string

Required
The ID of the assistant to use to execute this run.

model
string

Optional
The ID of the Model to be used to execute this run. If a value is provided here, it will override the model associated with the assistant. If not, the model associated with the assistant will be used.

instructions
string or null

Optional
Overrides the instructions of the assistant. This is useful for modifying the behavior on a per-run basis.

additional_instructions
string or null

Optional
Appends additional instructions at the end of the instructions for the run. This is useful for modifying the behavior on a per-run basis without overriding other instructions.

additional_messages
array or null

Optional
Adds additional messages to the thread before creating the run.


Show properties
tools
array or null

Optional
Override the tools the assistant can use for this run. This is useful for modifying the behavior on a per-run basis.

metadata
map

Optional
Set of 16 key-value pairs that can be attached to an object. This can be useful for storing additional information about the object in a structured format. Keys can be a maximum of 64 characters long and values can be a maxium of 512 characters long.

temperature
number or null

Optional
Defaults to 1
What sampling temperature to use, between 0 and 2. Higher values like 0.8 will make the output more random, while lower values like 0.2 will make it more focused and deterministic.

top_p
number or null

Optional
Defaults to 1
An alternative to sampling with temperature, called nucleus sampling, where the model considers the results of the tokens with top_p probability mass. So 0.1 means only the tokens comprising the top 10% probability mass are considered.

We generally recommend altering this or temperature but not both.

stream
boolean or null

Optional
If true, returns a stream of events that happen during the Run as server-sent events, terminating when the Run enters a terminal state with a data: [DONE] message.

max_prompt_tokens
integer or null

Optional
The maximum number of prompt tokens that may be used over the course of the run. The run will make a best effort to use only the number of prompt tokens specified, across multiple turns of the run. If the run exceeds the number of prompt tokens specified, the run will end with status incomplete. See incomplete_details for more info.

max_completion_tokens
integer or null

Optional
The maximum number of completion tokens that may be used over the course of the run. The run will make a best effort to use only the number of completion tokens specified, across multiple turns of the run. If the run exceeds the number of completion tokens specified, the run will end with status incomplete. See incomplete_details for more info.

truncation_strategy
object

Optional
Controls for how a thread will be truncated prior to the run. Use this to control the intial context window of the run.


Show properties
tool_choice
string or object

Optional
Controls which (if any) tool is called by the model. none means the model will not call any tools and instead generates a message. auto is the default value and means the model can pick between generating a message or calling one or more tools. required means the model must call one or more tools before responding to the user. Specifying a particular tool like {"type": "file_search"} or {"type": "function", "function": {"name": "my_function"}} forces the model to call that tool.

response_format
string or object

Optional
Specifies the format that the model must output. Compatible with GPT-4o, GPT-4 Turbo, and all GPT-3.5 Turbo models since gpt-3.5-turbo-1106.

Setting to { "type": "json_object" } enables JSON mode, which guarantees the message the model generates is valid JSON.

Important: when using JSON mode, you must also instruct the model to produce JSON yourself via a system or user message. Without this, the model may generate an unending stream of whitespace until the generation reaches the token limit, resulting in a long-running and seemingly "stuck" request. Also note that the message content may be partially cut off if finish_reason="length", which indicates the generation exceeded max_tokens or the conversation exceeded the max context length.

Returns
A run object.
#>

function New-OAIRun {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('thread_id')]
        $ThreadId,
        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('id')]
        $AssistantId,
        $Model,
        $Instructions,
        $AdditionalInstructions,
        $AdditionalMessages,
        $Tools,
        $Metadata,
        $Temperature,
        $TopP,
        [Switch]$Stream,
        $MaxPromptTokens,
        $MaxCompletionTokens,
        $TruncationStrategy,
        $ToolChoice,
        [ValidateSet('auto', 'json', 'text')]
        $ResponseFormat
    )

    Process {
        if ($null -eq $ThreadId -or $null -eq $AssistantId) {
            break
        }

        $url = Get-OAIEndpoint -Url "threads/$ThreadId/runs"

        $Method = 'Post'

        $body = @{
            assistant_id = $AssistantId
        }

        if ($null -ne $Model) {
            $body['model'] = $Model
        }

        if ($null -ne $Instructions) {
            $body['instructions'] = $Instructions
        }

        if ($null -ne $AdditionalInstructions) {
            $body['additional_instructions'] = $AdditionalInstructions
        }

        if ($null -ne $AdditionalMessages) {
            $body['additional_messages'] = @($AdditionalMessages)
        }

        if($null -ne $Tools) {
            $body['tools'] = @($Tools)
        }

        if ($null -ne $Metadata) {
            $body['metadata'] = $Metadata         
        }

        if ($null -ne $Temperature) {
            $body['temperature'] = $Temperature
        }

        if ($null -ne $TopP) {
            $body['top_p'] = $TopP
        }

        if ($Stream) {
            $body['stream'] = $Stream
        }

        if ($null -ne $MaxPromptTokens) {
            $body['max_prompt_tokens'] = $MaxPromptTokens
        }

        if ($null -ne $MaxCompletionTokens) {
            $body['max_completion_tokens'] = $MaxCompletionTokens
        }

        if ($null -ne $TruncationStrategy) {
            $body['truncation_strategy'] = $TruncationStrategy
        }

        if ($null -ne $ToolChoice) {
            $body['tool_choice'] = $ToolChoice
        }

        if ($null -ne $ResponseFormat) {
            $body['response_format'] = $ResponseFormat
        }

        Invoke-OAIBeta -Uri $url -Method $Method -Body $body
    }   
}