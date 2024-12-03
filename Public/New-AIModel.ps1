<#
.SYNOPSIS
    Add an AI model to an existing Provider

.DESCRIPTION
    This cmdlet creates a new AI Model object with the specified functions and adds it to the specified Provider. If no Provider is specified, the Model will not be added to any Provider. The Model can be set as the default Model for the Provider.
.PARAMETER Name
    Name of the AI Model

.PARAMETER Default
    Set the Model as the default Model for the Provider

.PARAMETER ProviderName
    Name of the Provider to add the Model to. If the Provider does not exist, the cmdlet will fail

.PARAMETER ModelFunctions
    Hashtable of additional functions to add to the Model

.PARAMETER PassThru
    Return the created Model object

.EXAMPLE
    New-AIModel -Name 'MyModel' -ProviderName 'MyProvider' -Default
    
    Adds the MyModel to the MyProvider Provider as the default Model. The Model will be set as the default Model.

.EXAMPLE
    New-AIModel -Name 'MyModel' -ProviderName 'MyProvider' -ModelFunctions @{
        'MyFunction' = {
            param($Message)
            return "Hello, $Message"
        }
    }
    
    Adds the MyModel to the MyProvider Provider with a custom function MyFunction that returns a greeting message.

.NOTES
    This cmdlet is mainly used when importing a new AI Model from a file or importing a new AI Provider

#>
function New-AIModel {
    [CmdletBinding()]
    param (
        [parameter(Mandatory)]
        [string] $Name,
        [parameter(Mandatory)]
        [string] $ProviderName,
        [switch] $Default,
        [switch] $PassThru,
        [hashtable] $ModelFunctions
    )
    
    begin {
    }
    
    process {
        $Model = [PSCustomObject]@{
            PSTypeName = 'AIModel'
            Name       = $Name
            Provider   = [PSCustomObject]@{}
        }

        if ($ModelFunctions) {
            $ModelFunctions.Keys | ForEach-Object {
                Add-Member -InputObject $Model -MemberType ScriptMethod -Name $_ -Value $([Scriptblock]::Create($ModelFunctions[$_]))
            }
        }

        # Add Chat to all models
        Add-Member -InputObject $Model -MemberType ScriptMethod -Name Chat -Value {
            [CmdletBinding()]
            param(
                $prompt,
                [switch]$ReturnObject,
                [hashtable]$BodyOptions = @{model = $this.Name },
                [array]$messages = @()
            )
            $this.InvokeModel($prompt, $ReturnObject, $BodyOptions, $messages)
        }


        if ($ProviderName) {
            [PSCustomObject]$AIProvider = Get-AIProvider -Name $ProviderName
            if (!$AIProvider) {
                Write-Error "Provider not found in the ProviderList. Please supply an existing Provider or ProviderName" -ErrorAction Stop
            }
            if ($AIProvider.AIModels.Count -eq 0) {
                $Default = $true
            }
            if ($AIProvider.AIModels?.ContainsKey($Model.Name)) {
                Write-Error "Model already exists in the Provider. Please supply a new Model Name" -ErrorAction Stop
            }
            $Model.Provider = $AIProvider
            $AIProvider.AddModel($Model, $Default)
        }

        if ($PassThru) { $Model }
    }
    
    end {
        # Update tab completion on Get-AIProvider
        $CommandObject = @{
            CommandName    = 'Get-AIModel'
            ModelParameter = 'ModelName'
        }, @{
            CommandName    = 'New-Agent'
            ModelParameter = 'Model'
        }

        Update-ArgumentCompleter -CommandObject $CommandObject -Provider $ProviderName
    }
}