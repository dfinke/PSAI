<#
.SYNOPSIS
Retrieves AI provider information from the provider list.

.DESCRIPTION
The Get-AIProvider function retrieves information about AI providers from a predefined list. 
It can return all providers, a specific provider by name, or the default provider.

.PARAMETER Name
Specifies the name of the AI provider to retrieve. If this parameter is not provided, the default provider is returned.

.PARAMETER All
If specified, retrieves all AI providers in the list.

.EXAMPLE
Get-AIProvider -Name "OpenAI"
Retrieves information about the AI provider named "OpenAI".

.EXAMPLE
Get-AIProvider -All
Retrieves information about all AI providers in the list.

.EXAMPLE
Get-AIProvider
Retrieves information about the default AI provider.

.NOTES
Before running this command, ensure that the provider list is created using the New-AIProviderList command.
If no provider list is found, an error is thrown.

#>
function Get-AIProvider {
    [CmdletBinding()]
    param (
        [string] $Name,
        [switch] $All
    )
    
    begin {
        $ProviderList = (Get-AIProviderList) 
        if (-not $ProviderList) {
            (Write-Error "No provider list found. Create a new list using New-AIProviderList before running this command" -ErrorAction Stop)
        }
    }
    
    process {
        if  ($All) { $script:ProviderList.Providers }
        elseif ($Name) { $script:ProviderList.Get($Name) }
        else { $script:ProviderList.GetDefault() }  
    }
    
    end {
        
    }
}