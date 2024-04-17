Describe 'Format-OAIFunctionCall' -Tags 'Format-OAIFunctionCall' {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PSAI.psd1" -Force
    }

    It 'should have these parameters ' {
        $actual = Get-Command Format-OAIFunctionCall -ErrorAction SilentlyContinue
     
        $actual | Should -Not -BeNullOrEmpty
        $actual.Parameters.Keys.Contains('FunctionSpec') | Should -Be $true
    }

    It "Converts a string to a hashtable" {
        $functionSpec = '{"Name": "TestFunction", "Parameters": ["Param1", "Param2"]}'
        
        $actual = Format-OAIFunctionCall -FunctionSpec $functionSpec
        
        $actual.type | Should -Be "function"
        $actual.function.Name | Should -Be "TestFunction"
        $actual.function.Parameters | Should -Be @("Param1", "Param2")
    }
    
    It "Returns a hashtable as is" {
        $functionSpec = @{
            Name       = "TestFunction"
            Parameters = @("Param1", "Param2")
        }
        
        $actual = Format-OAIFunctionCall -FunctionSpec $functionSpec
        
        $actual.type | Should -Be "function"
        $actual.function.Name | Should -Be "TestFunction"
        $actual.function.Parameters | Should -Be @("Param1", "Param2")
    }
    
    It "Converts a FunctionInfo object to a hashtable" {
        function TestFunction {
            param(
                $Param1,
                $Param2
            )
        }

        $functionSpec = Get-Command "TestFunction"
        
        $actual = Format-OAIFunctionCall -FunctionSpec $functionSpec
        
        $actual.type | Should -Be "function"
        $actual.function.Name | Should -Be "TestFunction"
        
        $actual.function.parameters.properties.Contains("Param1") | Should -Be $true
        $actual.function.parameters.properties.Contains("Param2") | Should -Be $true
    }
    
    It "Throws an error for an invalid FunctionSpec type" {
        $functionSpec = 123
        
        { Format-OAIFunctionCall -FunctionSpec $functionSpec } | Should -Throw "Invalid FunctionSpec type: $($functionSpec.GetType().Name). Must be string, hashtable, or FunctionInfo."
    }

    It "Throws an error for an invalid JSON string" {
        $functionSpec = 'bad json'
        
        { Format-OAIFunctionCall -FunctionSpec $functionSpec } | Should -Throw "Invalid JSON string: $functionSpec"
    }
}