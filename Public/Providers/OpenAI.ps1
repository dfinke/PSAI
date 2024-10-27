
@{
    Provider          = @{
        Name     = "OpenAI"
        Provider = "OpenAI"
        BaseUri  = "https://api.openai.com/"
        Version  = "v1"
    }

    Models            = @(
        "gpt-4o-mini"
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
    }
}