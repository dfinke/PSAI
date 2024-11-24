function New-AIProvider {
    [CmdletBinding()]
    param (
        [string]$Name,
        [string]$Provider,
        [securestring]$ApiKey,
        [string]$BaseUri,
        [string]$Version,
        [System.Collections.Generic.Dictionary[string, PSCustomObject]]$AIModels,
        [string]$DefaultModel,
        [switch]$Default,
        [switch]$PassThru,
        [switch]$Force
    )
    
    begin {
        $ExistingProviderlist = Get-AIProviderList
        if (!$ExistingProviderlist) { New-AIProviderList }
    }
    
    process {
        $AIModelsList = [System.Collections.Generic.Dictionary[string, PSCustomObject]]::new([StringComparer]::OrdinalIgnoreCase)
        if ($AIModels) {
            $AIModels.Keys | ForEach-Object {
                $AIModelsList.Add($_, $AIModels[$_])
            }
        }
        $ProviderObject = [PSCustomObject]@{
            PSTypeName   = 'AIProvider'
            Name         = $Name
            Provider     = $Provider
            ApiKey       = $ApiKey
            BaseUri      = $BaseUri
            Version      = $Version
            AIModels     = $AIModelsList
            DefaultModel = $DefaultModel
        }

        Add-Member -InputObject $ProviderObject -MemberType ScriptMethod -Name 'GetApiKey' -Value {
            return $this.ApiKey | ConvertFrom-SecureString -AsPlainText
        }

        Add-Member -InputObject $ProviderObject -MemberType ScriptMethod -Name 'SetDefaultModel' -Value {
            param([string]$ModelName)
            $this.DefaultModel = $ModelName
        }

        Add-Member -InputObject $ProviderObject -MemberType ScriptMethod -Name 'GetDefaultModel' -Value {
            return $this.DefaultModel
        }

        Add-Member -InputObject $ProviderObject -MemberType ScriptMethod -Name 'GetModel' -Value {
            param([string]$ModelName)
            return $this.AIModels[$ModelName]
        }

        Add-Member -InputObject $ProviderObject -MemberType ScriptMethod -Name 'GetModels' -Value {
            param([string]$ModelName)
            return $this.AIModels.Keys
        }

        Add-Member -InputObject $ProviderObject -MemberType ScriptMethod -Name 'AddModel' -Value {
            param([PSCustomObject]$Model, [bool]$Default = $false)
            if ($null -eq $this.AIModels) { $this.AIModels = @({}) }
            [void]$this.AIModels.TryAdd($Model.Name, $Model)
            if ($Default) {
                $this.SetDefaultModel($Model.Name)
            }
        }

        Add-AIProviderToList -Provider $ProviderObject -Default:$Default -Force:$Force
    }
    
    end {
        # Update tab coimpletion on Get-AIProvider
        Update-ArgumentCompleter -Function 'Get-AIProvider', 'Set-AIDefaultProvider' -Provider
        if ($PassThru) { $ProviderObject }
    }
}