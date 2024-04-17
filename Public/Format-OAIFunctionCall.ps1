<#
.SYNOPSIS
Formats the function call specification for the OAI (OpenAPI Initiative) generator.

.DESCRIPTION
The Format-OAIFunctionCall function takes a function call specification and formats it for use with the OAI generator. It supports different input types such as string, hashtable, FunctionInfo, and array.

.PARAMETER FunctionSpec
Specifies the function call specification to be formatted. It can be a string, hashtable, FunctionInfo object, or an array of function call specifications.

.EXAMPLE
PS> Format-OAIFunctionCall -FunctionSpec '{"name": "Get-User", "parameters": {"id": 123}}'
Formats the specified function call specification as a hashtable.

.EXAMPLE
PS> Format-OAIFunctionCall -FunctionSpec (Get-Command Get-User)
Formats the specified FunctionInfo object as a hashtable.

.EXAMPLE
PS> Format-OAIFunctionCall -FunctionSpec @('{"name": "Get-User", "parameters": {"id": 123}}', '{"name": "Set-User", "parameters": {"id": 456}}')
Formats each function call specification in the array as a hashtable.

#>
function Format-OAIFunctionCall {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory)]
    $FunctionSpec
  )
  
  if ($FunctionSpec -is [string]) {
    if (Test-JsonReplacement $FunctionSpec -ErrorAction Ignore) {
      $r = $FunctionSpec | ConvertFrom-Json -Depth 10 -AsHashtable
    }
    else {
      throw "Invalid JSON string: $FunctionSpec"
    }
  }
  elseif ($FunctionSpec -is [hashtable]) {
    $r = $FunctionSpec  
  }
  elseif ($FunctionSpec -is [System.Management.Automation.FunctionInfo]) {
    $r = ConvertFrom-FunctionDefinition $FunctionSpec
  }
  elseif ($FunctionSpec -is [array]) {
    $result = foreach ($currentFunction in $FunctionSpec) {
      @{
        'type'   = 'function'
        function = ConvertFrom-FunctionDefinition $currentFunction
      } 
    }

    return $result
  }
  else {
    throw "Invalid FunctionSpec type: $($FunctionSpec.GetType().Name). Must be string, hashtable, or FunctionInfo."
  }
  
  @{
    'type'   = 'function'
    function = $r
  } 
}