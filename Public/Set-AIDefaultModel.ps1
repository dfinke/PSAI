<#
.SYNOPSIS
Sets the default AI model for a given provider.

.DESCRIPTION
The Set-AIDefaultModel function sets the default AI model for a specified provider. 
The provider can be specified either as a PSCustomObject or by its name. 
The function ensures that the provider exists before setting the default model.

.PARAMETER ProviderName
The name of the provider as a string. This parameter is mandatory.

.PARAMETER ModelName
The name of the model to set as the default for the provider. This parameter is mandatory.

.EXAMPLE
Set-AIDefaultModel -ProviderName "OpenAI" -ModelName "gpt-4o"

Sets the default model to "gpt-4o" for the provider named "OpenAI".

.NOTES
This function requires the Get-AIProvider function to retrieve the provider object when the provider name is specified.
#>
function Set-AIDefaultModel {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ParameterSetName = 'ProviderName')]
        [string] $ProviderName,
        [Parameter (Mandatory)]
        [string] $ModelName
    )
    
    begin {
        $Provider = Get-AIProvider -Name $ProviderName
        if (!$Provider) {
            Write-Error "Provider found in the ProviderList. Please supply an existing Provider or ProviderName" -ErrorAction Stop
        }

    }
    
    process {
        $Provider.SetDefaultModel($ModelName)
    }
    
    end {
        
    }
}