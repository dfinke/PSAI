function ConvertTo-OpenAIFunctionSpecDataType {
    <#
        .SYNOPSIS
        Converts a .NET data type to an OpenAI Function Spec data type.

        .DESCRIPTION
        This function takes a .NET data type as input and returns the corresponding OpenAI Function Spec data type.

        .PARAMETER targetType
        The .NET data type to convert.

        .EXAMPLE
        ConvertTo-OpenAIFunctionSpecDataType -targetType 'int32'
        Returns 'number'.

        .EXAMPLE
        ConvertTo-OpenAIFunctionSpecDataType -targetType 'switchparameter'
        Returns 'boolean'.
    #>

    [CmdletBinding()]
    param($targetType)

    switch ($targetType) {
        { $_ -match 'int32|decimal|float|single|int' } { return 'number' }
        { $_ -match 'switchparameter|bool|boolean'} { return 'boolean' }
        default { return $targetType }
    }
}