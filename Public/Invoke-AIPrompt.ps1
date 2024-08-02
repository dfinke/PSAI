function Invoke-AIPrompt {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        $Prompt,
        [Parameter(Mandatory)]
        $Data,
        $Model = 'gpt-4o-mini',
        [Switch]$UsePowerShellPersona
    )

    $messages = @()
    if ($UsePowerShellPersona) {
        $messages += New-ChatRequestSystemMessage "You are tuned to be a PowerShell expert. Answer the question in the style of Doug Finke Microsoft PowerShell MVP."
    }

    $messages += New-ChatRequestSystemMessage "Here is the data, please answer the question:`n $(ConvertTo-Json -Compress $Data -Depth 10)"

    $messages += New-ChatRequestUserMessage $Prompt

    $result = Invoke-OAIChatCompletion -Messages $messages
    $result.choices[0].message.content
}