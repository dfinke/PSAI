<#
.SYNOPSIS
Creates a new chat request tool message.

.DESCRIPTION
The New-ChatRequestToolMessage function creates a new chat request tool message with the specified parameters.

.PARAMETER toolCallId
The ID of the tool call.

.PARAMETER toolFunctionName
The name of the tool function.

.PARAMETER content
The content of the tool message.

.EXAMPLE
New-ChatRequestToolMessage -toolCallId 123 -toolFunctionName "MyTool" -content "Hello, world!"

This example creates a new chat request tool message with the tool call ID 123, tool function name "MyTool", and content "Hello, world!".

#>
function New-ChatRequestToolMessage {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        $toolCallId,
        [Parameter(Mandatory)]
        $toolFunctionName,
        [Parameter(Mandatory)]
        $content        
    )
  
    @{
        role         = 'tool'
        tool_call_id = $toolCallId
        name         = $toolFunctionName
        content      = $content | Out-String
    }
}