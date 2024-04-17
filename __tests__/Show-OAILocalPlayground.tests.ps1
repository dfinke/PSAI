Describe "Show-OAILocalPlayground" -Tag Show-OAILocalPlayground {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PowerShellAIAssistant.psd1" -Force
    }

    It "should have these parameters" {
        $actual = Get-Command Show-OAILocalPlayground -ErrorAction SilentlyContinue
     
        $actual | Should -Not -BeNullOrEmpty

        $actual.Parameters.Keys.Contains('Port') | Should -Be $true

        $actual.Parameters.Keys.Contains('Threads') | Should -Be $true
        $actual.Parameters.Keys.Contains('DisableLaunch') | Should -Be $true
        $actual.Parameters.DisableLaunch.SwitchParameter | Should -Be $true
    }
}