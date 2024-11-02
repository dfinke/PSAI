<#
.SYNOPSIS
    Invokes the specified tool functions based on the response received.

.DESCRIPTION
    The Invoke-OAIFunctionCall function is used to invoke the specified tool functions based on the response received. It iterates through the tool calls in the response and executes each tool function.

.PARAMETER Response
    The response object containing the tool calls.
#>
function Invoke-OAIFunctionCall {
    [CmdletBinding()]
    param(
        $Response
    )

    $toolCalls = $Response.choices[0].message.tool_calls

    # Write-Verbose ($toolCalls | dumpJson)

    foreach ($toolCall in $toolCalls) {        
        $toolCallId = $toolCall.id
        $toolFunctionName = $toolCall.function.name
        $toolFunctionArgs = $toolCall.function.arguments | ConvertFrom-Json -AsHashtable -Depth 5
        
        Write-Verbose "$toolFunctionName $($toolFunctionArgs | ConvertTo-Json -Compress)"

        if (Get-Command $toolFunctionName -ErrorAction SilentlyContinue) {
            $result = & $toolFunctionName @toolFunctionArgs
        } 
        else {
            $result = "Function $toolFunctionName not found"
        }
        
        if ([string]::IsNullOrEmpty($result)) {
            $result = "NOTE: function did not return any value"
        }
        
        New-ChatRequestToolMessage $toolCallId $toolFunctionName $result
    }
}