Describe "Read-PSAISkill" -Tag Read-PSAISkill {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PSAI.psd1" -Force
        
        # Create a temporary skill file for testing
        $script:testSkillFile = Join-Path $TestDrive "test-skill.md"
        
        $testContent = @"
---
name: Test Skill
description: A test skill for unit testing.
---

# Test Skill

## Quick start

This is a test skill with some example content.

``````powershell
Get-Content -Path "test.txt"
``````

## More information

Additional details about using this skill.
"@
        
        Set-Content -Path $script:testSkillFile -Value $testContent
    }
    
    It "should have these parameters" {
        $actual = Get-Command Read-PSAISkill -ErrorAction SilentlyContinue
     
        $actual | Should -Not -BeNullOrEmpty

        $keyArray = $actual.Parameters.Keys -as [array]

        $keyArray | Should -Contain 'Fullname'
        
        $actual.Parameters.Fullname.Attributes.Mandatory | Should -Be $true
    }
    
    It "should read file content as raw string" {
        $result = Read-PSAISkill -Fullname $script:testSkillFile
        
        $result | Should -Not -BeNullOrEmpty
        $result | Should -BeOfType [string]
        $result | Should -Match "Test Skill"
        $result | Should -Match "Quick start"
    }
    
    It "should include frontmatter in the output" {
        $result = Read-PSAISkill -Fullname $script:testSkillFile
        
        $result | Should -Match "---"
        $result | Should -Match "name: Test Skill"
        $result | Should -Match "description: A test skill for unit testing."
    }
    
    It "should handle non-existent file with error" {
        { Read-PSAISkill -Fullname "C:\NonExistent\File.md" -ErrorAction Stop } | Should -Throw
    }
    
    It "should read complete file including code blocks" {
        $result = Read-PSAISkill -Fullname $script:testSkillFile
        
        $result | Should -Match "Get-Content -Path"
        $result | Should -Match "More information"
    }
}
