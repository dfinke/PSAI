# Set the completion options for the chat
$completionOptions = @{
    MaxTokens        = 1000
    Temperature      = 1
    FrequencyPenalty = 0
    PresencePenalty  = 0
    TopP             = 0.95
    #Model            = 'gpt-3.5-turbo'
}

# Create an empty array to store chat messages
$messages = @()

# Read the content of the "hikes.md" file
$markdown = Get-Content -Raw "$PSScriptRoot\hikes.md"

# Set the system prompt for the chat
$systemPrompt = @"
You are upbeat and friendly. You introduce yourself when first saying hello. 
Provide a short answer only based on the user hiking records below:

$($markdown)
"@

# Add the system prompt as a chat message
$messages += New-ChatRequestSystemMessage $systemPrompt

# Display the hiking history
Write-Host @"
        -=-=- Hiking History -=-=--
$($markdown)
"@

# Set the user greeting
$userGreeting = "Hi!"

# Add the user greeting as a chat message
$messages += New-ChatRequestUserMessage $userGreeting
Write-Host "
User: $($userGreeting)"

# Invoke the chat completion with the provided messages and options
$response = Invoke-OAIChatCompletion -Messages $messages @completionOptions

# Get the assistant's response from the completion response
$assistantResponse = $response.choices[0].message

# Display the assistant's response
Write-Host "
Assistant: $($assistantResponse.content)"

# Add the assistant's response as a chat message
$messages += New-ChatRequestAssistantMessage $assistantResponse.content

# Set the hike request from the user
$hikeRequest = @"
I would like to know the ratio of hikes I did in Canada compared to hikes done in other countries.
"@

# Add the hike request as a chat message
$messages += New-ChatRequestUserMessage $hikeRequest

# Display the hike request
Write-Host "
User: $($hikeRequest)"

# Invoke the chat completion again with the updated messages and options
$response = Invoke-OAIChatCompletion -Messages $messages @completionOptions

# Get the assistant's response to the hike request
$assistantResponse = $response.choices[0].message

# Display the assistant's response
Write-Host "
Assistant: $($assistantResponse.content)"
