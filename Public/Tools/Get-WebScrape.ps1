<#
.SYNOPSIS
Retrieves web content by scraping a specified URL.

.DESCRIPTION
The Get-WebScrape function is designed to fetch and scrape web content from a given URL. This can be useful for extracting information from web pages for further processing or analysis.

.PARAMETER Url
Specifies the URL of the web page to scrape.

.EXAMPLE
PS> Get-WebScrape -Url "https://example.com"

#>
function Get-WebScrape {
    param (
        [string]$Uri,
        $filter
    )

    try {$Res = Invoke-WebRequest -Uri $Uri
    [regex]::Replace($Res.RawContent, '<[^>]+>', '') -replace '^\s*$(\n|\r\n)', '' -replace '\s{2,}', ' '
    }
    catch { Write-Output $($Error[0] | Out-String) }
}