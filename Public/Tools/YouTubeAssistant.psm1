<#
.SYNOPSIS
PowerShell module for interacting with YouTube API and retrieving video information.

.DESCRIPTION
This module provides functions to search YouTube for videos and retrieve video transcripts.
It requires a valid Google API key to be set in the environment variable 'GoogleApiKey'.

.FUNCTION Search-YouTube
.SYNOPSIS
Searches YouTube for videos matching a specified query.

.DESCRIPTION
Performs a search on YouTube using the provided query string and returns video information
including title, description, channel information, and video URLs.

.PARAMETER Query
The search query to find videos on YouTube.

.PARAMETER MaxResults
The maximum number of results to return. Default is 5.

.PARAMETER OrderBy
How to order the search results. Valid options are 'date', 'rating', 'relevance', 'title', and 'viewCount'. Default is 'relevance'.

.PARAMETER IncludeChannelInfo
When specified, includes additional channel information such as subscriber count and view count.

.EXAMPLE
Search-YouTube -Query "PowerShell tutorials" -MaxResults 10
# Returns the top 10 PowerShell tutorial videos on YouTube.

.EXAMPLE
Search-YouTube -Query "Azure DevOps" -OrderBy viewCount -IncludeChannelInfo
# Returns the 5 most viewed Azure DevOps videos with additional channel information.

.FUNCTION Get-YouTubeTranscript
.SYNOPSIS
Retrieves the transcript for a YouTube video.

.DESCRIPTION
Gets the transcript for a specified YouTube video using the video ID.

.PARAMETER videoId
The YouTube video ID for which to retrieve the transcript.

.EXAMPLE
Get-YouTubeTranscript -videoId "dQw4w9WgXcQ"
# Returns the transcript for the specified YouTube video.

.NOTES
Requires an external 'Get-Transcript' function (not defined in this module) to retrieve the actual transcript data.
#>
function Search-YouTube {
    [CmdletBinding()]
    param(
        [string]$Query,
        [int]$MaxResults = 5,
        [ValidateSet('date', 'rating', 'relevance', 'title', 'viewCount')]
        [string]$OrderBy = 'relevance',
        [switch]$IncludeChannelInfo
    )
        
    begin {
        $ApiKey = $env:GoogleApiKey
        if (-not $ApiKey) {
            throw "YouTube API key is required. Set the GoogleApiKey environment variable or provide the ApiKey parameter."
        }
        
        # Encode the query string for URL
        $encodedQuery = [System.Uri]::EscapeDataString($Query)
        
        # Build the API URL
        $baseUri = "https://youtube.googleapis.com/youtube/v3/search"
        $queryParams = @(
            "part=snippet",
            "q=$encodedQuery",
            "maxResults=$MaxResults",
            "type=video",
            "order=$OrderBy",
            "key=$ApiKey"
        )
        $uri = "$baseUri`?$($queryParams -join '&')"
    }
    
    process {
        try {
            # Make the API request
            $response = Invoke-RestMethod -Uri $uri -Method Get -ErrorAction Stop
            
            # Process the results
            $videos = $response.items | ForEach-Object {
                $videoId = $_.id.videoId
                $video = [PSCustomObject]@{
                    Title        = $_.snippet.title
                    Description  = $_.snippet.description
                    PublishedAt  = [DateTime]$_.snippet.publishedAt
                    ChannelTitle = $_.snippet.channelTitle
                    ChannelId    = $_.snippet.channelId
                    ThumbnailUrl = $_.snippet.thumbnails.high.url
                    VideoId      = $videoId
                    VideoUrl     = "https://www.youtube.com/watch?v=$videoId"
                }
                
                # Get additional video details if requested
                if ($IncludeChannelInfo) {
                    $channelUri = "https://youtube.googleapis.com/youtube/v3/channels?part=snippet,statistics&id=$($_.snippet.channelId)&key=$ApiKey"
                    $channelInfo = Invoke-RestMethod -Uri $channelUri -Method Get
                    
                    if ($channelInfo.items.Count -gt 0) {
                        $video | Add-Member -NotePropertyName ChannelSubscriberCount -NotePropertyValue $channelInfo.items[0].statistics.subscriberCount
                        $video | Add-Member -NotePropertyName ChannelViewCount -NotePropertyValue $channelInfo.items[0].statistics.viewCount
                    }
                }
                
                return $video
            }
            
            return $videos
        }
        catch {
            Write-Error "Failed to search YouTube: $_"
        }
    }
}

function Get-YouTubeTranscript {
    <#
        .SYNOPSIS
        Retrieves the transcript for a YouTube video.
        .DESCRIPTION
        Gets the transcript for a specified YouTube video using the video ID.
        .PARAMETER videoId
        The YouTube video ID for which to retrieve the transcript.
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

function Invoke-YouTubeAIAssistant {
    param(
        [Parameter(Mandatory = $true)]
        $query,
        [Switch]$ShowToolCalls
    )

    $instructions = @"
Date: $(Get-Date)
- ** Mist include all video YouTube links **
- Read transcripts
- Include title
- Include date published
"@

    $agent = New-Agent -Tools Get-YouTubeTranscript, Search-YouTube -Instructions $instructions -ShowToolCalls:$ShowToolCalls
    $agent | Get-AgentResponse $query
}

