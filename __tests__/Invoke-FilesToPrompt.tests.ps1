Describe "Invoke-FilesToPrompt" -Tag Invoke-FilesToPrompt {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PSAI.psd1" -Force
    }

    It "should have these parameters " {
        $actual = Get-Command Invoke-FilesToPrompt -ErrorAction SilentlyContinue
     
        $actual | Should -Not -BeNullOrEmpty

        $actual.Parameters.Keys.Contains("Path") | Should -Be $true
    }
}