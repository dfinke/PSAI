Describe "ConvertTo-OpenAIFunctionSpecDataType" {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PowerShellAIAssistant.psd1" -Force
    }

    It "Converts 'int32' to 'number'" {
        $result = ConvertTo-OpenAIFunctionSpecDataType -targetType 'int32'
        $result | Should -BeExactly 'number'
    }

    It "Converts 'decimal' to 'number'" {
        $result = ConvertTo-OpenAIFunctionSpecDataType -targetType 'decimal'
        $result | Should -BeExactly 'number'
    }

    It "Converts 'float' to 'number'" {
        $result = ConvertTo-OpenAIFunctionSpecDataType -targetType 'float'
        $result | Should -BeExactly 'number'
    }

    It "Converts 'single' to 'number'" {
        $result = ConvertTo-OpenAIFunctionSpecDataType -targetType 'single'
        $result | Should -BeExactly 'number'
    }

    It "Converts 'int' to 'number'" {
        $result = ConvertTo-OpenAIFunctionSpecDataType -targetType 'int'
        $result | Should -BeExactly 'number'
    }

    It "Converts 'bool' to 'boolean'" {
        $result = ConvertTo-OpenAIFunctionSpecDataType -targetType 'bool'
        $result | Should -BeExactly 'boolean'
    }

    It "Converts 'string' to 'string'" {
        $result = ConvertTo-OpenAIFunctionSpecDataType -targetType 'string'
        $result | Should -BeExactly 'string'
    }

    It "Converts 'object' to 'object'" {
        $result = ConvertTo-OpenAIFunctionSpecDataType -targetType 'object'
        $result | Should -BeExactly 'object'
    }
}