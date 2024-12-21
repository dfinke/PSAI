function Invoke-AgentChatCompletion {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        $Agent,
        $Prompt,
        [switch]
        $ShowFunctionCalls
    )
    
    begin {
        
    }
    
    process {
        # $ChatParams = [System.Collections.Generic.List[object]]@(
        #     $Prompt,
        #     $true,
        #     @{},
        #     [System.Collections.Generic.List[hashtable]]@()
        # )
        $Tools = @{}
        if ($Agent.Tools) { $Tools.Add('tools', @($Agent.Tools)) }
        #$res = $Agent.Model.Chat($Prompt, $true, $ChatParams[2])
        $Agent.Messages += $Agent.Model.NewMessage('user', $Prompt)
        do {
            $res = $Agent.Model.Chat('', $true, $Tools, $Agent.Messages)
            $functionCalls = $res.ResponseObject.choices[0].message.tool_calls
            if ($functionCalls) {
                $Agent.Messages += $res.ResponseObject.choices[0].message | ConvertTo-json -Depth 5 | ConvertFrom-Json -AsHashtable
            }
            foreach ($functionCall in $functionCalls) {
                $functionName = $functionCall.function.name
                $functionParams = $functionCall.function.arguments | ConvertFrom-Json -AsHashtable -Depth 5
            
                Write-Verbose "Calling function $functionName with parameters $($functionParams |convertto-json -Compress)" -Verbose:$ShowFunctionCalls

                if (Get-Command $functionName -ErrorAction SilentlyContinue) {
                    $result = & $functionName @functionParams
                    $messageContent = @(@{
                            role         = 'tool'
                            tool_call_id = $functionCall.id
                            name         = $functionCall.function.name
                            content      = $result  | Out-String
                        })
                    $Agent.Messages += $messageContent
                } 
                else {
                    $result = "Function $toolFun$functionNamectionName not found"
                }
            }
            $res = $Agent.Model.Chat('', $true, @{}, $Agent.Messages)
        }
        while ($res.ResponseObject.choices[0].message.tool_calls)

        $res.ResponseObject.choices[0].message.content
    }
    
    end {
        
    }
}