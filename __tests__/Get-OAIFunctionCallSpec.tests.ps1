Describe "Get-OAIFunctionCallSpec" -Tag Get-OAIFunctionCallSpec {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PSAI.psd1" -Force
    }

    It "Test if it Get-OAIFunctionCallSpec exists" {
        $actual = Get-Command Get-OAIFunctionCallSpec -ErrorAction SilentlyContinue
        $actual | Should -Not -BeNullOrEmpty

        $keyArray = $actual.Parameters.Keys -as [array]

        $keyArray[0] | Should -BeExactly 'CmdletName'
        $keyArray[1] | Should -BeExactly 'Strict'

        $actual.Parameters['Strict'].SwitchParameter | Should -Be $true
        
        # $actual.Parameters['functionInfo'].ParameterType.FullName | Should -Be 'System.Management.Automation.FunctionInfo'

        $actual.Parameters.Strict.Attributes.Mandatory | Should -Be $false
    }

    It "Test if Get-OAIFunctionCallSpec is null if function does not exist" {
        $actual = Get-OAIFunctionCallSpec -CmdletName NotExisting
        $actual | Should -BeNullOrEmpty
    }

    It "Test Get-OAIFunctionCallSpec returns function spec" -skip {
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

    It "Test Get-OAIFunctionCallSpec sets string" -Skip {
        function DoTest {
            <#
            .DESCRIPTION
            This is a test function
            #>
            param(
                [string]$name
            )
            Write-Host "Hello $name"
        }

        $actual = Get-OAIFunctionCallSpec -functionInfo (Get-Command DoTest) -Strict
        $actual | Should -Not -BeNullOrEmpty

        $actual.function.strict | Should -Be $true
        $actual.function.parameters.additionalProperties | Should -Be $false
        
        $actual.function.name | Should -Be 'DoTest'
        $actual.function.description | Should -Be 'not supplied'        
        $actual.function.parameters.properties.name | Should -Not -BeNullOrEmpty
        $actual.function.parameters.properties.name.type | Should -Be 'string'
        $actual.function.parameters.properties.name.description | Should -Be 'not supplied'

        Get-ChildItem function:dotest | Remove-Item
    }
}