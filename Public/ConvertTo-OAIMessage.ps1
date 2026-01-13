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
        $converted = $Message | ConvertTo-Json -Depth 10 | ConvertFrom-Json -AsHashtable -Depth 10

        foreach ($key in @('refusal', 'annotations')) {
            if ($converted.ContainsKey($key)) {
                $converted.Remove($key)
            }
        }

        if ($converted.ContainsKey('content') -and $converted['content'] -is [array]) {
            foreach ($part in $converted['content']) {
                if ($part -is [hashtable]) {
                    foreach ($k in @('refusal', 'annotations')) {
                        if ($part.ContainsKey($k)) {
                            $part.Remove($k)
                        }
                    }
                    if ($part.ContainsKey('text') -and $part['text'] -is [hashtable]) {
                        foreach ($k in @('refusal', 'annotations')) {
                            if ($part['text'].ContainsKey($k)) {
                                $part['text'].Remove($k)
                            }
                        }
                    }
                }
            }
        }

        $converted
    }
}
