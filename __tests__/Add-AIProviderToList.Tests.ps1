Describe "Add-AIProviderToList" {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PSAI.psd1" -Force
    }

    It "should add a new provider to the list" {
        $provider = [PSCustomObject]@{ Name = "NewProvider"; APIKey = "12345" }
        Add-AIProviderToList -Provider $provider

        $providerList = Get-AIProviderList
        $providerList.Providers.ContainsKey("NewProvider") | Should -Be $true
    }

    It "should mark the provider as default if -Default is specified" {
        $provider = [PSCustomObject]@{ Name = "NewProviderDefault"; APIKey = "12345" }
        Add-AIProviderToList -Provider $provider -Default

        (Get-AIProvider).Name | Should -Be "NewProviderDefault"
    }

    It "should overwrite an existing provider if -Force is specified" {
        $provider = [PSCustomObject]@{ Name = "ExistingProvider"; APIKey = "12345" }
        $providerList = Get-AIProviderList
        $providerList.Providers["ExistingProvider"] = $provider

        $newProvider = [PSCustomObject]@{ Name = "ExistingProvider"; APIKey = "67890" }
        Add-AIProviderToList -Provider $newProvider -Force

        $providerList.Providers["ExistingProvider"].APIKey | Should -Be "67890"
    }

    It "should throw an error if provider already exists and -Force is not specified" {
        $provider = [PSCustomObject]@{ Name = "ExistingProvider"; APIKey = "12345" }
        $providerList = Get-AIProviderList
        $providerList.Providers["ExistingProvider"] = $provider

        $newProvider = [PSCustomObject]@{ Name = "ExistingProvider"; APIKey = "67890" }
        { Add-AIProviderToList -Provider $newProvider } | Should -Throw
    }
}