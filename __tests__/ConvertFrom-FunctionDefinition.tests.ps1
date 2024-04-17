Describe 'Convert To Function Spec' -Tags ConvertToFunctionSpec {

    BeforeAll {
        Import-Module "$PSScriptRoot/../PowerShellAIAssistant.psd1" -Force
    
        function New-User {}
        function Get-User {}
        function Update-User {}
        function Remove-User {}
    }

    It 'Test if it ConvertFrom-FunctionDefinition exists' {
        $actual = Get-Command ConvertFrom-FunctionDefinition -ErrorAction SilentlyContinue

        $actual | Should -Not -BeNullOrEmpty
    }

    It 'Test ConvertFrom-Definition has correct parameters' {
        $actual = Get-Command ConvertFrom-FunctionDefinition -ErrorAction SilentlyContinue

        $actual.Parameters.Keys | Should -Be @('FunctionInfo')

        $actual.Parameters['FunctionInfo'].ParameterType.Name | Should -Be 'CommandInfo[]'
    }

    It 'Test ConvertFrom-FunctionDefinition returns a function spec' {

        $functionInfo = @('New-User') | ForEach-Object { Get-Command $_ }
        
        $actual = ConvertFrom-FunctionDefinition $functionInfo
        $actual | Should -Not -BeNullOrEmpty
        $actual.GetType().Name | Should -Be 'OrderedDictionary'

        $actual.Keys.Count | Should -Be 3
     
        $actual["name"] | Should -BeExactly 'New-User'
        $actual["description"] | Should -BeExactly 'not supplied'
        
        $actual["parameters"].Keys.Count | Should -Be 3

        $actual["parameters"]["type"] | Should -BeExactly 'object'
        $actual["parameters"]["properties"].Keys.Count | Should -Be 0

        $actual["parameters"]["required"].GetType().Name | Should -Be 'Object[]'
        $actual["parameters"]["required"].Count | Should -Be 0
    }

    It 'Test handles mutiple functions' {
        $functionInfo = 'New-User', 'Get-User', 'Update-User', 'Remove-User' | ForEach-Object { Get-Command $_ }

        $actual = ConvertFrom-FunctionDefinition $functionInfo
        $actual | Should -Not -BeNullOrEmpty
        $actual.GetType().Name | Should -Be 'Object[]'

        $actual.Keys.Count | Should -Be 12

        $actual[0]["name"] | Should -BeExactly 'New-User'
        $actual[0].Keys.Count | Should -Be 3

        $actual[1]["name"] | Should -BeExactly 'Get-User'
        $actual[0].Keys.Count | Should -Be 3
        
        $actual[2]["name"] | Should -BeExactly 'Update-User'
        $actual[0].Keys.Count | Should -Be 3
        
        $actual[3]["name"] | Should -BeExactly 'Remove-User'
        $actual[0].Keys.Count | Should -Be 3
    }    
}