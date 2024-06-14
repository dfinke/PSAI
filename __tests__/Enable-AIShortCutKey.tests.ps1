Describe "Enable-AIShortCutKey" -Tag Enable-AIShortCutKey {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PSAI.psd1" -Force
    }

    It "should have these parameters " {
        $actual = Get-Command Enable-AIShortCutKey -ErrorAction SilentlyContinue
     
        $actual | Should -Not -BeNullOrEmpty

        $keyArray = $actual.Parameters.Keys -as [array]

        $keyArray[0] | Should -BeExactly 'ShortcutKey'
    }
}