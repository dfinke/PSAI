$script:messages = @()

$PrintResponse = { 
    [CmdletBinding()]
    param(
        $prompt
    )

    if ($prompt -is [string]) {
        $script:messages += @(New-ChatRequestUserMessage $prompt)
    }
    elseif ($prompt -is [array]) {
        $script:messages += $prompt
    }
    else {
        throw "Invalid prompt type"
    }

    Write-Verbose ("{0} {1}" -f (Get-LogDate), ($this | dumpJson -Depth 15))
    $llmModel = $this.LLM.config.model

    $response = $null
    do {
        $response = Invoke-OAIChatCompletion -Messages $script:messages -Tools $this.Tools -Model $llmModel
        $script:messages += @($response.choices[0].message | ConvertTo-OAIMessage)
    
        $script:messages += @(Invoke-OAIFunctionCall $response -Verbose:$this.ShowToolCalls)
    } until ($response.choices.finish_reason -eq "stop")

    return $response.choices[0].message.content
}

$InteractiveCLI = {
    [CmdletBinding()]
    param(
        $Message,
        $User = 'User',
        $Emoji = '😎',
        # Default reader uses Read-Host so we can display a prompt string
        $InputReader = { param($prompt) Read-Host -Prompt $prompt }
    )

    $agentResponse = $null
    if ($Message) {
        $agentResponse = $this.PrintResponse($Message)
        $agentResponse | Out-Host
    }

    while ($true) {
        $promptText = "${Emoji} ${User}"
        $message = & $InputReader $promptText

        if ([string]::IsNullOrEmpty($message)) {
            Out-BoxedText -Text "Copied to clipboard." -Title "Information" -BoxColor "Green" | Out-Host
            Set-Clipboard -Value $agentResponse
            break            
        }
        elseif ($message.StartsWith("/")) {
            switch ($message.ToLower()) {
                "/clear" { Clear-Host }
                "/rewind" {
                    $lastUserIndex = -1
                    for ($i = $script:messages.Count - 1; $i -ge 0; $i--) {
                        if ($script:messages[$i].role -eq 'user') {
                            $lastUserIndex = $i
                            break
                        }
                    }
                    if ($lastUserIndex -ge 0) {
                        $script:messages = $script:messages[0..($lastUserIndex - 1)]
                        Write-Host "Rewound."
                    }
                    else {
                        Write-Host "No user messages to rewind."
                    }
                }
                default { Write-Host "Unknown command: $message" }
            }
        }
        else {
            $agentResponse = $this.PrintResponse($message)
            
            $formatParams = @{
                Text     = $agentResponse
                Title    = "Agent Response"
                BoxColor = "Blue"
            }
            Out-BoxedText @formatParams | Out-Host

            $nextStepsParams = @{
                Text     = "Follow up, Enter to copy & quit, Ctrl+C to quit."
                Title    = "Next Steps"
                BoxColor = "Cyan"
            }
            
            Out-BoxedText @nextStepsParams | Out-Host
        }
    }
}

$GetAgentMessages = {
    [CmdletBinding()]
    param()

    $script:messages
}

$PrettyPrintMessages = {
    [CmdletBinding()]
    param()

    $roleToColor = @{
        'user'      = 'green'
        'system'    = 'red'
        'assistant' = 'blue'
        'function'  = 'magenta'
        'tool'      = 'cyan'
    }

    foreach ($message in $this.GetMessages()) {
        $role = $message.role
        $content = $message.content
        
        Write-Host "$($role): $content" -ForegroundColor $roleToColor[$role]
    }
}

<#
.SYNOPSIS
Creates a new agent with specified tools, instructions, and other properties.

.DESCRIPTION
The New-Agent function initializes a new agent object with the provided tools, instructions, language model, name, and description. It also sets up various methods for the agent, such as printing responses and interacting via CLI.

.PARAMETER Instructions
A list of instructions added to the system prompt.

.PARAMETER Tools
A collection of tools that the agent can use to assist the user.

.PARAMETER LLM
The language model to be used by the agent. Defaults to a new OpenAI chat instance.

.PARAMETER Name
The name of the agent.

.PARAMETER Description
A description of the agent.

.PARAMETER ShowToolCalls
A switch to indicate whether tool calls should be shown.

.EXAMPLE
PS> New-Agent -Instructions "Follow the guidelines" -Tools $tools -Name "HelperAgent" -Description "An agent to assist with tasks" -ShowToolCalls

.NOTES
The function adds several methods to the agent object, including PrintResponse, InteractiveCLI, GetMessages, and PrettyPrintMessages.
#>
function New-Agent {
    [CmdletBinding()]
    param(
        # List of instructions added to the system prompt in
        $Instructions,
        $Tools,
        $LLM = (New-OpenAIChat),
        $Name,
        $Description,
        [Switch]$ShowToolCalls
    )
 
    $script:messages = @()

    if ($null -ne $Tools) {
        $ReadyTools = @()
        foreach ($t in $Tools) {
            if ($t.GetType().Name -eq "string") {
                $ReadyTools += Register-Tool $t
            }
            else {
                $ReadyTools += $t
            }
        }
    }
    
    #Write-Verbose "[$((Get-Date).ToString("yyMMdd:hhmmss"))] New-Agent was called"
    Write-Verbose ("{0} New-Agent was called" -f (Get-LogDate))
    Write-Verbose ("{0} Tools: {1}" -f (Get-LogDate), (ConvertTo-Json -Depth 10 -InputObject $Tools))

    $agent = [PSCustomObject]@{
        Tools         = $ReadyTools
        ShowToolCalls = $ShowToolCalls
        LLM           = $LLM
    }

    $script:messages += @(New-ChatRequestSystemMessage "You are a helpful agent. If you are configured with tools, you can use them to assist the user. They are also considered skills")

    if ($Instructions) {
        # $agent['Instructions'] = $Instructions
        $agent | Add-Member -MemberType NoteProperty -Name Instructions -Value $Instructions -Force
        $script:messages += @(New-ChatRequestSystemMessage $Instructions)
    }

    if ($Name) {
        $script:messages += @(New-ChatRequestSystemMessage "Agent name: $Name")
    }

    if ($Description) {
        $script:messages += @(New-ChatRequestSystemMessage "Agent description: $Description")
    }

    $agent.psobject.TypeNames.Clear()
    $agent.psobject.TypeNames.Insert(0, 'PSAIAgent')

    $agent | 
    Add-Member -MemberType ScriptMethod -Name "PrintResponse" -Force -Value $PrintResponse -PassThru |
    Add-Member -MemberType ScriptMethod -Name "InteractiveCLI" -Force -Value $InteractiveCLI -PassThru |
    Add-Member -MemberType ScriptMethod -Name "GetMessages" -Force -Value $GetAgentMessages -PassThru |
    Add-Member -MemberType ScriptMethod -Name "PrettyPrintMessages" -Force -Value $PrettyPrintMessages -PassThru
}

function Get-LogDate {
    [CmdletBinding()]
    param()

    '[{0}]' -f (Get-Date).ToString("yyMMdd:hhmmss")
}