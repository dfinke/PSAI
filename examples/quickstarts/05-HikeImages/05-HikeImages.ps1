# Define the image prompt
$imagePrompt = @"
A postal card with an happy hiker waving, there a beautiful mountain in the background.
There is a trail visible in the foreground.
The postal card has text in red saying: 'You are invited for a hike!'
"@

# Set the options for image generation
$completionOptions = @{
    Prompt  = $imagePrompt
    Model   = 'dall-e-3'
    Size    = '1024x1024'
    Quality = 'standard'
}

# Generate the image using the specified options
$response = Get-OAIImageGeneration @completionOptions

# Check if the input prompt was automatically revised
if ($response.data[0].revised_prompt) {
    Write-Host "Input prompt automatically revised to: $($response.data[0].revised_prompt)"
}

# Open the generated image in a browser
Start-Process $response.data[0].url