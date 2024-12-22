function Get-AIKeyInfo {
    [CmdletBinding()]
    param (
        $AIProvider,
        [switch]
        $AsHashTable,
        [switch]
        $DoNotUpdate
    )
    
    begin {
        $AIKeyInfoPath = Join-Path $(Split-Path $PSScriptRoot) 'AIKeyInfo.json'

        # Array of supported providers - need to figure out a way to get this info from the providers themselves
        # We only want the ones that require an API key
        $SupportedProviders = @('OpenAI', 'Gemini', 'Anthropic', 'Groq', 'xAI')

        if (-not (Test-Path $AIKeyInfoPath)) {
            Write-Verbose "Setting built-in providers as initial AIKeyInfo"
            $AIKeyInfo = @{}
            $SupportedProviders | ForEach-Object {
                $AIKeyInfo[$_] = @{
                    EnvKeyName = $_ + "Key"
                    SecretName = ''
                    VaultName  = ''
                    BaseUri    = ''
                    ModelNames = @()
                    Version    = ''
                    Default    = $false
                }
            }
            $AIKeyInfo | ConvertTo-Json | Out-File $AIKeyInfoPath
        }

        # If new providers have been added, add them to the AIKeyInfo.json file
        $AIKeyInfo = Get-Content $AIKeyInfoPath | ConvertFrom-Json -AsHashtable
        if (!$DoNotUpdate) {
            $SupportedProviders | ForEach-Object {
                if (-not $AIKeyInfo.ContainsKey($_)) {
                    Set-AIKeyInfo -AIProvider $_ -EnvKeyName $($_ + "Key") -ModelNames @()
                }
            }
        } 

    }
    
    process {
        $AIKeyInfo = Get-Content $AIKeyInfoPath | ConvertFrom-Json -AsHashtable

        if ($AsHashTable) {
            return $AIKeyInfo
        }
        else {
            $AIKeyInfo.Keys | ForEach-Object {
                [PSCustomObject]@{
                    AIProvider = $_
                    EnvKeyName = $AIKeyInfo[$_].EnvKeyName
                    SecretName = $AIKeyInfo[$_].SecretName
                    VaultName  = $AIKeyInfo[$_].VaultName
                    BaseUri    = $AIKeyInfo[$_].BaseUri
                    ModelNames = $AIKeyInfo[$_].ModelNames
                    Version    = $AIKeyInfo[$_].Version
                    Default    = $AIKeyInfo[$_].Default
                }
            } | Where-Object { $_.AIProvider -like $AIProvider -or -not $AIProvider }
        }

    }
    
    end {

    }
}