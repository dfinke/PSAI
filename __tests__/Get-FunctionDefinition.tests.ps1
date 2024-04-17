Describe "Get-FunctionDefinition" -Tag Get-FunctionDefinition {
    BeforeAll {

        Import-Module "$PSScriptRoot/../PSAI.psd1" -Force

    
        function New-User {
            param(
                $firstName,
                $lastName
            )

            $firstName + ' ' + $lastName
        }
    }

    It 'Test if it Get-FunctionDefinition exists' {
        $actual = Get-Command Get-FunctionDefinition -ErrorAction SilentlyContinue

        $actual | Should -Not -BeNullOrEmpty
    }

    It 'Test if Get-FunctionDefinition has the correct parameters ' {
        $actual = Get-Command Get-FunctionDefinition -ErrorAction SilentlyContinue

        $actual.Parameters.ContainsKey('functionInfo') | Should -Be $true
    }

    It 'Test if Get-FunctionDefinition returns the correct definition' {
        $functionInfo = Get-Command New-User
        $actual = Get-FunctionDefinition $functionInfo

        #         $actual | Should -Be '
        # function New-User {

        #     param(
        #         $firstName,
        #         $lastName
        #     )

        #     $firstName + ' ' + $lastName
        # }'
        $lines = $actual -split '\r?\n'
        $lines[0] | Should -BeNullOrEmpty
        $lines[1] | Should -Be 'function New-User {'
        $lines[2] | Should -BeNullOrEmpty
        $lines[3] | Should -Be '            param('
        $lines[4] | Should -Be '                $firstName,'
        $lines[5] | Should -Be '                $lastName'
        $lines[6] | Should -Be '            )'
        $lines[7] | Should -BeNullOrEmpty
        $lines[8] | Should -Be '            $firstName + '' '' + $lastName'
        $lines[9] | Should -Be '        '
        $lines[10] | Should -Be '}'        
    }

}