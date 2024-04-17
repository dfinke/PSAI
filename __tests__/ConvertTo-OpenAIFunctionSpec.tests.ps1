Describe "ConvertTo-OpenAIFunctionSpec" {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PSAI.psd1" -Force
    }

    It "Converts a function with no parameters" {
        $targetCode = @'
function Test-Function {}
'@
        $actualFunctionSpec = ConvertTo-OpenAIFunctionSpec $targetCode | ConvertFrom-Json

        $actualFunctionSpec.Count | Should -BeExactly 1
        $actualFunctionSpec[0].name | Should -BeExactly 'Test-Function'
        $actualFunctionSpec[0].description | Should -BeExactly 'not supplied'
        $actualFunctionSpec[0].parameters.type | Should -BeExactly 'object'
        $actualFunctionSpec[0].parameters.properties | Should -BeNullOrEmpty
        $actualFunctionSpec[0].required.Count | Should -BeExactly 0        
    }

    It "Converts a function with one parameter" {
        $targetCode = @'
function Test-Function {
    param(
        $Parameter1
    )
}
'@
        $actualFunctionSpec = ConvertTo-OpenAIFunctionSpec $targetCode | ConvertFrom-Json

        $actualFunctionSpec.Count | Should -BeExactly 1
        $actualFunctionSpec[0].name | Should -BeExactly 'Test-Function'
        $actualFunctionSpec[0].description | Should -BeExactly 'not supplied'
        $actualFunctionSpec[0].parameters.type | Should -BeExactly 'object'
        $actualFunctionSpec[0].parameters.properties.Count | Should -BeExactly 1
        $actualFunctionSpec[0].parameters.properties.Parameter1.type | Should -BeExactly 'object'
        $actualFunctionSpec[0].parameters.properties.Parameter1.description | Should -BeExactly 'not supplied'
        $actualFunctionSpec[0].parameters.required.Count | Should -BeExactly 1
        $actualFunctionSpec[0].parameters.required[0] | Should -BeExactly 'Parameter1'
    }

    It "Converts a function with two parameters" {
        $targetCode = @'
function Test-Function {
    param(
        $Parameter1,
        $Parameter2
    )
}
'@

        $actualFunctionSpec = ConvertTo-OpenAIFunctionSpec $targetCode | ConvertFrom-Json

        $actualFunctionSpec.Count | Should -BeExactly 1
        $actualFunctionSpec[0].name | Should -BeExactly 'Test-Function'
        $actualFunctionSpec[0].description | Should -BeExactly 'not supplied'
        $actualFunctionSpec[0].parameters.type | Should -BeExactly 'object'
       
        # Check that there are exactly 2 properties in the parameters object
        $actualFunctionSpec[0].parameters.properties.psobject.properties.name.Count | Should -BeExactly 2

        $actualFunctionSpec[0].parameters.properties.Parameter1.type | Should -BeExactly 'object'
        $actualFunctionSpec[0].parameters.properties.Parameter1.description | Should -BeExactly 'not supplied'
        $actualFunctionSpec[0].parameters.properties.Parameter2.type | Should -BeExactly 'object'
        $actualFunctionSpec[0].parameters.properties.Parameter2.description | Should -BeExactly 'not supplied'
        $actualFunctionSpec[0].parameters.required.Count | Should -BeExactly 2
        $actualFunctionSpec[0].parameters.required[0] | Should -BeExactly 'Parameter1'
        $actualFunctionSpec[0].parameters.required[1] | Should -BeExactly 'Parameter2'
    }

    It "Converts a function with a parameter as an array" {
        $targetCode = @'
function Test-Function {
    param(
        [int[]]$Parameter1
    )
}
'@

        $actualFunctionSpec = ConvertTo-OpenAIFunctionSpec $targetCode | ConvertFrom-Json

        $actualFunctionSpec.Count | Should -BeExactly 1
        $actualFunctionSpec[0].name | Should -BeExactly 'Test-Function'
        $actualFunctionSpec[0].description | Should -BeExactly 'not supplied'
        $actualFunctionSpec[0].parameters.type | Should -BeExactly 'object'
        $actualFunctionSpec[0].parameters.properties.Parameter1.type | Should -BeExactly 'array'
        
        $actualFunctionSpec[0].parameters.properties.Parameter1.description | Should -BeExactly 'not supplied'
        $actualFunctionSpec[0].parameters.required.Count | Should -BeExactly 1
        $actualFunctionSpec[0].parameters.required[0] | Should -BeExactly 'Parameter1'

    }

    It "Converts a function with a parameter as a float" {
        $targetCode = @'
function Test-Function {
    param(
        [float]$Parameter1
    )
}
'@
        $actualFunctionSpec = ConvertTo-OpenAIFunctionSpec $targetCode | ConvertFrom-Json

        $actualFunctionSpec.Count | Should -BeExactly 1
        $actualFunctionSpec[0].name | Should -BeExactly 'Test-Function'
        $actualFunctionSpec[0].description | Should -BeExactly 'not supplied'
        $actualFunctionSpec[0].parameters.type | Should -BeExactly 'object'
        $actualFunctionSpec[0].parameters.properties.Parameter1.type | Should -BeExactly 'number'
        $actualFunctionSpec[0].parameters.properties.Parameter1.description | Should -BeExactly 'not supplied'
        $actualFunctionSpec[0].parameters.required.Count | Should -BeExactly 1
        $actualFunctionSpec[0].parameters.required[0] | Should -BeExactly 'Parameter1'
    }

    It "Converts a function with a parameter as a bool" {
        $targetCode = @'
function Test-Function {
    param(
        [bool]$Parameter1
    )
}
'@
        $actualFunctionSpec = ConvertTo-OpenAIFunctionSpec $targetCode | ConvertFrom-Json

        $actualFunctionSpec.Count | Should -BeExactly 1
        $actualFunctionSpec[0].name | Should -BeExactly 'Test-Function'
        $actualFunctionSpec[0].description | Should -BeExactly 'not supplied'
        $actualFunctionSpec[0].parameters.type | Should -BeExactly 'object'
        $actualFunctionSpec[0].parameters.properties.Parameter1.type | Should -BeExactly 'boolean'
        $actualFunctionSpec[0].parameters.properties.Parameter1.description | Should -BeExactly 'not supplied'
        $actualFunctionSpec[0].parameters.required.Count | Should -BeExactly 1
        $actualFunctionSpec[0].parameters.required[0] | Should -BeExactly 'Parameter1'
    }

    It "Converts a function with a parameter as a boolean" {
        $targetCode = @'
function Test-Function {
    param(
        [bool]$Parameter1
    )
}
'@
        $actualFunctionSpec = ConvertTo-OpenAIFunctionSpec $targetCode | ConvertFrom-Json

        $actualFunctionSpec.Count | Should -BeExactly 1
        $actualFunctionSpec[0].name | Should -BeExactly 'Test-Function'
        $actualFunctionSpec[0].description | Should -BeExactly 'not supplied'
        $actualFunctionSpec[0].parameters.type | Should -BeExactly 'object'
        $actualFunctionSpec[0].parameters.properties.Parameter1.type | Should -BeExactly 'boolean'
        $actualFunctionSpec[0].parameters.properties.Parameter1.description | Should -BeExactly 'not supplied'
        $actualFunctionSpec[0].parameters.required.Count | Should -BeExactly 1
        $actualFunctionSpec[0].parameters.required[0] | Should -BeExactly 'Parameter1'

    }

    It "Converts a function with a parameter having a validate set" {
        $targetCode = @'
function Test-Function {
    param(
        [ValidateSet("Value1", "Value2")]
        $Parameter1
    )
}
'@
        $actualFunctionSpec = ConvertTo-OpenAIFunctionSpec $targetCode | ConvertFrom-Json

        $actualFunctionSpec.Count | Should -BeExactly 1
        $actualFunctionSpec[0].name | Should -BeExactly 'Test-Function'
        $actualFunctionSpec[0].description | Should -BeExactly 'not supplied'
        $actualFunctionSpec[0].parameters.type | Should -BeExactly 'object'
        $actualFunctionSpec[0].parameters.properties.Parameter1.type | Should -BeExactly 'object'
        $actualFunctionSpec[0].parameters.properties.Parameter1.description | Should -BeExactly 'not supplied'
        $actualFunctionSpec[0].parameters.properties.Parameter1.enum.Count | Should -BeExactly 2
        $actualFunctionSpec[0].parameters.properties.Parameter1.enum[0] | Should -BeExactly 'Value1'
        $actualFunctionSpec[0].parameters.properties.Parameter1.enum[1] | Should -BeExactly 'Value2'
        $actualFunctionSpec[0].parameters.required.Count | Should -BeExactly 1
        $actualFunctionSpec[0].parameters.required[0] | Should -BeExactly 'Parameter1'
    }        

    It "Converts a script with two functions" {
        $targetCode = @'
function Test-Function1 {
    param(
        [string]$Parameter1,
        [int]$Parameter2
    )
}

function Test-Function2 {
    param(
        [string]$Parameter1,
        [switch]$Parameter2
    )
}
'@

        $actualFunctionSpec = ConvertTo-OpenAIFunctionSpec $targetCode | ConvertFrom-Json

        $actualFunctionSpec.Count | Should -BeExactly 2

        $actualFunctionSpec[0].name | Should -BeExactly 'Test-Function1'
        $actualFunctionSpec[0].description | Should -BeExactly 'not supplied'
        $actualFunctionSpec[0].parameters.type | Should -BeExactly 'object'
        $actualFunctionSpec[0].parameters.properties.Parameter1.type | Should -BeExactly 'string'
        $actualFunctionSpec[0].parameters.properties.Parameter1.description | Should -BeExactly 'not supplied'
        $actualFunctionSpec[0].parameters.properties.Parameter2.type | Should -BeExactly 'number'
        $actualFunctionSpec[0].parameters.properties.Parameter2.description | Should -BeExactly 'not supplied'
        $actualFunctionSpec[0].parameters.required.Count | Should -BeExactly 2
        $actualFunctionSpec[0].parameters.required[0] | Should -BeExactly 'Parameter1'
        $actualFunctionSpec[0].parameters.required[1] | Should -BeExactly 'Parameter2'

        $actualFunctionSpec[1].name | Should -BeExactly 'Test-Function2'
        $actualFunctionSpec[1].description | Should -BeExactly 'not supplied'
        $actualFunctionSpec[1].parameters.type | Should -BeExactly 'object'
        $actualFunctionSpec[1].parameters.properties.Parameter1.type | Should -BeExactly 'string'
        $actualFunctionSpec[1].parameters.properties.Parameter1.description | Should -BeExactly 'not supplied'
        $actualFunctionSpec[1].parameters.properties.Parameter2.type | Should -BeExactly 'boolean'
        $actualFunctionSpec[1].parameters.properties.Parameter2.description | Should -BeExactly 'not supplied'
        $actualFunctionSpec[1].parameters.required.Count | Should -BeExactly 2
        $actualFunctionSpec[1].parameters.required[0] | Should -BeExactly 'Parameter1'
        $actualFunctionSpec[1].parameters.required[1] | Should -BeExactly 'Parameter2'
    }
}