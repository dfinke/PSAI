Describe "Test Set-AIKeyInfo" {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PSAI.psd1" -Force
        $Profile = $env:USERPROFILE
        $TestPath = Join-Path $env:TEMP 'TestProfile'
        $env:USERPROFILE = $TestPath 
        New-Item -Path $env:USERPROFILE -ItemType Directory -Force | Out-Null
    }

    It "Update an existing AIKeyInfo" {
        $CurrentInfo = Get-AIKeyInfo
        $CurrentInfo | Should -BeOfType [PSCustomObject]
        $CurrentInfo.Count | Should -Be 4
        Set-AIKeyInfo -AIProvider 'OpenAI' -EnvKeyName 'OpenAISuperKeyEnv' -SecretName 'OpenApiSuperSecret'
        $openai = Get-AIKeyInfo -AIProvider 'OpenAI'
        $openai | Should -BeOfType [PSCustomObject]
        $openai.EnvKeyName | Should -Be 'OpenAISuperKeyEnv'
        $openai.SecretName | Should -Be 'OpenApiSuperSecret'
    }

    It "Set a new AIKeyInfo" {
        Set-AIKeyInfo -AIProvider 'Test' -EnvKeyName 'TestKey' -SecretName 'TestApiKey'
        $test = Get-AIKeyInfo -AIProvider 'Test'
        $test | Should -BeOfType [PSCustomObject]
        $test.EnvKeyName | Should -Be 'TestKey'
        $test.SecretName | Should -Be 'TestApiKey'
    }

    AfterAll {
        $env:USERPROFILE = $Profile
        Remove-Item -Path $TestPath -Recurse -Force
    }
}