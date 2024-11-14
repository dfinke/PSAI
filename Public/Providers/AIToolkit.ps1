
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
            [CmdletBinding()]
            param(
                [string]$APIPath = "chat/completions"
            )
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
                [string]$Uri = "chat/completions",
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
                "OpenAI-Beta" = "assistants=v2"
            }

            $params = @{
                Headers     = $headers
                Uri         = "$($this.GetUri($Uri))"
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
            if ($ReturnObject) {
                return [pscustomobject][ordered]@{
                    Provider       = 'OpenAI'
                    ResponseObject = $r
                }
            }
            $r.choices[0].message.content
        }

        Chat        = {
            [CmdletBinding()]
            param(
                $prompt,
                [switch]$ReturnObject,
                [hashtable]$BodyOptions = @{model = $this.Name },
                [array]$messages = @()
            )
            $this.InvokeModel($prompt, $ReturnObject, $BodyOptions, $messages)
        }

        # Chat       = {
        #     [CmdletBinding()]
        #     param(
        #         $prompt,
        #         [switch]$ReturnObject,
        #         [hashtable]$BodyOptions = @{},
        #         [array]$messages = @()
        #     )
    
        #     #Initiialize a body object
        #     $body = [ordered]@{
        #         model = $this.Name
        #     }
    
        #     #Add options to the body object
        #     $BodyOptions.Keys | ForEach-Object {
        #         $body[$_] = $BodyOptions[$_]
        #     }

        #     #Add prompt to messages
        #     if ($prompt) {
        #         $messages += $($this.NewMessage("user", $prompt))
        #     }


        #     $params = @{
        #         Uri         = "$($this.Provider.BaseUri)/$($this.Provider.Version)/chat/completions"
        #         Method      = 'POST'
        #         ContentType = 'application/json'
        #         Body        = $body | ConvertTo-Json -Depth 10
        #     }

        #     $r = Invoke-RestMethod @params

        #     if ($ReturnObject) {
        #         [pscustomobject][ordered]@{
        #             Provider       = 'AzureOpenAI'
        #             Response       = $r.choices[0].message.content
        #             ResponseObject = $r
        #         }
        #     }
        #     else {
        #         $r.choices[0].message.content
        #     }
        # }
    }

}