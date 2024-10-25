function Invoke-YouTubeAIAssistant {
    param(
        [Parameter(Mandatory = $true)]
        $query
    )

    #$agent | Get-AgentResponse 'top 10 points max 14 words  - https://youtu.be/MxbLovkvOC0'
    # Invoke-YouTubeAIAssistant 'top 10 points max 14 words  - https://youtu.be/MxbLovkvOC0' | glow

    $instructions = "Include YouTube Title"

    $agent = New-Agent -Tools (New-YouTubeTool) -Instructions $instructions
    $agent | Get-AgentResponse $query
}

function Get-YouTubeTop10 {
    param(
        [Parameter(Mandatory = $true)]
        $YouTubeLink
    )
    
    Invoke-YouTubeAIAssistant -query "top 10 points max 14 words $YouTubeLink"
}