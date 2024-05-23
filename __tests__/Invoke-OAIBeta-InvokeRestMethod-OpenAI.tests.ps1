Describe 'Test Invoke-OAIBeta InvokeRestMethod OpenAI Params' -Tag Invoke-OAIBetaParams-OpenAI {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PSAI.psd1" -Force
        . "$PSScriptRoot/PesterMatchHashtable.ps1"

        $script:expectedBaseUrl = "https://api.openai.com/v1"
        $script:expectedHeaders = @{
            "Content-Type"  = "application/json"
            "OpenAI-Beta"   = "assistants=v2"
            "Authorization" = "Bearer "
        }

        function Test-UnitTestingData {
            param(
                [hashtable]$UnitTestingData,
                [hashtable]$ExpectedUnitTestingData
            )

            foreach ($entry in $ExpectedUnitTestingData.GetEnumerator()) {
                if ($entry.Value -is [hashtable]) {
                    if ($entry.Key -eq 'Headers') {
                        $resp = $UnitTestingData[$entry.Key]
                        # Do not check the actual token
                        $resp.Authorization = $resp.Authorization -replace "Bearer.*", "Bearer " 
                        $UnitTestingData[$entry.Key] | Should -MatchHashtable $entry.Value
                    }
                    else {
                        $UnitTestingData[$entry.Key] | Should -MatchHashtable $entry.Value
                    }
                    continue
                }
                
                $UnitTestingData[$entry.Key] | Should -BeExactly $entry.Value
            }
        }
    }

    BeforeEach {
        Enable-UnitTesting
    }

    AfterEach {
        Disable-UnitTesting
    }

    It 'Should have the expected data after New-OAIAssistant is called' {
        New-OAIAssistant

        $ExpectedUnitTestingData = @{
            Method        = 'Post'            
            Uri           = "$expectedBaseUrl/assistants"            
            OutFile       = $null
            ContentType   = 'application/json'
            
            Body          = @{
                instructions = $null
                name         = $null
                model        = "gpt-4o"
            }

            Headers       = $expectedHeaders

            NotOpenAIBeta = $false            
            OAIProvider   = 'OpenAI'
        }

        $UnitTestingData = Get-UnitTestingData 
        $UnitTestingData | Should -Not -BeNullOrEmpty

        Test-UnitTestingData $UnitTestingData $ExpectedUnitTestingData
    }
 
    It 'Should have the expected data after Get-OAIAssistant is called' {
        Get-OAIAssistant

        $ExpectedUnitTestingData = @{
            Method        = 'Get'
            Uri           = "$expectedBaseUrl/assistants"
            OutFile       = $null
            ContentType   = 'application/json'
            Body          = $null
            Headers       = $expectedHeaders
            NotOpenAIBeta = $false
            OAIProvider   = 'OpenAI'
        }

        $UnitTestingData = Get-UnitTestingData
        $UnitTestingData | Should -Not -BeNullOrEmpty

        Test-UnitTestingData $UnitTestingData $ExpectedUnitTestingData
    }    

    It "Should have the expected data after New-OAIThread is called" {
        New-OAIThread

        $ExpectedUnitTestingData = @{
            Method        = 'Post'
            Uri           = "$expectedBaseUrl/threads"
            OutFile       = $null
            ContentType   = 'application/json'
            Body          = @{
                messages       = $null
                tool_resources = $null
                metadata       = $null
            }
            Headers       = $expectedHeaders
            NotOpenAIBeta = $false            
            OAIProvider   = 'OpenAI'
        }

        $UnitTestingData = Get-UnitTestingData
        $UnitTestingData | Should -Not -BeNullOrEmpty

        Test-UnitTestingData $UnitTestingData $ExpectedUnitTestingData
    }

    It "Should have the expected data after New-OAIMessage is called" { 
        $tid = 1234
        New-OAIMessage -ThreadId $tid -Role user -Content 'what is the capital of France'

        $ExpectedUnitTestingData = @{
            Method        = 'Post'
            Uri           = "$expectedBaseUrl/threads/$($tid)/messages"
            OutFile       = $null
            ContentType   = 'application/json'
            Body          = @{
                role    = 'user'
                content = 'what is the capital of France'
            }
            Headers       = $expectedHeaders
            NotOpenAIBeta = $false
            OAIProvider   = 'OpenAI'
        }

        $UnitTestingData = Get-UnitTestingData
        $UnitTestingData | Should -Not -BeNullOrEmpty

        Test-UnitTestingData $UnitTestingData $ExpectedUnitTestingData
    }

    It "Should have the expected data after New-OAIRun is called" {
        $tid = 1234
        $aid = 5678
        New-OAIRun -ThreadId $tid -AssistantId $aid

        $ExpectedUnitTestingData = @{
            Method        = 'Post'
            Uri           = "$expectedBaseUrl/threads/$($tid)/runs"
            OutFile       = $null
            ContentType   = 'application/json'
            Body          = @{
                assistant_id = $aid
            }
            Headers       = $expectedHeaders
            NotOpenAIBeta = $false
            OAIProvider   = 'OpenAI'
        }

        $UnitTestingData = Get-UnitTestingData
        $UnitTestingData | Should -Not -BeNullOrEmpty

        Test-UnitTestingData $UnitTestingData $ExpectedUnitTestingData
    }

    It "Should have the expected data after Get-OAIMessage is called" {
        $tid = 1234
        Get-OAIMessage -ThreadId $tid

        $ExpectedUnitTestingData = @{
            Method        = 'Get'
            Uri           = "$expectedBaseUrl/threads/$($tid)/messages?limit=20&order=desc"
            OutFile       = $null
            ContentType   = 'application/json'
            Body          = $null
            Headers       = $expectedHeaders
            NotOpenAIBeta = $false
            OAIProvider   = 'OpenAI'
        }

        $UnitTestingData = Get-UnitTestingData
        $UnitTestingData | Should -Not -BeNullOrEmpty

        Test-UnitTestingData $UnitTestingData $ExpectedUnitTestingData
    }

    It "Should have the expected data after Get-OAIThread is called" {
        $tid = 1234
        Get-OAIThread -ThreadId $tid

        $ExpectedUnitTestingData = @{
            Method        = 'Get'
            Uri           = "$expectedBaseUrl/threads/$($tid)"
            OutFile       = $null
            ContentType   = 'application/json'
            Body          = $null
            Headers       = $expectedHeaders
            NotOpenAIBeta = $false
            OAIProvider   = 'OpenAI'
        }

        $UnitTestingData = Get-UnitTestingData
        $UnitTestingData | Should -Not -BeNullOrEmpty

        Test-UnitTestingData $UnitTestingData $ExpectedUnitTestingData
    }
}