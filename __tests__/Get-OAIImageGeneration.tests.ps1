Describe "Get-OAIImageGeneration" -Tag Get-OAIImageGeneration {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PSAI.psd1" -Force
    }

    It "should have these parameters" {
        $actual = Get-Command Get-OAIImageGeneration -ErrorAction SilentlyContinue
     
        $actual | Should -Not -BeNullOrEmpty

        $keyArray = $actual.Parameters.Keys -as [array]

        $keyArray[0] | Should -BeExactly 'Prompt'
        $keyArray[1] | Should -BeExactly 'Model'
        $keyArray[2] | Should -BeExactly 'N'
        $keyArray[3] | Should -BeExactly 'Quality'
        $keyArray[4] | Should -BeExactly 'ResponseFormat'
        $keyArray[5] | Should -BeExactly 'Size'
        $keyArray[6] | Should -BeExactly 'Style'
        $keyArray[7] | Should -BeExactly 'User'

        $actual.Parameters.Prompt.Attributes.Mandatory | Should -Be $true

        $validValues = $actual.Parameters['Model'].Attributes.ValidValues
        $validValues | Should -Be @('dall-e-2', 'dall-e-3')

        $validValues = $actual.Parameters['Quality'].Attributes.ValidValues
        $validValues | Should -Be @('standard', 'hd')

        $validValues = $actual.Parameters['Size'].Attributes.ValidValues
        $validValues | Should -Be @('256x256', '512x512', '1024x1024', '1024x1024', '1792x1024', '1024x1792')
        
        $validValues = $actual.Parameters['ResponseFormat'].Attributes.ValidValues
        $validValues | Should -Be @('url', 'b64_json')
    }
}