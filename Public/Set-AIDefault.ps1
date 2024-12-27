<#
.SYNOPSIS
Sets the default AI provider and model using a slug.

.DESCRIPTION
The Set-AIDefault function sets the default AI provider and model using a slug in the format 'provider:model'. 
It ensures that both the provider and model exist before setting them as default.

.PARAMETER Slug
The slug containing the provider and model in the format 'provider:model'. This parameter is mandatory.

.EXAMPLE
Set-AIDefault -Slug "openai:gpt-4o"
This command sets "OpenAI" as the default provider and "gpt-4o" as the default model.

.NOTES
- This function requires that the provider and model exist in the list.
- If the provider or model is not found, an error is thrown.
#>

Class SlugNames : System.Management.Automation.IValidateSetValuesGenerator {
    [String[]] GetValidValues() {
        $allProviders = Get-AIProvider -all
        $slugNames = foreach ($entry in $allProviders.GetEnumerator()) {
            $providerName = $entry.key
            $provider = $entry.value
            $models = $provider.AIModels.keys
            foreach ($model in $models) {
                "{0}:{1}" -f $providerName, $model
            }
        }

        return $slugNames
    }
}

function Set-AIDefault {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateSet([SlugNames])]
        $Slug
    )
    begin {
        $parts = $Slug -split ':'
        if ($parts.Length -ne 2) {
            throw "Invalid slug format. Please use 'provider:model'."
        }
        $ProviderName = $parts[0]
        $ModelName = $parts[1]

        if (!$(Get-AIProvider $ProviderName)) {
            throw "Provider $ProviderName not found in the list. Please add a provider first."
        }
    }
    process {
        Set-AIDefaultProvider -ProviderName $ProviderName
        Set-AIDefaultModel -ProviderName $ProviderName -ModelName $ModelName
    }
    end {}
}