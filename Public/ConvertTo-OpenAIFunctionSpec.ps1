function ConvertTo-OpenAIFunctionSpec {
    <#
        .SYNOPSIS
        Converts a PowerShell function to an OpenAI function specification.

        .DESCRIPTION
        The ConvertTo-OpenAIFunctionSpec function takes a PowerShell function as input and returns an OpenAI function specification. The function specification includes the function name, description, and parameter information.

        .PARAMETER targetCode
        The PowerShell function to convert to an OpenAI function specification.

        .PARAMETER Compress
        Indicates whether to compress the output JSON.

        .PARAMETER Raw
        Indicates whether to return the raw function specification object instead of JSON.

        .EXAMPLE
        PS C:\> $functionCode = Get-Content -Path "C:\MyFunction.ps1" -Raw
        PS C:\> ConvertTo-OpenAIFunctionSpec -targetCode $functionCode -Compress

        This example reads the contents of a PowerShell function file, converts the function to an OpenAI function specification, and returns the specification as compressed JSON.
    #>
    [CmdletBinding()]
    param(
        $targetCode,
        [Switch]$Compress,
        [Switch]$Raw
    )
    
    $ast = [System.Management.Automation.Language.Parser]::ParseInput($targetCode, [ref]$null, [ref]$null)
    $functions = $ast.FindAll({ $args[0] -is [System.Management.Automation.Language.FunctionDefinitionAst] }, $false)

    $functionSpec = @()
    foreach ($function in $functions) {
        $descriptions = Get-OpenAISpecDescriptions $function.Body.extent.text

        if ($null -eq $descriptions.FunctionDescription) {
            $targetDescription = 'not supplied'
        }
        else {
            $targetDescription = $descriptions.FunctionDescription
        }

        $functionSpec += [ordered]@{
            name        = $function.Name
            description = $targetDescription

            parameters  = [ordered]@{
                type       = 'object'
                properties = [ordered]@{}
                required   = @()
            }
        }

        $properties = $functionSpec[-1].parameters.properties
        $parameters = $function.Body.ParamBlock.Parameters
        foreach ($parameter in $parameters) {
            $parameterName = $parameter.Name.VariablePath.UserPath
            $typeName = $parameter.StaticType.Name.ToLower()
            if ($parameter.StaticType.BaseType.Name -eq 'Array') {
                $typeName = 'array'                
            }

            if ($null -eq $descriptions.ParameterDescription.$parameterName) {
                $targetDescription = 'not supplied'
            }
            else {
                $targetDescription = $descriptions.ParameterDescription.$parameterName
            }

            $properties[$parameterName] = [ordered]@{            
                type        = ConvertTo-OpenAIFunctionSpecDataType $typeName
                description = $targetDescription
            }
        
            $enum = ($parameter.Attributes | Where-Object { $_.typeName.name -eq 'ValidateSet' }).PositionalArguments.Value

            if ($enum) {
                $properties[$parameterName].enum = $enum
            }
        
            $functionSpec[-1].parameters.required += $parameterName
        }
    }
    
    if ($Raw) {
        return $functionSpec
    }

    $functionSpec | ConvertTo-Json -Depth 10 -Compress:$Compress
}