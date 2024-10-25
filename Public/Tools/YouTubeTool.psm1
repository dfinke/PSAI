function New-YouTubeTool {
    [CmdletBinding()]
    param()

    # gmo -list psyt

    if(-not (Get-Module "PSYT" -ListAvailable)) {
        throw "PSYT module is not installed. Please install it using 'Install-Module PSYT'"
    }

    Write-Verbose "New-YouTubeTool was called"
    Write-Verbose "Registering tools for YouTubeTool"

    Register-Tool -FunctionName Get-YouTubeTranscript
}

function Get-YouTubeTranscript {
    <#
        .FunctionDescription
        Get the transcript of a YouTube video.        

        .ParameterDescription videoId
        The videoId of the YouTube video. Wrap the value to the param in single quotes "'". Get-Transcript '-VkYSLRk2Bw' 
    #>
    [CmdletBinding()]
    param(
        [string]$videoId
    )

    $transcript = Get-Transcript $videoId
    
    if($null -eq $transcript) {
        return "Transcript not found for videoId: $videoId"
    }

    return $transcript
}