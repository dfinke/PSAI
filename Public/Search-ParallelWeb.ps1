function Search-ParallelWeb {
    <#
    .SYNOPSIS
    Searches the web through the anonymous Parallel Search MCP.

    .DESCRIPTION
    Returns source URLs and relevant excerpts as text for an agent to use directly.
    No Parallel API key is required. The free endpoint is intended for light use
    and has rate limits. Model inference is separate.

    .PARAMETER Objective
    A specific description of the information to find, including freshness or source preferences.

    .PARAMETER SearchQueries
    One or more related keyword queries for the objective, usually three to six words each.

    .PARAMETER TimeoutSec
    Timeout in seconds for each MCP HTTP request. Defaults to 60.

    .EXAMPLE
    Search-ParallelWeb -Objective 'Find the current PowerShell release' -SearchQueries 'PowerShell latest stable release'
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Objective,
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string[]]$SearchQueries,
        [ValidateRange(1, 300)]
        [int]$TimeoutSec = 60
    )

    Invoke-ParallelMcp -ToolName 'web_search' -TimeoutSec $TimeoutSec -Arguments @{
        objective = $Objective
        search_queries = @($SearchQueries)
    }
}
