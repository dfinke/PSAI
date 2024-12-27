function Get-OAIAssistantResponse {
    [CmdletBinding()]
    param (
        [string]$Prompt,
        [Parameter(ValueFromPipeline)]
        $Assistant
    )
    

    $query = New-OAIThreadQuery -Assistant $assistant -UserInput $Prompt
    $null = Wait-OAIOnRun -Run $query.Run -Thread $query.Thread
    $message = Get-OAIMessage -ThreadId $query.Thread.id
    $message.data?[0].content?[0].text.value

}