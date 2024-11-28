<#
.SYNOPSIS
Retrieves AI models from a specified provider or the default provider.

.DESCRIPTION
The Get-AIModel function retrieves AI models from a specified provider or the default provider. 
It allows filtering by provider name and model name, and can return all models if specified.

.PARAMETER ProviderName
The name of the AI provider from which to retrieve models. If not specified, models from the default provider are returned.

.PARAMETER ModelName
The name of the specific AI model to retrieve. If not specified, the default model from the provider is returned.

.PARAMETER All
A switch parameter that, if specified, retrieves all models from the provider.

.EXAMPLE
Get-AIModel -ProviderName "OpenAI" -ModelName "GPT-3"
Retrieves the "GPT-3" model from the "OpenAI" provider.

.EXAMPLE
Get-AIModel -All
Retrieves all models from the default provider.

.EXAMPLE
Get-AIModel -ProviderName "OpenAI" -All
Retrieves all models from the "OpenAI" provider.

.NOTES
This function requires the Get-AIProvider function to be defined and available in the session.
#>
function Get-AIModel {
    [CmdletBinding()]
    param (
        #[ValidateSet()]
        [string]$ProviderName,
        #[ValidateSet()]
        [string]$ModelName,
        [switch]$All
    )
    
    begin {
        
    }
    
    process {
        $providerParams = @{}
        if ($ProviderName) {
            $providerParams.Add('Name', $ProviderName)
        }
        if ($All) {
            $providerParams.Add('All', $true)
        }
        # If provider is not supplied, only return models from the default provider
        $ProviderObject = Get-AIProvider @providerParams
        $ProviderObject.ForEach{
            if ($All) {
                $_.Values.AIModels.Values
            } else {
                if ($ModelName.Length -gt 0) {
                    $_.GetModel($ModelName)
                } else {
                    $_.GetModel($ProviderObject.DefaultModel)
                }
            }
        }
    }
    
    end {
        
    }
}