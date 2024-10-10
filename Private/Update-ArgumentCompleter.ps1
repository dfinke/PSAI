function Update-ArgumentCompleter {
    [CmdletBinding()]
    param (
        $Functions,
        [switch]$Provider,
        [switch]$Model
    )
    
    begin {
        
        
    }
    
    process {
        if ($Model) {
            $Models = (Get-AIModel -All).Name
            $script:ModelParameters = $Models.foreach{
                New-Object -Type System.Management.Automation.CompletionResult -ArgumentList "'$_'", $_, 'ParameterValue', $_
            }
            $Functions.foreach{
                Register-ArgumentCompleter -CommandName $_ -ParameterName 'ModelName' -ScriptBlock {
                    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
                    $ModelParameters
                }
            }
        }
        if ($Provider) {
            $Providers = (Get-AIProvider -All).Keys
            $script:ProviderParameters = $Providers.foreach{
                New-Object -Type System.Management.Automation.CompletionResult -ArgumentList "'$_'", $_, 'ParameterValue', $_
            }
            $Functions.foreach{
                $parameterName = 'ProviderName'
                if ($_ -eq 'Get-AIProvider') {
                    $parameterName = 'Name'
                }
                Register-ArgumentCompleter -CommandName $_ -ParameterName $parameterName -ScriptBlock {
                    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
                    $ProviderParameters
                }
            }
        }

    }
    
    end {
        
    }
}