Describe "Enable-OAIRetrievalTool" -Tag Enable-OAIRetrievalTool {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PowerShellAIAssistant.psd1" -Force
    }

    It "should have these parameters " {
        $actual = Get-Command Enable-OAIRetrievalTool -ErrorAction SilentlyContinue
     
        $actual | Should -Not -BeNullOrEmpty
    }

    It "should return a hashtable with the 'type' property set to 'retrieval' " {
        $actual = Enable-OAIRetrievalTool

        $actual | Should -Not -BeNullOrEmpty
        $actual.Keys.Contains('type') | Should -BeExactly $true
        $actual['type'] | Should -BeExactly 'retrieval'
    }
}