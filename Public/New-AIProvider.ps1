<#
.SYNOPSIS
    Add a new AI Provider to the list of available Providers.

.DESCRIPTION
    This function creates a new AI Provider object with the specified parameters and adds it to the list of available Providers. The function also adds several methods to the Provider object, including GetApiKey, SetDefaultModel, GetDefaultModel, GetModel, GetModels, and AddModel.

.PARAMETER Name
    Custom name of the Provider.

.PARAMETER Provider
    Name of the Provider. This is used to identify the Provider when calling the InvokeModel function.

.PARAMETER ApiKey
    The ApiKey to use for the Provider. Must be a SecureString.

.PARAMETER BaseUri
    The BaseUri to use for the Provider.

.PARAMETER Version
    The version of the Provider API.

.PARAMETER AIModels
    A hashtable of AI Models to add to the Provider. The key is the Model name and the value is a PSCustomObject with the Model properties.

.PARAMETER DefaultModel
    The default Model to use for the Provider.

.PARAMETER Default
    Forces the Provider to be the default if other providers are already imported.

.PARAMETER PassThru
    Returns the created Provider object to the pipeline.

.PARAMETER Force
    Creates a new Provider list and imports the Provider.

.EXAMPLE
    New-AIProvider -Name 'MyProvider' -Provider 'MyProvider' -ApiKey $('SecretKey' | ConvertTo-SecureString -AsPlainText) -BaseUri https://MyProvider.com/v1'
    Creates a new Provider with no Models.

.NOTES
    This function is mainly used when importing a new AI Provider from a file or when creating a new Provider in the shell.
#>
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
        if (!$script:ProviderList) { New-AIProviderList }
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
            if ($null -eq $this.AIModels) { $this.AIModels = @( {}) }
            [void]$this.AIModels.TryAdd($Model.Name, $Model)
            if ($Default) {
                $this.SetDefaultModel($Model.Name)
            }
        }

        Add-AIProviderToList -Provider $ProviderObject -Default:$Default -Force:$Force
    }
    
    end {
        # Update tab completion on Get-AIProvider
        $CommandObject = @{  
            CommandName       = 'Get-AIProvider'
            ProviderParameter = 'Name'
        },
        @{
            CommandName       = 'Set-AIDefaultProvider'
            ProviderParameter = 'ProviderName'
        },
        @{
            CommandName       = 'New-Agent'
            ProviderParameter = 'Provider'
        },
        @{
            CommandName       = 'Get-AIModel'
            ProviderParameter = 'ProviderName'
        }, @{
            CommandName    = 'New-OpenAIChat'
            ProviderParameter = 'ProviderName'
        }, @{
            CommandName    = 'Invoke-OAIChatCompletion'
            ProviderParameter = 'Provider'
        }
        Update-ArgumentCompleter -CommandObject $CommandObject
        if ($PassThru) { $ProviderObject }
    }
}