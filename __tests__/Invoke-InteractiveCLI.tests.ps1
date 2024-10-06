Describe "Invoke-InteractiveCLI" -Tag Invoke-InteractiveCLI {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PSAI.psd1" -Force
    }

    It "should have these parameters" {
        $actual = Get-Command Invoke-InteractiveCLI -ErrorAction SilentlyContinue
     
        $actual | Should -Not -BeNullOrEmpty

        $keyArray = $actual.Parameters.Keys -as [array]

        $keyArray[0] | Should -BeExactly 'Agent'
        $keyArray[1] | Should -BeExactly 'Message'
        $keyArray[2] | Should -BeExactly 'User'
        $keyArray[3] | Should -BeExactly 'Emoji'
        $keyArray[4] | Should -BeExactly 'ExitOn'
    }
}