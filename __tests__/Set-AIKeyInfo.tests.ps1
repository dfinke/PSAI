Describe "Test Set-AIKeyInfo" {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PSAI.psd1" -Force
        $backup = Get-AIKeyInfo -AsHashTable
        $path = Join-Path $(Split-Path $PSScriptRoot) 'AIKeyInfo.json'
        Remove-Item $path -ErrorAction SilentlyContinue
    }

    It "Update an existing AIKeyInfo" {
        $CurrentInfo = Get-AIKeyInfo
        $CurrentInfo | Should -BeOfType [PSCustomObject]
        $CurrentInfo.Count | Should -Be 5
        Set-AIKeyInfo -AIProvider 'OpenAI' -EnvKeyName 'OpenAISuperKeyEnv' -SecretName 'OpenApiSuperSecret'
        $openai = Get-AIKeyInfo -AIProvider 'OpenAI'
        $openai | Should -BeOfType [PSCustomObject]
        $openai.EnvKeyName | Should -Be 'OpenAISuperKeyEnv'
        $openai.SecretName | Should -Be 'OpenApiSuperSecret'
    }
    it "Set-AIKeyInfo a Default Provider" {
        Set-AIKeyInfo -AIProvider 'OpenAI' -Default
        $OpenAI = Get-AIKeyInfo -AIProvider 'OpenAI'
        $OpenAI.Default | Should -Be $True
    }
    it "Set a new Default Provider should remove the old Default Provider" {
        Set-AIKeyInfo -AIProvider 'OpenAI' -Default
        Set-AIKeyInfo -AIProvider 'Gemini' -Default
        $OpenAI = Get-AIKeyInfo -AIProvider 'OpenAI'
        $Gemini = Get-AIKeyInfo -AIProvider 'Gemini'
        $OpenAI.Default | Should -Be $False
        $Gemini.Default | Should -Be $True
    }

    It "Set a new AIKeyInfo" {
        Set-AIKeyInfo -AIProvider 'Test' -EnvKeyName 'TestKey' -SecretName 'TestApiKey'
        $test = Get-AIKeyInfo -AIProvider 'Test'
        $test | Should -BeOfType [PSCustomObject]
        $test.EnvKeyName | Should -Be 'TestKey'
        $test.SecretName | Should -Be 'TestApiKey'
    }
     AfterAll {
        $backup | ConvertTo-Json | Out-File $path
     }
}