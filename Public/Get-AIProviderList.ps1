<#
.SYNOPSIS
Retrieves the list of AI providers.

.DESCRIPTION
The Get-AIProviderList function returns a list of AI providers stored in the $script:ProviderList variable. 
This function does not take any parameters and simply returns the list when called.

.EXAMPLES
Get-AIProviderList

This command retrieves and displays the list of AI providers.

.NOTES

#>

function Get-AIProviderList {
    [CmdletBinding()]
    param (
        
    )
    
    begin {
        
    }
    
    process {
        return $script:ProviderList
    }
    
    end {
        
    }
}