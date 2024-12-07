Describe 'Import-AIProvider' {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PSAI.psd1" -Force
    }
    AfterEach {
        Clear-AIProviderList
    }

    Context 'When importing by provider name' {
        It 'Should import the provider successfully' {
            # Arrange
            $providerName = 'AzureOpenAI'
            $modelNames = 'GPT-4o'
            $apiKey = ConvertTo-SecureString -String 'dummyApiKey' -AsPlainText -Force
            $baseUri = 'https://api.openai.com'

            # Act
            $result = Import-AIProvider -Provider $providerName -ModelNames $modelNames -ApiKey $apiKey -BaseUri $baseUri -PassThru

            # Assert
            $result | Should -Not -BeNullOrEmpty
            $result.Name | Should -Be $providerName
            $result.AIModels.Keys | Should -Contain $modelNames
            $result.ApiKey | Should -Be $apiKey
            $result.BaseUri | Should -Be $baseUri
        }
    }

    Context 'When importing from a file' {
        It 'Should import the provider from the file successfully' {
            # Arrange
            $params = @{
                filePath   = "$PSScriptRoot/../Public/Providers/AzureOpenAI.ps1"
                modelNames = @('Model1', 'Model2')
                apiKey     = ConvertTo-SecureString -String 'dummyApiKey' -AsPlainText -Force
                baseUri    = 'https://api.myprovider.com'
                #Force = $true
            }

            # Act
            $result = Import-AIProvider @params -PassThru

            # Assert
            $result | Should -Not -BeNullOrEmpty
            $result.Name | Should -Be 'AzureOpenAI'
            $result.AIModels.Keys | Should -Contain 'Model1'
            $result.AIModels.Keys | Should -Contain 'Model2'
            $result.GetApiKey() | Should -Be 'dummyApiKey'
            $result.BaseUri | Should -Be 'https://api.myprovider.com'

        }
    }

    Context 'When file does not exist' {
        It 'Should throw an error' {
            # Arrange
            $filePath = "$PSScriptRoot\NonExistentProvider.ps1"

            # Act & Assert
            { Import-AIProvider -FilePath $filePath } | Should -Throw # -ErrorId "File does not exist: $filePath"
        }
    }

    Context 'When importing with Force parameter' {
        It 'Should import the provider and overwrite existing ones' {
            # Arrange
            $providerName = 'AzureOpenAI'
            $modelNames = 'GPT-4o'
            $apiKey = ConvertTo-SecureString -String 'dummyApiKey' -AsPlainText -Force
            $baseUri = 'https://api.openai.com'

            # Act
            $result = Import-AIProvider -Provider $providerName -ModelNames $modelNames -ApiKey $apiKey -BaseUri $baseUri -Force -PassThru

            # Assert
            $result | Should -Not -BeNullOrEmpty
            $result.Name | Should -Be $providerName
            $result.AIModels.Keys | Should -Contain $modelNames
            $result.ApiKey | Should -Be $apiKey
            $result.BaseUri | Should -Be $baseUri
        }
    }
}