# Using these classes to generate the valid values for the ValidateSet attribute
# BUT once the cmdlet has been run once, new providers are not added to the list
# class ProviderNames : System.Management.Automation.IValidateSetValuesGenerator {
#     [String[]] GetValidValues() {
#         return @((Get-AIProvider -All).Keys)
#     }
# }

# class ModelNames : System.Management.Automation.IValidateSetValuesGenerator {
#     [String[]] GetValidValues() {
#         return @((Get-AIProvider -All).Values.AIModels.Keys)
#     }
# }

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