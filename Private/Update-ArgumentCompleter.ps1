function Update-ArgumentCompleter {
    [CmdletBinding()]
    param (
        $CommandObject,
        $Provider
    )
    
    begin {
        
        
    }
    
    process {

        $CommandsForModelUpdate = $CommandObject | Where-Object { $_.ModelParameter }
        if ($CommandsForModelUpdate) {
            #TODO Write ModelParams for each function - this is tricky. Script variables dont seem to work
            $Models = (Get-AIModel -All).Name
            $script:ModelParameters = foreach ($Model in $Models) {
                New-Object -Type System.Management.Automation.CompletionResult -ArgumentList "'$Model'", $Model, 'ParameterValue', $Model
            }
            foreach ( $Command in $CommandsForModelUpdate) {
                Register-ArgumentCompleter -CommandName $Command.CommandName -ParameterName $Command.ModelParameter -ScriptBlock    {
                    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
                    $script:ModelParameters
                }
            }
        }

        $CommandsForProviderUpdate = $CommandObject | Where-Object { $_.ProviderParameter }
        if ($CommandsForProviderUpdate) { 
            $Providers = (Get-AIProvider -All).Keys
            $script:ProviderParameters = $Providers | ForEach-Object {
                New-Object -Type System.Management.Automation.CompletionResult -ArgumentList "'$($_)'", $_, 'ParameterValue', $_
            }
            foreach ($Command in $CommandsForProviderUpdate) {
                Register-ArgumentCompleter -CommandName $Command.CommandName -ParameterName $Command.ProviderParameter -ScriptBlock {
                    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
                    $script:ProviderParameters
                }
            }
        }

    }
    
    end {
        
    }
}