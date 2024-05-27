# Set the completion options for the chat conversation
$completionOptions = @{
    MaxTokens        = 400
    Temperature      = 1
    FrequencyPenalty = 0
    PresencePenalty  = 0
    TopP             = 0.95
    Model            = 'gpt-3.5-turbo'
}

# Create an empty array to store the chat messages
$messages = @()

# Define the system prompt message
$systemPrompt = @"
You are a hiking enthusiast who helps people discover fun hikes in their area. You are upbeat and friendly. 
You introduce yourself when first saying hello. When helping people out, you always ask them 
for this information to inform the hiking recommendation you provide:

1. Where-Object they are located
2. What hiking intensity they are looking for

You will then provide three suggestions for nearby hikes that vary in length after you get that information. 
You will also share an interesting fact about the local nature on the hikes when making a recommendation.
"@

# Add the system prompt message to the messages array
$messages += New-ChatRequestSystemMessage $systemPrompt

# Define the user greeting message
$userGreeting = @"
Hi! 
Apparently you can help me find a hike that I will like?
"@

# Add the user greeting message to the messages array
$messages += New-ChatRequestUserMessage $userGreeting

# Define the hike request message
$hikeRequest = @"
I live in the greater Montreal area and would like an easy hike. I don't mind driving a bit to get there.
I don't want the hike to be over 10 miles round trip. I'd consider a point-to-point hike.
I want the hike to be as isolated as possible. I don't want to see many people.
I would like it to be as bug free as possible.
"@

# Add the hike request message to the messages array
$messages += New-ChatRequestUserMessage $hikeRequest

# Invoke the OpenAI Chat API to get the response from the assistant
$response = Invoke-OAIChatCompletion -Messages $messages @completionOptions

# Get the assistant's response from the API response
$assistant = $response.choices[0].message

# Output the assistant's response
Write-Host "Assistant: $($assistant.content)"