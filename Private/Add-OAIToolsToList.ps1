<#
.SYNOPSIS
Adds tools and functions to a list for use with OpenAI Assistants.

.DESCRIPTION
The Add-OAIToolsToList function is used to add tools and functions to a list, which can be used with OpenAI Assistants. It takes in parameters for the tools, function JSON, and a hashtable representing the body of the request. The function then constructs a list of tools and functions based on the provided parameters and updates the 'tools' property of the body hashtable.

.PARAMETER Tools
An optional array of strings representing the tools to be added to the list.

.PARAMETER FunctionJson
An optional array of function JSON objects representing the functions to be added to the list.

.PARAMETER Body
A mandatory hashtable representing the body of the request.

.EXAMPLE
Add-OAIToolsToList -Tools 'spellcheck' -FunctionJson @('{"type": "function", "function": "function_json"}') -Body $body
Adds the 'spellcheck' tool and a function JSON object to the list of tools in the body hashtable.

.LINK
https://platform.openai.com/docs/assistants/tools/defining-functions

#>
function Add-OAIToolsToList {
    [CmdletBinding()]
    param(
        $Tools,
        $FunctionJson,
        [Parameter(Mandatory)]
        [Hashtable]$Body
    )

    $toolList = @()
    
    if ($Tools) {
        foreach ($tool in $Tools) {
            $toolList += @{ type = $tool }
        }
    }
    
    if ($FunctionJson) {
        # {"type": "function", "function": function_json},

        foreach ($function in $FunctionJson) {
            $toolList += @{
                type     = 'function'
                function = $function | ConvertFrom-Json -Depth 15 -AsHashtable
            }
        }
    }
    
    if ($toolList.Count -gt 0) {
        $Body['tools'] = $toolList
    }
}