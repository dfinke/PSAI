Describe "Get-AIModel" {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PSAI.psd1" -Force
        $script:Provider = "OpenAI"
        $script:Secret = "1" | ConvertTo-SecureString -AsPlainText -Force
        Import-AIProvider -Provider $script:Provider -ApiKey $script:Secret -ModelNames 'gpt-4o-mini', 'gpt-4o'
    }

    It "should retrieve a specific model from a specified provider" {
        $model = Get-AIModel -ProviderName "OpenAI" -ModelName "gpt-4o"
        $model.Name | Should -Be "gpt-4o"
    }

    It "should retrieve all models from a specified provider" {
        $models = Get-AIModel -ProviderName "OpenAI" -All
        $models.Name | Should -Contain "gpt-4o-mini"
        $models.Name  | Should -Contain "gpt-4o"
    }

    It "should retrieve the default model from the default provider" {
        $model = Get-AIModel
        $model.Name | Should -Be "gpt-4o-mini"
    }

    It "should retrieve all models from the default provider" {
        $provider = [PSCustomObject]@{ Name = "DefaultProvider"; AIModels = @{ "Model1" = "ModelData1"; "Model2" = "ModelData2" } }
        $providerList = Get-AIProviderList
        $providerList.Providers["DefaultProvider"] = $provider

        $defaultProvider = Get-AIProvider
        $defaultProvider.Name = "DefaultProvider"

        $models = Get-AIModel -All
        $models | Should -Contain "ModelData1"
        $models | Should -Contain "ModelData2"
    }
}