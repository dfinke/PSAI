Describe "New-AIProvider" {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PSAI.psd1" -Force
    }

    It "Should create a new AI provider with valid parameters" {
        $params = @{
            Name = "TestProvider"
            ApiKey = "12345" | ConvertTo-SecureString -AsPlainText -Force
        }
        $result = New-AIProvider @params -PassThru
        $result | Should -Not -BeNullOrEmpty
        $result.Name | Should -Be "TestProvider"
        $result.GetApiKey() | Should -Be "12345"
    }

    It "Should have a default model" {
        $params = @{
            Name = "MyModel"
            ApiKey = "12345" | ConvertTo-SecureString -AsPlainText -Force
            DefaultModel = "MyModel"
        }
        $result = New-AIProvider @params -PassThru
        $result.GetDefaultModel() | Should -Be "MyModel"
    }

}