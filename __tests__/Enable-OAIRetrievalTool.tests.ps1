Describe "Enable-OAIFileSearchTool" -Tag Enable-OAIFileSearchTool {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PSAI.psd1" -Force
    }

    It "should have these parameters " {
        $actual = Get-Command Enable-OAIFileSearchTool -ErrorAction SilentlyContinue
     
        $actual | Should -Not -BeNullOrEmpty
    }

    It "should return a hashtable with the 'type' property set to 'retrieval' " {
        $actual = Enable-OAIFileSearchTool

        $actual | Should -Not -BeNullOrEmpty
        $actual.Keys.Contains('type') | Should -BeExactly $true
        $actual['type'] | Should -BeExactly 'file_search'
    }
}