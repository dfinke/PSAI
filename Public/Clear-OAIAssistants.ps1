<#
.SYNOPSIS
Clears all OAI assistants.

.DESCRIPTION
This function clears all OAI (OpenAI) assistants by removing them.

.PARAMETER None
This function does not accept any parameters.

.EXAMPLE
Clear-OAIAssistants
Clears all OAI assistants.

#>
function Clear-OAIAssistants {
    [CmdletBinding()]
    param()
    
    Get-OAIAssistant | Remove-OAIAssistant 
}
