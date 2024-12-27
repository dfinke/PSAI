Describe "Add-AIProviderToList" {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PSAI.psd1" -Force
    }

    It "should add a new provider to the list" {
        $provider = [PSCustomObject]@{ Name = "NewProvider"; APIKey = "12345" }
        Add-AIProviderToList -Provider $provider

        Get-AIProvider -Name $provide.Name | Should -Not -BeNullOrEmpty
    }

    It "should mark the provider as default if -Default is specified" {
        $provider = [PSCustomObject]@{ Name = "NewProviderDefault"; APIKey = "12345" }
        Add-AIProviderToList -Provider $provider -Default

        (Get-AIProvider -Name $provider.Name).Name | Should -Be "NewProviderDefault"
    }

    It "should overwrite an existing provider if -Force is specified" {
        $provider = [PSCustomObject]@{ Name = "ExistingProvider"; APIKey = "12345" }
        Add-AIProviderToList -Provider $provider

        $newProvider = [PSCustomObject]@{ Name = "ExistingProvider"; APIKey = "67890" }
        Add-AIProviderToList -Provider $newProvider -Force

        (Get-AIProvider -Name $provider.Name).APIKey | Should -Be $newProvider.APIKey
    }
}