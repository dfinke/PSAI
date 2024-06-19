# Set the completion options for the chat request
$completionOptions = @{
    MaxTokens        = 400
    Temperature      = 1
    FrequencyPenalty = 0
    PresencePenalty  = 0
    TopP             = 0.95
    Model            = 'gpt-3.5-turbo'
}

# Read the content of the benefits.md file
$markdown = Get-Content "$PSScriptRoot\benefits.md"

# Create a user request message to summarize the text
$userRequest = @"
Please summarize the following text in 20 words or less:

$($markdown)
"@

# Set the parameters for the chat request
$params = @{
    'messages' = New-ChatRequestUserMessage $userRequest
}

# Invoke the chat completion with the specified parameters and options
$response = Invoke-OAIChatCompletion @params @completionOptions 

# Get the content of the first choice from the response
$response.choices[0].message.content