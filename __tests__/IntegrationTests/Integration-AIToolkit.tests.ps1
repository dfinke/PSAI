BeforeDiscovery {
    if ($env:GITHUB_ACTIONS -eq 'true') {
        $info = $null
    } else{
        $info = (netstat -an | findstr "127.0.0.1:5272")
    }    
}

Describe "Test chat endpoints" -Skip:($null -eq $info) {
    BeforeAll {
        Import-Module "$(Split-Path $(Split-Path $PSScriptRoot))/PSAI.psd1" -Force
        $params = @{
                Provider = 'AIToolkit'
            }
        Import-AIProvider @params
    }
Context "Invoke-OAIChatCompletion" {
        It "Invoke-OAIChatCompletion generates an answer" -Skip:($null -eq $info) {
            $Prompt = "What is the capitol of France"
            $Message = New-OAIChatMessage -Role user -Content $Prompt
            $Answer = Invoke-OAIChatCompletion -Message $Message
            $Answer | Should -Not -BeNullOrEmpty
            $Answer | Should -BeOfType [String]
            $Answer | Should -Match "Paris"
        }
        It "Moniker syntax generates an answer" -Skip:($null -eq $info) {
            $Model = Get-AIModel
            $Prompt = "What is the capitol of Italy"
            $model.Provider.Name | Should -Be 'AIToolkit'
            $Answer = $Model.Chat($Prompt)
            $Answer | Should -Not -BeNullOrEmpty
            $Answer | Should -BeOfType [String]
            $Answer | Should -Match "Rome"
        }
    }
}