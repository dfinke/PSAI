<#
.SYNOPSIS
Initializes and registers the Tavily AI Tool.

.DESCRIPTION
The New-TavilyAITool function initializes the Tavily AI Tool and registers the Invoke-WebSearch tool.

.EXAMPLE
PS C:\> New-TavilyAITool
This command initializes and registers the Tavily AI Tool.

.NOTES
This function writes a verbose message when it is loaded.
#>
function New-TavilyAITool {
    Write-Verbose "New-TavilyAITool loaded"

    Register-Tool Invoke-WebSearch
}

<#
.SYNOPSIS
Performs a web search using the Tavily Search API.

.DESCRIPTION
The Invoke-WebSearch function sends a search query to the Tavily Search API and retrieves the search results. 
The function requires an API key to be set in the environment variable `$env:TAVILY_API_KEY`.

.PARAMETER query
The search query string to be sent to the Tavily Search API.

.EXAMPLE
Invoke-WebSearch -query "PowerShell scripting"
This example sends the search query "PowerShell scripting" to the Tavily Search API and returns the search results.

.NOTES
To use this function, you must set the `$env:TAVILY_API_KEY` environment variable with your Tavily API key. 
You can obtain an API key from https://app.tavily.com/.

#>
function Global:Invoke-WebSearch {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$query
    )

    if (-not $env:TAVILY_API_KEY) {
        throw "To use Tavily Search, set your `$env:TAVILY_API_KEY (get it from here https://app.tavily.com/)"
    }

    $baseUrl = 'https://api.tavily.com'

    $parameters = @{
        api_key             = $env:TAVILY_API_KEY
        query               = $query
        search_depth        = "basic"
        include_answer      = $false
        include_images      = $false
        include_raw_content = $false
        max_results         = 5
        include_domains     = @()
        exclude_domains     = @()
    } | ConvertTo-Json

    $response = Invoke-RestMethod -Method Post -Uri "$baseUrl/search" -Body $parameters -ContentType 'application/json'
    
    $response.results
}
