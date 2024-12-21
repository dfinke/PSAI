function Get-AIKeyInfo {
    [CmdletBinding()]
    param (
        $AIProvider,
        [switch]
        $AsHashTable
    )
    
    begin {
        $AIKeyInfoPath = Join-Path $(Split-Path $PSScriptRoot) 'AIKeyInfo.json'

        if (-not (Test-Path $AIKeyInfoPath)) {
            Write-Verbose "Setting built-in providers as initial AIKeyInfo"
            $AIKeyInfo = @{}
            'OpenAI', 'Gemini', 'Anthropic', 'Groq', 'xAI' | ForEach-Object {
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