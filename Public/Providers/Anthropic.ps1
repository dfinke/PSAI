
# Documentaition: https://docs.anthropic.com/en/api/getting-started
@{
    Provider          = @{
        Name     = "Anthropic"
        Provider = "Anthropic"
        BaseUri  = "https://api.anthropic.com"
        Version  = "2023-06-01"
    }

    Models            = @(
        "claude-3-5-sonnet-20240620"
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
            # if ($APIPath -eq "") { $APIPath = "generateContent" }
            # $PathClean = $APIPath.TrimStart('/|:').TrimEnd('?')
            $uri = "$($this.Provider.BaseUri)/v1/messages"
            $uri
        }

        NewMessage  = {
            [outputType([hashtable])]
            [CmdletBinding()]
            param(
                [ValidateSet('user', 'assistant')]
                [string]$role = "user",
                $Content # Takes a string or an array of objects
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
                $BodyOptions = [ordered]@{},
                [array]$messages = @(),
                [string]$Uri,
                [string]$Method = "Post",
                [string]$ContentType = 'application/json'
            )
            # anthropic requires a max_token parameter in the body
            if ($BodyOptions.Keys -notcontains 'max_tokens') {
                $BodyOptions.Add('max_tokens', 1024)
            }
            if ($BodyOptions.Keys -notcontains 'model') {
                $BodyOptions.Add('model', $this.Name)
            }

            #Add prompt to messages
            if ($prompt) {
                $messages += $this.NewMessage("user", $prompt)
                $BodyOptions.messages += $messages
            }
        
            $headers = @{
                'x-api-key'         = $this.Provider.GetApiKey()
                'anthropic-version' = $this.Provider.Version
            }

            $params = @{
                Headers     = $headers
                Uri         = $this.GetUri($Uri)
                Method      = 'POST'
                ContentType = 'application/json'
                Body        = $BodyOptions | ConvertTo-Json -Depth 10
            }

            try {
                $r = Invoke-RestMethod @params  -ErrorVariable InvokeRestError
            }
            catch {}

            if ($InvokeRestError) {
                return $InvokeRestError
            }
            $responseString = $r.content[0].text
            if ($ReturnObject) {
                return [pscustomobject][ordered]@{
                    Provider       = 'Anthropic'
                    Response       = $responseString# There might come other stuff out here
                    ResponseObject = $r
                    Messages       = $messages + $this.NewMessage("assistant", $responseString)
                    isStop         = $r.stop_reason -eq "end_turn"
                    isFunctionCall = $false # not implemented yet
                }
            }
            $responseString
        }
    }
}