Describe 'New-OAIAssistant' -Tag New-OAIAssistant {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PSAI.psd1" -Force
    }

    It 'should have these parameters ' {
        $actual = Get-Command New-OAIAssistant -ErrorAction SilentlyContinue
     
        $actual | Should -Not -BeNullOrEmpty

        $keyArray = $actual.Parameters.Keys -as [array]

        $keyArray[0] | Should -BeExactly 'Name'
        $keyArray[1] | Should -BeExactly 'Instructions'
        $keyArray[2] | Should -BeExactly 'Description'
        $keyArray[3] | Should -BeExactly 'Tools'
        $keyArray[4] | Should -BeExactly 'ToolResources'
        $keyArray[5] | Should -BeExactly 'Model'
        $keyArray[6] | Should -BeExactly 'Metadata'
        $keyArray[7] | Should -BeExactly 'Temperature'
        $keyArray[8] | Should -BeExactly 'TopP'
        $keyArray[9] | Should -BeExactly 'ResponseFormat'

        $validValues = $actual.Parameters['ResponseFormat'].Attributes.ValidValues
        $validValues | Should -Be @('auto', 'json', 'text')        
        
        $actual.Parameters.Temperature.Attributes.ScriptBlock | Should -BeExactly ' $_ -ge 0 -and $_ -le 2 '
        $actual.Parameters.TopP.Attributes.ScriptBlock | Should -BeExactly ' $_ -ge 0 -and $_ -le 1 '
    }
}