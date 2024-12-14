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


function New-AIProviderListFromKeyInfo {
    [CmdletBinding()]
    param (
        [switch]$Force
    )
    $AIKeyInfo = Get-AIKeyInfo -AsHashTable

    $AIKeyInfo.Keys | ForEach-Object {
        $ProviderName = $_
        $EnvNeyName = $AIKeyInfo[$ProviderName]['EnvKeyName']
        $SecretName = $AIKeyInfo[$ProviderName]['SecretName']
        $ApiKey = try {
            if ($null -notmatch $EnvNeyName) {
            (Get-Item env:$EnvNeyName -ErrorAction Stop ).Value| ConvertTo-SecureString -AsPlainText
            }
        } catch {}
        if (!$ApiKey -and ($null -notmatch $SecretName)) {
                try {
                    $params = @{
                        Name = $SecretName
                        ErrorAction = 'Stop'
                        Verbose = $false
                    }
                    if ($AIKeyInfo[$ProviderName]['VaultName']) {
                        $params['Vault'] = $($AIKeyInfo[$ProviderName]['VaultName'])
                    }
                    else {
                        $params['Vault'] = Get-SecretVault | Where-Object {$_.IsDefault} | Select-Object -ExpandProperty Name
                    }
                    $ApiKey = Get-Secret @params
                } catch {}
        } 
        $params = @{
            Provider = $ProviderName
        }
        if ($null -notmatch $AIKeyInfo[$ProviderName]['BaseUri']){
            $params['BaseUri'] = $AIKeyInfo[$ProviderName]['BaseUri']
        }
        if ($null -notmatch $AIKeyInfo[$ProviderName]['ModelNames']){
            $params['ModelNames'] = $AIKeyInfo[$ProviderName]['ModelNames']
        }
        if ($null -notmatch $AIKeyInfo[$ProviderName]['Version']){
            $params['Version'] = $AIKeyInfo[$ProviderName]['Version']
        }
        if ($null -notmatch $AIKeyInfo[$ProviderName]['Default']){
            $params['Default'] = $true
        }
        if ($ApiKey) {
            $params['ApiKey'] = $ApiKey
            Import-AIProvider @params -Force:$Force
        }
        else {
            Write-Verbose "No ApiKey found for $_ - if you want to autoload this provider, configure an EnvVarName name and envrionment variable or secret name with Set-AIKeyInfo"
        }
        
    }
    
}