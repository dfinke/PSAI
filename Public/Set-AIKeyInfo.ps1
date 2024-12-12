function Set-AIKeyInfo {
    [CmdletBinding()]
    param (
        $AIProvider,
        $EnvKeyName,
        $SecretName 
    )
    
    begin {
        $AIKeyInfoPath = Join-Path $env:USERPROFILE 'AIKeyInfo.json'
        $AIKeyInfo = Get-AIKeyInfo $AIKeyInfoPath -AsHashtable

    }
    
    process {
        $key = $AIKeyInfo[$AIProvider]
        if (-not $key) {
            $AIKeyInfo[$AIProvider] = @{
                EnvKeyName = $EnvKeyName
                SecretName = $SecretName
            }
        }
        if ($EnvKeyName) {
            $AIKeyInfo[$AIProvider]['EnvKeyName'] = $EnvKeyName
        }
        if ($SecretName) {
            $AIKeyInfo[$AIProvider]['SecretName'] = $SecretName
        }
    }
    
    end {
        $AIKeyInfo | ConvertTo-Json | Out-File $AIKeyInfoPath
    }
}