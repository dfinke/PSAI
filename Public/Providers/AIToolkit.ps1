
@{
    Provider          = @{
        Name     = "AIToolkit"
        Provider = "AIToolkit"
        BaseUri  = "http://127.0.0.1:5272"
        Version  = "v1"
    }

    Models            = @(
        "Phi-3-mini-4k-directml-int4-awq-block-128-onnx"
    )

    ProviderFunctions = @{
        
    }


    ModelFunctions    = @{
        GetUri      = {
            param(
                [string]$APIPath
            )
            if ($APIPath -eq "") { $APIPath = "chat/completions" }
            $PathClean = $APIPath.TrimStart('/').TrimEnd('?')
            $uri = "$($this.Provider.BaseUri)/$($this.Provider.Version)/$($PathClean)"
            $uri
        }

        NewMessage  = {
            [outputType([hashtable])]
            [CmdletBinding()]
            param(
                [ValidateSet('user', 'assistant', 'system')]
                [string]$role = "user",
                [string]$Content
            )
            @{
                role    = $role
                content = $Content
            }
        }

        InvokeModel = {
            [CmdletBinding()]
            param(
                $prompt,
                [switch]$ReturnObject,
                $BodyOptions = @{},
                [array]$messages = @(),
                [string]$Uri,
                [string]$Method = "Post",
                [string]$ContentType = 'application/json'
            )
    
            #Initiialize a body object
            $body = $BodyOptions
            if ($body.Keys -notcontains 'model') {
                $body.model = $this.Name
            }

            #Add prompt to messages
            if ($prompt.Length -gt 0) {
                $messages += $this.NewMessage("user", $prompt)
            }

            #Add messages to the body object
            if ($messages) { $body.messages += $messages }

            # Headers are special on OpenAI
            $headers = @{
                Authorization = "Bearer $($this.Provider.GetApiKey())"
            }

            $params = @{
                Headers     = $headers
                Uri         = $this.GetUri($Uri)
                Method      = $Method
                ContentType = $ContentType
            }

            if ($BodyOptions -is [System.IO.MemoryStream]) {
                $params['Body'] = $BodyOptions
            } else {
                $params['Body'] = $body | ConvertTo-Json -Depth 10
            }

            try {
                $r = Invoke-RestMethod @params -ErrorVariable InvokeRestError
            }
            catch {}

            if ($InvokeRestError) {
                return $InvokeRestError
            }
            if ($r.choices?.message) {
                $responseString = $r.choices?[0].message?.content
                $NewMessages = $body.messages + $r.choices?[0].message | ConvertTo-Json -Depth 10 | ConvertFrom-Json -AsHashtable
            }
            if ($ReturnObject) {
                return [pscustomobject][ordered]@{
                    Provider       = 'AIToolkit'
                    Response       = $responseString
                    ResponseObject = $r
                    Messages       = $NewMessages
                    isStop         = $r.choices.finish_reason -eq "stop"
                    isFunctionCall = $null -ne $r.choices[0].message.tool_calls
                }
            }
            $responseString
        }
    }

}