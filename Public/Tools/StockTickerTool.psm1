<#
.SYNOPSIS
Creates a new StockTickerTool instance.

.DESCRIPTION
The New-StockTickerTool function initializes a new instance of the StockTickerTool. 
It checks for the presence of the 'financialmodelingprep' environment variable, which should contain your API key. 
If the environment variable is not set, the function throws an error.

.PARAMETER None
This function does not take any parameters.

.EXAMPLE
PS> New-StockTickerTool
Initializes the StockTickerTool and registers the necessary tools.

.NOTES
Ensure that the 'financialmodelingprep' environment variable is set to your API key before calling this function. 
You can obtain an API key from: https://intelligence.financialmodelingprep.com/developer/docs

#>
function New-StockTickerTool {
    [CmdletBinding()]
    param()
    
    if ($null -eq $env:financialmodelingprep) {
        throw "Please set the environment variable 'financialmodelingprep' to your API key. Get it here: https://intelligence.financialmodelingprep.com/developer/docs"
    }

    Write-Verbose "New-StockTickerTool was called"
    Write-Verbose "Registering tools for StockTickerTool"
    
    Register-Tool -FunctionName Get-StockInfo
}

<#
.SYNOPSIS
Retrieves stock information for a given symbol.

.DESCRIPTION
The Get-StockInfo function fetches stock information from the Financial Modeling Prep API for a specified stock symbol. 
It uses the API key stored in the environment variable 'financialmodelingprep'.

.PARAMETER symbol
The stock symbol for which to retrieve information.

.EXAMPLE
PS C:\> Get-StockInfo -symbol "AAPL"
This command retrieves stock information for Apple Inc.

.NOTES
Make sure to set the environment variable 'financialmodelingprep' with your API key before using this function.

#>
function Get-StockInfo {
    [CmdletBinding()]
    param(
        [string]$symbol
    )
    
    try {
        $url = "https://financialmodelingprep.com/api/v3/quote/$($symbol)?apikey=$($env:financialmodelingprep)"

        $response = Invoke-RestMethod $url
        $response | Out-String
    }
    catch {
        Write-Error  "Error: $_"
    }
}