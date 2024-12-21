
@{
    Provider          = @{
        Name     = "OpenAI"
        Provider = "OpenAI"
        BaseUri  = "https://api.openai.com/"
        Version  = "v1"
    }

    Models            = @(
        "gpt-4o-mini"
        "gpt-3.5-turbo-0125"
        "gpt-3.5-turbo-0613"
        "gpt-3.5-turbo-1106"
        "gpt-3.5-turbo-16k-0613"
        "gpt-3.5-turbo-16k"
        "gpt-3.5-turbo"
        "gpt-4-0125-preview"
        "gpt-4-0314"
        "gpt-4-0613"
        "gpt-4-1106-preview"
        "gpt-4-32k-0314"
        "gpt-4-32k-0613"
        "gpt-4-32k"
        "gpt-4-turbo-2024-04-09"
        "gpt-4-turbo-preview"
        "gpt-4-turbo"
        "gpt-4-vision-preview"
        "gpt-4"
        "gpt-4o-2024-05-13"
        "gpt-4o-2024-08-06"
        "gpt-4o-mini-2024-07-18"
        "gpt-4o"
        "o1-mini-2024-09-12"
        "o1-mini"
        "o1-preview-2024-09-12"
        "o1-preview"
    )

    # This section contains the functions available on the provider
    ProviderFunctions = @{
        
    }
    # Messeges sent to the model are configured in various ways. This section contains the configuration for the model.
    # This section contains the functions available on the model
    ModelFunctions    = @{
        # The URI structure for calls to the provider
        # The URI has minor variations or each provider. This function will return the URI for the provider.
        GetUri      = {
            [CmdletBinding()]
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
            if ($body.Keys -notcontains 'model' -and
                !$($BodyOptions -is [System.IO.MemoryStream]) -and
                $MEthod -notmatch "Get|Delete") {
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
                Uri         = $this.GetUri($Uri)
                Method      = $Method
                ContentType = $ContentType
            }

            if ($BodyOptions -is [System.IO.MemoryStream]) {
                $params['Body'] = $BodyOptions
            }
            elseif ($body.Keys.Count -gt 0) {
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
                    Provider       = 'OpenAI'
                    Response       = $responseString
                    ResponseObject = $r
                    Messages       = $NewMessages
                    isStop         = $r.choices.finish_reason -eq "stop"
                    isFunctionCall = $null -ne $r.choices?[0].message.tool_calls
                }
            }
            $responseString
        }

    }
}