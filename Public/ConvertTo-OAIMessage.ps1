<#
.SYNOPSIS
Converts a message to an OpenAPI message format.

.DESCRIPTION
The ConvertTo-OAIMessage function takes a message as input and converts it to an OpenAPI message format. It uses the ConvertTo-Json cmdlet to convert the message to JSON format and then uses the ConvertFrom-Json cmdlet with the -AsHashtable parameter to convert the JSON back to a hashtable.

.PARAMETER Message
The message to be converted.

.EXAMPLE
$m=[pscustomobject](New-ChatRequestAssistantMessage test)
$m
$m | ConvertTo-OAIMessage

#>

function ConvertTo-OAIMessage {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline)]
        $Message
    )

    Process {
        $Message | ConvertTo-Json -Depth 5 | ConvertFrom-Json -AsHashtable -Depth 5
    }
}
