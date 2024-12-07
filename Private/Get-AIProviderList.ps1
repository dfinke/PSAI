<#
.SYNOPSIS
Retrieves the list of AI providers.

.DESCRIPTION
The Get-AIProviderList function returns a list of AI providers stored in the $script:ProviderList variable. 
This function does not take any parameters and simply returns the list when called.

If no Providers are found, the function will attempt to import providers from environment variables. If that does not work, an error is thrown.

.EXAMPLES
Get-AIProviderList

This command retrieves and displays the list of AI providers.

.NOTES

#>

function Get-AIProviderList {
    [CmdletBinding()]
    param (
        [switch]$Strict
    )
    
    begin {


    }
    
    process {
        # If the user has not imported any providers yet, try to import providers from environment variables
        if ($null -eq $script:ProviderList -and !$Strict) {
            New-ProviderListFromEnv
            if ($null -eq $script:ProviderList) {
                Write-Error "No AI Providers found. You must either import AIProviders or set environment variables for AI Providers before using the PSAI module cmdlets" -ErrorAction Stop
                return
            }
        }
        return $script:ProviderList
    }
    
    end {
        
    }
}