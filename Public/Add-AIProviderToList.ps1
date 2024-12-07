<#
.SYNOPSIS
    Adds an AI provider to the provider list.

.DESCRIPTION
    The Add-AIProviderToList function adds a new AI provider to the existing provider list. 
    If the provider list does not exist, it creates a new one. 
    If a provider with the same name already exists, it will either overwrite it if the -Force switch is used, 
    or throw an error if -Force is not specified.

.PARAMETER Provider
    The AI provider object to be added to the list. This should be a PSCustomObject.

.PARAMETER Default
    A switch parameter that, if specified, marks the provider as the default provider.

.PARAMETER Force
    A switch parameter that, if specified, forces the addition of the provider by removing any existing provider with the same name.

.EXAMPLE
    $provider = [PSCustomObject]@{ Name = "NewProvider"; APIKey = "12345" }
    Add-AIProviderToList -Provider $provider

.EXAMPLE
    $provider = [PSCustomObject]@{ Name = "NewProvider"; APIKey = "12345" }
    Add-AIProviderToList -Provider $provider -Default

.EXAMPLE
    $provider = [PSCustomObject]@{ Name = "NewProvider"; APIKey = "12345" }
    Add-AIProviderToList -Provider $provider -Force

.NOTES
    This cmdlet is mainly used when importing a new AI Provider from a file or when creating a new Provider in the shell.
#>

function Add-AIProviderToList {
    [CmdletBinding()]
    param (
        [PSCustomObject] $Provider,
        [switch] $Default,
        [switch] $Force
    )
    
    begin {
        if (-not $script:ProviderList) {
            New-AIProviderList
        }
    }
    
    process {
        if ($ProviderList.Providers.ContainsKey($Provider.Name)) {
            $null = $Force ? 
                ($ProviderList.Remove($Provider.Name)) :
                (Write-Error "Provider with name $($Provider.Name) already exists in the list. Use -Force to overwrite" -ErrorAction Stop)
        }

        [void]$ProviderList.Add($Provider, $Default)
    }
    
    end {
        
    }
}