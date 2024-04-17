Describe "Enable-OAICodeInterpreter" -Tag Enable-OAICodeInterpreter {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PowerShellAIAssistant.psd1" -Force
    }

    It "should have these parameters " {
        $actual = Get-Command Enable-OAICodeInterpreter -ErrorAction SilentlyContinue
     
        $actual | Should -Not -BeNullOrEmpty
    }

    It "should return a hashtable with the 'type' property set to 'code_interpreter' " {
        $actual = Enable-OAICodeInterpreter

        $actual | Should -Not -BeNullOrEmpty
        $actual.Keys.Contains('type') | Should -BeExactly $true
        $actual['type'] | Should -BeExactly 'code_interpreter'
    }
}