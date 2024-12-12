function Get-AIKeyInfo {
    [CmdletBinding()]
    param (
        $AIProvider,
        [switch]
        $AsHashTable
    )
    
    begin {
        $AIKeyInfoPath = Join-Path $env:USERPROFILE 'AIKeyInfo.json'

        if (-not (Test-Path $AIKeyInfoPath)) {
            Write-Verbose "Setting built-in providers as initial AIKeyInfo"
            $AIKeyInfo = @{}
            'OpenAI', 'Gemini', 'Anthropic', 'Groq' | ForEach-Object {
                $AIKeyInfo[$_] = @{
                    EnvKeyName     = $_ + "ApiKey"
                    SecretName = $_ + "ApiKey"
                }
            }
            $AIKeyInfo | ConvertTo-Json | Out-File $AIKeyInfoPath
        }
    }
    
    process {
        $AIKeyInfo = Get-Content $AIKeyInfoPath | ConvertFrom-Json -AsHashtable
        [void]$AIKeyInfo.Keys | ForEach-Object {
            $_; $AIKeyInfo[$_]
        }

        if ($AsHashTable) {
            return $AIKeyInfo
        }
        else {
            $AIKeyInfo.Keys | ForEach-Object {
                [PSCustomObject]@{
                    AIProvider = $_
                    EnvKeyName     = $AIKeyInfo[$_].EnvKeyName
                    SecretName = $AIKeyInfo[$_].SecretName
                }
            } | Where-Object { $_.AIProvider -like $AIProvider -or -not $AIProvider }
        }

    }
    
    end {

    }
}