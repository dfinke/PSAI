#region Get-CurrentWeather function
function Get-CurrentWeather {
  param (
    $location,
    $unit
  )
     
  $paramUnit = "m"
  if ($unit -eq "fahrenheit") {
    $paramUnit = "u"
  }
 
  Write-Host "Getting the weather for $location in $unit"
  Invoke-RestMethod "https://wttr.in/$($location)?format=4&$paramUnit"
}
#endregion

function Get-CurrentWeather {
  param (
    $location,
    $unit
  )
     
  Write-Host "Getting the weather for $location in $unit"

  "The weather for Montreal is 15°C"
}

#region Function JSON
$functionsJSON = @"
{
    "name": "Get-CurrentWeather",
    "description": "Gets the current weather for a location",
    "parameters": {
      "type": "object",
      "properties": {
        "location": {
          "type": "string",
          "description": "The location to get the weather for"
        },
        "unit": {
          "type": "string",
          "description": "The unit to get the weather in",
          "enum": [
            "celsius",
            "fahrenheit"
          ]
        }
      },
      "required": [
        "location",
        "unit"
      ]
    }
  }
"@
#endregion

#region Function Tool
$functionTool = @(
  @{
    type     = 'function'
    function = $functionsJSON | ConvertFrom-Json -Depth 15 -AsHashtable
  }
)
#endregion

#region Messages and Completion Options
$messages = @()

$completionOptions = @{
  MaxTokens        = 400
  Temperature      = 1
  FrequencyPenalty = 0.0
  PresencePenalty  = 0.0
  TopP             = 0.95
  Model            = 'gpt-4o'
  Tools            = $functionTool
}
#endregion

#region System Prompt
$systemPrompt = @"
You are a hiking enthusiast who helps people discover fun hikes in their area. You are upbeat and friendly.
A good weather is important for a good hike. Only make recommendations if the weather is good or if people insist.
You introduce yourself when first saying hello. When helping people out, you always ask them
for this information to inform the hiking recommendation you provide:

1. Where they are located
2. What hiking intensity they are looking for

You will then provide three suggestions for nearby hikes that vary in length after you get that information.
You will also share an interesting fact about the local nature on the hikes when making a recommendation.
Please proceed with recommendations without confirmation, regardless of the weather.
"@
$messages += New-ChatRequestSystemMessage $systemPrompt
#endregion

#region User Greeting
$userGreeting = "Hi!"
$messages += New-ChatRequestUserMessage $userGreeting

Write-Host -NoNewline -ForegroundColor Cyan "User >>> "
Write-Host $userGreeting
#endregion

#region Invoke-OAIChatCompletion
$response = Invoke-OAIChatCompletion -Messages $messages @completionOptions

Write-Host -NoNewline -ForegroundColor Cyan "Assistant >>> "
Write-Host $response.Choices[0].Message.Content
#endregion

#region Hike Request
$hikeRequest = @"
Is the weather is good today for a hike?
If yes, I live in the greater Montreal area and would like an easy hike. I don't mind driving a bit to get there.
I don't want the hike to be over 10 miles round trip. I'd consider a point-to-point hike.
I want the hike to be as isolated as possible. I don't want to see many people.
I would like it to be as bug free as possible.
"@

$messages += New-ChatRequestUserMessage $hikeRequest

Write-Host -NoNewline -ForegroundColor Cyan "User >>> "
Write-Host $hikeRequest
#endregion

#region Invoke-OAIChatCompletion with Tool Calls
$response = Invoke-OAIChatCompletion -Messages $messages @completionOptions

$responseMessage = $response.Choices[0].Message
$messages += $responseMessage | ConvertTo-Json -Depth 10 | ConvertFrom-Json -AsHashtable

$toolCalls = $responseMessage.tool_calls

if ($toolCalls) {
  $toolCallId = $toolCalls.id
  $toolFunctionName = $toolCalls.function.name
  $toolFunctionArgs = $toolCalls.function.arguments | ConvertFrom-Json -AsHashtable

  if ($toolFunctionName) {
    $result = & $toolFunctionName @toolFunctionArgs
       
    Write-Host -NoNewline -ForegroundColor Cyan "Function >>> "
    Write-Host $result

    $messages += New-ChatRequestToolMessage $toolCallId $toolFunctionName $result
  }

  $response = Invoke-OAIChatCompletion -Messages $messages @completionOptions
}
#endregion

#region Assistant Response
$assistantResponse = $response.Choices[0].Message

Write-Host -NoNewline -ForegroundColor Cyan "Assistant >>> "
Write-Host $assistantResponse.Content
#endregion