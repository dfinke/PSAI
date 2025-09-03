Describe "Register-Tool" -Tag Register-Tool {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PSAI.psd1" -Force
    }

    It "should have these parameters" {
        $actual = Get-Command Register-Tool -ErrorAction SilentlyContinue
     
        $actual | Should -Not -BeNullOrEmpty

        $keyArray = $actual.Parameters.Keys -as [array]

        $keyArray[0] | Should -BeExactly 'FunctionName'
        $keyArray[1] | Should -BeExactly 'ParameterSet'
        $keyArray[2] | Should -BeExactly 'Strict'

        $actual.Parameters.Strict.SwitchParameter | Should -Be $true
    }

    # it "CalculatorTool should register correctly" {
    #     $actual = New-CalculatorTool

    #     $actual | Should -Not -BeNullOrEmpty
    #     $actual.Count | Should -Be 8
    # }

    it "Get-ChildItem should register correctly" {
        $actual = Register-Tool "Get-ChildItem"

        $actual | Should -Not -BeNullOrEmpty
        $actual.function.parameters.properties.keys[0] | Should -Be "Path"
    }

    it "Get-ChildItem should register ParameterSet 2 correctly" {
        $actual = Register-Tool "Get-ChildItem" -ParameterSet 1

        $actual | Should -Not -BeNullOrEmpty
        $actual.function.parameters.properties.keys[0] | Should -Be "LiteralPath"
    }
}