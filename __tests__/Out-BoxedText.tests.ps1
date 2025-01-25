Describe 'Out-BoxedText' -Tag Out-BoxedText {
    BeforeAll {
        Import-Module "$PSScriptRoot/../Public/Out-BoxedText.ps1" -Force
    }

    It 'should have these parameters' {
        $actual = Get-Command Out-BoxedText -ErrorAction SilentlyContinue
     
        $actual | Should -Not -BeNullOrEmpty

        $keyArray = $actual.Parameters.Keys -as [array]

        $keyArray[0] | Should -BeExactly 'Text'
        $keyArray[1] | Should -BeExactly 'Title'
        $keyArray[2] | Should -BeExactly 'BoxColor'
        $keyArray[3] | Should -BeExactly 'TextColor'
    }

    It 'should have Text parameter as mandatory' {
        $actual = Get-Command Out-BoxedText -ErrorAction SilentlyContinue
        $actual.Parameters['Text'].Attributes.Mandatory | Should -Be $true
    }
}
