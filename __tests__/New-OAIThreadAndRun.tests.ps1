Describe "New-OAIThreadAndRun" -Tag New-OAIThreadAndRun {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PSAI.psd1" -Force
    }

    It "should have these parameters" {
        $actual = Get-Command New-OAIThreadAndRun -ErrorAction SilentlyContinue
     
        $actual | Should -Not -BeNullOrEmpty

        $keyArray = $actual.Parameters.Keys -as [array]

        $keyArray[0] | Should -BeExactly "AssistantId"
        $keyArray[1] | Should -BeExactly "Thread"
        $keyArray[2] | Should -BeExactly "Model"
        $keyArray[3] | Should -BeExactly "Instructions"
        $keyArray[4] | Should -BeExactly "Tools"
        $keyArray[5] | Should -BeExactly "ToolResources"
        $keyArray[6] | Should -BeExactly "Metadata"
        $keyArray[7] | Should -BeExactly "Temperature"
        $keyArray[8] | Should -BeExactly "TopP"
        $keyArray[9] | Should -BeExactly "Stress"
        $keyArray[10] | Should -BeExactly "MaxPromptTokens"
        $keyArray[11] | Should -BeExactly "MaxCompletionTokens"
        $keyArray[12] | Should -BeExactly "TruncationStrategy"
        $keyArray[13] | Should -BeExactly "ToolChoices"
        $keyArray[14] | Should -BeExactly "ResponseFormat"


        $validValues = $actual.Parameters["ResponseFormat"].Attributes.ValidValues
        $validValues | Should -Be @("auto", "json", "text")        
        
        $actual.Parameters.Temperature.Attributes.ScriptBlock | Should -BeExactly ' $_ -ge 0 -and $_ -le 2 '
        $actual.Parameters.TopP.Attributes.ScriptBlock | Should -BeExactly ' $_ -ge 0 -and $_ -le 1 '
    }
}