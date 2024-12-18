<#
.SYNOPSIS
Sets the default AI provider.

.DESCRIPTION
The Set-AIDefaultProvider function sets the default AI provider from the list of available providers. 
It ensures that the specified provider exists in the list before setting it as the default.

.PARAMETER ProviderName
The name of the AI provider to set as the default. This parameter is mandatory.

.EXAMPLE
Set-AIDefaultProvider -ProviderName "OpenAI"
This command sets "OpenAI" as the default AI provider.

.NOTES
- This function requires that the provider list is not empty and that the specified provider exists in the list.
- If the provider list is empty or the specified provider is not found, an error is thrown.

#>
function Set-AIDefaultProvider {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]
        $ProviderName
    )
    begin {
        if (!$(Get-AIProviderList)){
            throw "No Providers in the list. Please add a provider first."
        } 
        if (!$(Get-AIProvider $ProviderName)){
            throw "Provider $ProviderName not found in the list. Please add a provider first."        }
    }
    process {
        $script:ProviderList.SetDefault($ProviderName)
    }
    end {}
}