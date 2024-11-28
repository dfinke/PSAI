Describe "New-AIModel" {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PSAI.psd1" -Force
        $script:Provider = "OpenAI"
        $script:Secret = "1" | ConvertTo-SecureString -AsPlainText -Force
        Import-AIProvider -Provider $script:Provider -ApiKey $script:Secret
    }

    It "Should create a new AI model with default parameters" {
        $result = New-AIModel -ProviderName $script:Provider -Name TestModel -PassThru
        $result | Should -Not -BeNullOrEmpty
        $result.pstypenames[0] | Should -Be "AIModel"
    }

    It "Should create a new AI model with specified parameters" {
        $params = @{
            Name = 'MyModel'
            ProviderName = $script:Provider 
            ModelFunctions = @{
                'MyFunction' = {
                    param($Message)
                    return "Hello, $Message"
                }
            }
            PassThru = $true
        }
        $result = New-AIModel @params
        $result.Name | Should -Be 'MyModel'
        $result.MyFunction("PSAI") | Should -Be "Hello, PSAI"
    }

}