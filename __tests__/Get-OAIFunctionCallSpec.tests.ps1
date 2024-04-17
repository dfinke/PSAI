Describe "Get-OAIFunctionCallSpec" -Tag Get-OAIFunctionCallSpec {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PSAI.psd1" -Force
    }

    It "Test if it Get-OAIFunctionCallSpec exists" {
        $actual = Get-Command Get-OAIFunctionCallSpec -ErrorAction SilentlyContinue
        $actual | Should -Not -BeNullOrEmpty

        $actual.Parameters.Keys.Contains('functionInfo') | Should -Be $true
        $actual.Parameters['functionInfo'].ParameterType.FullName | Should -Be 'System.Management.Automation.FunctionInfo'        
    }

    It "Test if Get-OAIFunctionCallSpec is null" {
        $actual = Get-OAIFunctionCallSpec
        $actual | Should -BeNullOrEmpty
    }

    It "Test Get-OAIFunctionCallSpec returns function spec" {
        function DoTest {
            param(
                [string]$name
            )
            Write-Host "Hello $name"
        }
        
        $actual = Get-OAIFunctionCallSpec -functionInfo (Get-Command DoTest)
        $actual | Should -Not -BeNullOrEmpty

        $actual.Contains('function') | Should -Be $true
        $actual.function.name | Should -Be 'DoTest'
        $actual.function.parameters.type | Should -Be 'object'
        $actual.function.parameters.properties.name.type | Should -Be 'string'
        $actual.function.parameters.properties.name.description | Should -Be 'not supplied'
        $actual.function.parameters.required | Should -Be @('name')
        $actual.function.description | Should -Be 'not supplied'

        $actual.Contains('type') | Should -Be $true
        $actual.type | Should -Be 'function'

        Get-ChildItem function:dotest | Remove-Item
    }
}