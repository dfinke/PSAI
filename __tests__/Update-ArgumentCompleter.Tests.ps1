BeforeAll {
    Import-Module "$PSScriptRoot/../PSAI.psd1" -Force
}

Describe "Update-ArgumentCompleter" {
    It 'should have these parameters' {
        $actual = Get-Command Update-ArgumentCompleter -ErrorAction SilentlyContinue
        $keyArray = $actual.Parameters.Keys -as [array]
        $actual | Should -Not -BeNullOrEmpty
        $keyArray[0] | Should -BeExactly 'CommandObject'
        $keyArray[1] | Should -BeExactly 'Provider'
    }
}