<#
.SYNOPSIS
Creates a new chat message object.

.DESCRIPTION
The New-OAIChatMessage function creates a new chat message object with the specified content and role.

.PARAMETER Content
The content of the chat message.

.PARAMETER Role
The role of the chat message. Valid values are 'system', 'user', and 'assistant'. The default value is 'user'.

.EXAMPLE
New-OAIChatMessage -Content "Hello, how can I assist you?" -Role 'assistant'
Creates a new chat message object with the content "Hello, how can I assist you?" and the role 'assistant'.

.OUTPUTS
System.Management.Automation.PSCustomObject
A custom object representing the chat message with the 'role' and 'content' properties.

#>

function New-OAIChatMessage {
    [CmdletBinding()]
    param(
        $Content,
        [ValidateSet('system', 'user', 'assistant')] #This list is going to be hard to maintain here. It should be a parameter set in the provider
        $Role = 'user',
        $Model,
        $LLM
    )
    if ($null -eq $Model) { $Model = Get-AIModel }
    $Model.NewMessage($Role, $Content)
}