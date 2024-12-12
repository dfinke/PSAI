Describe "New-AIProviderList" {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PSAI.psd1" -Force
    }

    It "should create a new provider list" {
        New-AIProviderList -Force
        Get-AIProviderList | Should -Not -BeNullOrEmpty
        (Get-AIProviderList ).pstypenames[0]| Should -Be 'AIProviderList'
    }

    It "should not overwrite existing provider list without -Force" {
        Import-AIProvider -Provider "OpenAI"
        $initialList = Get-AIProviderList 
        New-AIProviderList
        $script:ProviderList | Should -Be $initialList
    }

    It "should overwrite existing provider list with -Force" {
        $initialList = Get-AIProviderList 
        New-AIProviderList -Force
        $script:ProviderList | Should -Not -Be $initialList
    }

    It "should return the provider list object with -PassThru" {
        $result = New-AIProviderList -Force -PassThru
        $result | Should -Not -BeNullOrEmpty
        $result.pstypenames[0]| Should -Be 'AIProviderList'
    }

    It "should add a provider to the list" {
        New-AIProviderList -Force
        New-AIProvider -Name "TestProvider"
        (Get-AIProviderList).Providers.Keys | Should -Contain "TestProvider"
    }

    It "should remove a provider from the list" {
        New-AIProviderList -Force
        New-AIProvider -Name "TestProvider"
        $AIProviderList = Get-AIProviderList
        $AIProviderList.Remove("TestProvider")
        $AIProviderList.Providers.Keys | Should -Not -Contain "TestProvider"
    }

    It "should set a default provider" {
        New-AIProviderList -Force
        New-AIProvider -Name "OpenAI"
        $provider = [PSCustomObject]@{ Name = "TestProvider" }
        $AIProviderList = Get-AIProviderList
        $AIProviderList.Add($provider, $true)
        $AIProviderList.DefaultProvider | Should -Be "TestProvider"
    }

    It "should get a provider by name" {
        New-AIProviderList -Force
        $provider = [PSCustomObject]@{ Name = "TestProvider" }
        $AIProviderList = Get-AIProviderList
        $AIProviderList.Add($provider)
        $result = $AIProviderList.Get("TestProvider")
        $result.Name | Should -Be "TestProvider"
    }

    It "should get the default provider" {
        $AIProviderList = New-AIProviderList -Force -PassThru
        New-AIProvider -Name "TestProvider"
        New-AIProvider -Name "TestProvider2"
        $result = $AIProviderList.GetDefault()
        $result.Name | Should -Be "TestProvider"
    }
}