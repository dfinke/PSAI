function Get-ParallelWebContent {
    <#
    .SYNOPSIS
    Fetches relevant excerpts from web pages through the anonymous Parallel Search MCP.

    .DESCRIPTION
    Returns excerpts as text. Use when a specific page is requested or search
    excerpts are insufficient. No Parallel API key is required; free-tier rate
    limits apply. Partial fetch failures remain in the returned tool text.

    .PARAMETER Urls
    One to twenty HTTP or HTTPS URLs sharing the same objective.

    .PARAMETER Objective
    Information to extract, up to 200 characters. Omit to use the server default.

    .PARAMETER TimeoutSec
    Timeout in seconds for each MCP HTTP request. Defaults to 60.

    .EXAMPLE
    Get-ParallelWebContent -Urls 'https://learn.microsoft.com/powershell/' -Objective 'What is PowerShell?'
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateCount(1, 20)]
        [ValidateScript({ [uri]::IsWellFormedUriString($_, [UriKind]::Absolute) -and ([uri]$_).Scheme -in 'http', 'https' })]
        [string[]]$Urls,
        [ValidateLength(0, 200)]
        [string]$Objective,
        [ValidateRange(1, 300)]
        [int]$TimeoutSec = 60
    )

    $arguments = @{ urls = @($Urls) }
    if ($Objective) { $arguments['objective'] = $Objective }
    Invoke-ParallelMcp -ToolName 'web_fetch' -Arguments $arguments -TimeoutSec $TimeoutSec
}
