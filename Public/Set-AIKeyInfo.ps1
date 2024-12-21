function Set-AIKeyInfo {
    [CmdletBinding()]
    param (
        [string]
        $AIProvider,
        [string]
        $EnvKeyName,
        [string]
        $SecretName,
        [string]
        $VaultName,
        [string]
        $BaseUri,
        [string[]]
        $ModelNames,
        [string]
        $Version,
        [switch]
        $Default
    )
    
    begin {
        $AIKeyInfoPath = Join-Path $(Split-Path $PSScriptRoot) 'AIKeyInfo.json'
        $AIKeyInfo = Get-AIKeyInfo $AIKeyInfoPath -AsHashtable

    }
    
    process {
        $key = $AIKeyInfo[$AIProvider]
        if (-not $key) {
            $AIKeyInfo[$AIProvider] = @{
                EnvKeyName = $EnvKeyName
                SecretName = $SecretName
                VaultName = $VaultName
                BaseUri = $BaseUri
                ModelNames = $ModelNames
                Version = $Version
                Default = $Default
            }
        }
        if ($EnvKeyName) {
            $AIKeyInfo[$AIProvider]['EnvKeyName'] = $EnvKeyName
        }
        if ($SecretName) {
            $AIKeyInfo[$AIProvider]['SecretName'] = $SecretName
        }
        if ($VaultName) {
            $AIKeyInfo[$AIProvider]['VaultName'] = $VaultName
        }
        if ($BaseUri) {
            $AIKeyInfo[$AIProvider]['BaseUri'] = $BaseUri
        }
        if ($ModelNames) {
            $AIKeyInfo[$AIProvider]['ModelNames'] = $ModelNames
        }
        if ($Version) {
            $AIKeyInfo[$AIProvider]['Version'] = $Version
        }
        if ($Default) {
            $AIKeyInfo.Keys | ForEach-Object {
                $AIKeyInfo[$_].Default = $false
            }
            $AIKeyInfo[$AIProvider]['Default'] = $true
        }
    }
    
    end {
        $AIKeyInfo | ConvertTo-Json | Out-File $AIKeyInfoPath
    }
}