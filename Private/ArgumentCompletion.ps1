function ModelArgumentCompleter {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)

    $models = "gpt-4o",
    "gpt-4o-2024-05-13",
    "gpt-4-turbo",
    "gpt-4-turbo-2024-04-09",
    "gpt-4-0125-preview",
    "gpt-4-turbo-preview",
    "gpt-4-1106-preview",
    "gpt-4-vision-preview",
    "gpt-4",
    "gpt-4-0314",
    "gpt-4-0613",
    "gpt-4-32k",
    "gpt-4-32k-0314",
    "gpt-4-32k-0613",
    "gpt-3.5-turbo",
    "gpt-3.5-turbo-16k",
    "gpt-3.5-turbo-0613",
    "gpt-3.5-turbo-1106",
    "gpt-3.5-turbo-0125",
    "gpt-3.5-turbo-16k-0613"

    foreach ($model in $models) {
        New-Object -TypeName System.Management.Automation.CompletionResult -ArgumentList "'$model'",
        $model , 'ParameterValue' , $model
    }
}

if (Get-Command -ErrorAction SilentlyContinue -name Register-ArgumentCompleter) {
    $functionNames = 'New-OAIAssistant', 'Invoke-OAIChat', 'Invoke-OAIChatCompletion', 'Update-OAIAssistant', 'New-OAIRun', 'Invoke-Chat', 'Invoke-OAIChatCompletion'

    foreach ($functionName in $functionNames) {
        Register-ArgumentCompleter -CommandName $functionName -ParameterName Model -ScriptBlock $Function:ModelArgumentCompleter
    }
}