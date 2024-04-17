<#
.SYNOPSIS
Clears all items in the OAI (OpenAI) system.

.DESCRIPTION
The Clear-OAIAllItems function clears all items in the OAI (OpenAI) system by calling the Clear-OAIAssistants and Clear-OAIFiles functions.

.PARAMETER None
This function does not accept any parameters.

.EXAMPLE
Clear-OAIAllItems
Clears all items in the OAI (OpenAI) system.

#>
function Clear-OAIAllItems {
    [CmdletBinding()]
    param()
    
    Clear-OAIAssistants
    Clear-OAIFiles
}
