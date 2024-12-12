Describe 'Test Invoke-OAIBeta InvokeRestMethod AzureOpenAI Params' -Tag Invoke-OAIBetaParams-AzureOpenAI -Skip:$true {
    BeforeAll {
        Import-Module "$PSScriptRoot/../PSAI.psd1" -Force
        . "$PSScriptRoot/PesterMatchHashtable.ps1"



        Set-OAIProvider AzureOpenAI
        $ProviderParams = @{
            Provider   = 'AzureOpenAI'
            ApiKey     = '1' | ConvertTo-SecureString -AsPlainText
            ModelNames = @('gpt-4o-mini')
            BaseUri    = 'https://openai-gpt-latest.openai.azure.com'
        }
        Import-AIProvider @ProviderParams
        $version = Get-AIProvider | Select-Object -ExpandProperty Version

        $script:expectedBaseUrl = $ProviderParams.BaseUri
        $script:expectedSuffixUrl = "?api-version={0}" -f $Version

        $script:expectedHeaders = @{
            "Content-Type" = "application/json"
            "OpenAI-Beta"  = "assistants=v2"
            "api-key"      = '1'
        }

        function Get-TargetUri {
            param(
                [Parameter(Mandatory)]
                $endpoint
            )

            if ($endpoint.Contains('?')) {
                $newExpectedSuffixUrl = $expectedSuffixUrl.Replace('?', '&')                 
                return "{0}/openai/{1}{2}" -f $expectedBaseUrl, $endpoint, $newExpectedSuffixUrl
            }            
            
            "{0}/openai/{1}{2}" -f $expectedBaseUrl, $endpoint, $expectedSuffixUrl
        }

        function Test-UnitTestingData {
            param(
                [hashtable]$UnitTestingData,
                [hashtable]$ExpectedUnitTestingData
            )

            foreach ($entry in $ExpectedUnitTestingData.GetEnumerator()) {
                if ($entry.Value -is [hashtable]) {
                    if ($entry.Key -eq 'Headers') {
                        $UnitTestingData[$entry.Key] | Should -MatchHashtable $entry.Value
                        $idx
                    }
                    else {
                        $UnitTestingData[$entry.Key] | Should -MatchHashtable $entry.Value
                    }
                    continue
                }
                if ($entry.Key -eq 'Uri') {
                    $TargetUri = Get-TargetUri $UnitTestingData[$entry.Key]
                    $TargetUri | Should -BeExactly $entry.Value
                    continue
                }
                if ($entry.Key -eq 'Body') {
                    $UnitTestingData[$entry.Key] | ConvertTo-Json -Depth 10 | Should -BeExactly ($entry.Value | ConvertTo-Json -Depth 10)
                    continue
                }

                $($UnitTestingData[$entry.Key]) | Should -BeExactly $entry.Value
            }
        }
    }

    BeforeEach {
        Enable-UnitTesting
    }

    AfterEach {
        Disable-UnitTesting
    }

    It 'Should have the expected data after New-OAIAssistant is called' -Skip:$true{
        New-OAIAssistant

        $expectedUri = Get-TargetUri 'assistants'

        $ExpectedUnitTestingData = @{
            Method        = 'Post'            
            Uri           = $expectedUri
            OutFile       = $null
            ContentType   = 'application/json'
            
            Body          = @{
                instructions = $null
                name         = $null
            }

            Headers       = $expectedHeaders

            NotOpenAIBeta = $false            
            OAIProvider   = 'AzureOpenAI'
        }

        $UnitTestingData = Get-UnitTestingData 
        $UnitTestingData | Should -Not -BeNullOrEmpty

        write-host ($UnitTestingData | Convertto-json )

        Test-UnitTestingData $UnitTestingData $ExpectedUnitTestingData
    }
 
    It 'Should have the expected data after Get-OAIAssistant is called' {
        Get-OAIAssistant

        $ExpectedUnitTestingData = @{
            Method        = 'Get'
            Uri           = (Get-TargetUri 'assistants')
            OutFile       = $null
            ContentType   = 'application/json'
            Body          = [ordered]@{}
            Headers       = $expectedHeaders
            NotOpenAIBeta = $false
            OAIProvider   = 'AzureOpenAI'
        }

        $UnitTestingData = Get-UnitTestingData
        $UnitTestingData | Should -Not -BeNullOrEmpty

        Test-UnitTestingData $UnitTestingData $ExpectedUnitTestingData
    }    

    It "Should have the expected data after New-OAIThread is called" {
        New-OAIThread

        $ExpectedUnitTestingData = @{
            Method        = 'Post'
            Uri           = Get-TargetUri "threads"
            OutFile       = $null
            ContentType   = 'application/json'
            # Body          = @{
            #     messages       = $null
            #     tool_resources = $null
            #     metadata       = $null
            # }
            Headers       = $expectedHeaders
            NotOpenAIBeta = $false            
            OAIProvider   = 'AzureOpenAI'
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
            # Uri                 = "$expectedBaseUrl/threads/$($tid)/messages"
            Uri           = Get-TargetUri "threads/$($tid)/messages"
            OutFile       = $null
            ContentType   = 'application/json'
            Body          = @{
                role    = 'user'
                content = 'what is the capital of France'
            }
            Headers       = $expectedHeaders
            NotOpenAIBeta = $false
            OAIProvider   = 'AzureOpenAI'
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
            #Uri                 = "$expectedBaseUrl/threads/$($tid)/runs"
            Uri           = Get-TargetUri "threads/$($tid)/runs"
            OutFile       = $null
            ContentType   = 'application/json'
            Body          = @{
                assistant_id = $aid
            }
            Headers       = $expectedHeaders
            NotOpenAIBeta = $false
            OAIProvider   = 'AzureOpenAI'
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
            # Uri                 = "$expectedBaseUrl/threads/$($tid)/messages?limit=20&order=desc"
            Uri           = Get-TargetUri "threads/$($tid)/messages?limit=20&order=desc"
            OutFile       = $null
            ContentType   = 'application/json'
            Body          = [ordered]@{}
            Headers       = $expectedHeaders
            NotOpenAIBeta = $false
            OAIProvider   = 'AzureOpenAI'
        }

        $UnitTestingData = Get-UnitTestingData
        $UnitTestingData | Should -Not -BeNullOrEmpty

        Test-UnitTestingData $UnitTestingData $ExpectedUnitTestingData
    }
}

AfterAll {
    Clear-AIProviderList
}