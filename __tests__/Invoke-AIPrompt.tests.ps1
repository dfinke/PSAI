Describe "Invoke-AIPrompt" -Tag Invoke-AIPrompt {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PSAI.psd1" -Force
    }

    It "should have these parameters" {
        $actual = Get-Command Invoke-AIPrompt -ErrorAction SilentlyContinue
     
        $actual | Should -Not -BeNullOrEmpty

        $keyArray = $actual.Parameters.Keys -as [array]

        $keyArray[0] | Should -BeExactly 'Prompt'
        $keyArray[1] | Should -BeExactly 'Data'
        $keyArray[2] | Should -BeExactly 'Model'
        $keyArray[3] | Should -BeExactly 'UsePowerShellPersona'

        $actual.Parameters['UsePowerShellPersona'].SwitchParameter | Should -Be $true
    }
}
