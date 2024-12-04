<#
.SYNOPSIS
Creates a new OpenAI chat configuration object.

.DESCRIPTION
The New-OpenAIChat function initializes a new OpenAI chat configuration object with a specified model. 
It generates a verbose message containing the timestamp and the configuration details.

.PARAMETER model
Specifies the model to be used for the OpenAI chat. The default value is 'gpt-4o-mini'.

.EXAMPLE
PS C:\> New-OpenAIChat -model 'gpt-4o-mini'
This example creates a new OpenAI chat configuration object using the 'gpt-3.5-turbo' model.

.EXAMPLE
PS C:\> New-OpenAIChat
This example creates a new OpenAI chat configuration object using the default 'gpt-4o-mini' model.
#>

function New-OpenAIChat {
    [CmdletBinding()]
    param(
        $model,
        $Provider
    )

    $ProviderList = Get-AIProviderList
    if ($null -eq $ProviderList) { New-ProviderListFromEnv }
    $params = @{}
    if ($Provider){$params['ProviderName'] = $Provider}
    if ($Model){$params['ModelName'] = $Model}
    $model = Get-AIModel @params

    $openAIConfig = [PSCustomObject]@{
        config = [PSCustomObject]@{
            model = $model.Name
            provider = $model.Provider.Name
        }
    }

    Add-Member -InputObject $openAIConfig -MemberType ScriptMethod -Name GetModel -Value {
        param($config = $this)
        Get-AIModel -ModelName $config.config.model -ProviderName $config.config.provider
    }

    $verboseMessage = @"
$(Get-LogDate) 
New-OpenAIChat was called
$($openAIConfig | dumpJson)
"@
  
    Write-Verbose $verboseMessage
    
    $openAIConfig
}