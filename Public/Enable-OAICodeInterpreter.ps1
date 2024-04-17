<#
.SYNOPSIS
Enables the OAI code interpreter.

.DESCRIPTION
The Enable-OAICodeInterpreter function enables the OAI (OpenAI) code interpreter.

.PARAMETER None
This function does not accept any parameters.

.EXAMPLE
Enable-OAICodeInterpreter
#>

function Enable-OAICodeInterpreter {
    [CmdletBinding()]
    param()
    
    @{'type' = 'code_interpreter' }
}
