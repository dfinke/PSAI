<#
.SYNOPSIS
    Imports AI providers from environment variables.

.DESCRIPTION
    This cmdlet arttempts to import AI providers from environment variables and adds them to the provider list.

    This function should only run if the user did not import AI Providers before running other commands.

    If no environment variables are found for AI providers, a warning is displayed.

    Get-AIProviderList should be run after this command to ensure that the providers are imported and handle further actions


.NOTES
    This is a Private function and should not be called directly by the user.

.LINK
    Provides links to related cmdlets or online documentation.
#>


function New-ProviderListFromEnv {
    [CmdletBinding()]
    param (
        [switch]$Force
    )
    $AIKeyInfo = Get-AIKeyInfo -AsHashTable

    $AIKeyInfo.Keys | ForEach-Object {
        $key = $_
        $ApiKey = try {
            Get-Item env:$($AIKeyInfo[$key]['EnvKeyName']) -ErrorAction Stop | ConvertTo-SecureString -AsPlainText 
        }
        catch {
            $SecretModuleExists = Get-Command Get-Secret -Verbose:$false
            if ($SecretModuleExists) {try {Get-Secret -Name $($AIKeyInfo[$key]['SecretName']) -ErrorAction Stop -Verbose:$false} catch {}}
        } 
        $params = @{
            Provider = $key
        }
        if ($ApiKey) {
            $params['ApiKey'] = $ApiKey
            Import-AIProvider @params -Force:$Force
        }
        else {
            Write-Verbose "No ApiKey found for $_ - i you want to autoload this provider, configure an EnvVarName name and envrionment variable or secret name with Set-AIKeyInfo"
        }
        
    }

    # if ($null -ne $env:OpenAIKey) {
    #     $params = @{
    #         Provider = 'OpenAI'
    #         ApiKey   = $env:OpenAIKey | ConvertTo-SecureString -AsPlainText -Force
    #     }
    #     Import-AIProvider @params -Force:$Force
    #     Write-verbose "Imported OpenAI provider"
    # }
    # if ($null -ne $script:AzOAISecrets['apiKEY'] -and $null -ne $script:AzOAISecrets['deploymentName'] -and $null -ne $script:AzOAISecrets['apiURI'] -and  $null -ne $script:AzOAISecrets['apiVersion']) {
    #     $params = @{
    #         Provider   = 'AzureOpenAI'
    #         ApiKey     = $script:AzOAISecrets.apiKEY | ConvertTo-SecureString -AsPlainText -Force
    #         ModelNames = $script:AzOAISecrets.deploymentName
    #         BaseUri    = $script:AzOAISecrets.apiURI
    #     }
    #     Import-AIProvider @params -Force:$Force
    #     Write-Verbose "Imported AzureOpenAI provider"

    # }
    # if (-Not $script:ProviderList) {
    #     Write-Verbose "No environment variables found for AI Providers"
    # }
    
}