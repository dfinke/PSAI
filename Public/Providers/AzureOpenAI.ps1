@{

    Provider          = @{
        Name     = "AzureOpenAI"
        Provider = "AzureOpenAI"
        Version  = "2024-07-01-preview"
    }

    # Model section. Several models can be configured with the same provider
    Models            = @(
        "GPT-4o"
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
            if ($APIPath -match 'chat') { $APIPath = "deployments/$($this.Name)/" + $APIPath }
            $PathClean = $APIPath.TrimStart('/').TrimEnd('?')
            if ($PathClean -match '\?') { $PathClean += "&" }else { $PathClean += "?" }
            $uri = "$($this.Provider.BaseUri)/openai/$($PathClean)api-version=$($this.Provider.Version)"
            $uri
        }

        # Messages sent to the model are configured in various ways. This section contains the configuration for the model.
        NewMessage  = {
            [CmdletBinding()]
            param(
                [ValidateSet('user', 'assistant', 'system')]
                [string]$role = "user",
                $Content
            )
            @{
                role    = $role
                content = $Content
            }
        }

        # The InvokeModel function is used to send requests to the provider. This function can be used to send other requests to the provider.
        # Implement defaults for Chat
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
    
            #Initiialize a body object
            #$body = [ordered]@{}
    
            #Add prompt to messages
            if ($prompt.Length -gt 0) {
                $messages += $this.NewMessage("user", $prompt)
            }

            #Add messages to the body object
            if ($messages) { $BodyOptions.messages += $messages }

            $params = @{
                Headers     = @{ "api-key" = "$($this.Provider.GetApiKey())" }
                Uri         = "$($this.GetUri($Uri))"
                Method      = $Method
                ContentType = $ContentType
            }
            if ($BodyOptions -is [System.IO.MemoryStream]) {
                $params['Body'] = $BodyOptions
            } elseif ($BodyOptions.Keys.Count -gt 0) {
                if ($Uri -match 'assistants') { $BodyOptions['model'] = $this.Name }
                $params['Body'] = $BodyOptions | ConvertTo-Json -Depth 10
            }

            Write-Debug $($params |Convertto-json -Depth 5)

            try {
                $r = Invoke-RestMethod @params -ErrorVariable InvokeRestError
            }
            catch {}

            if ($InvokeRestError) {
                return $InvokeRestError
            }
            $responseString = $r.choices[0]?.message?.content
            if ($ReturnObject) {
                return [pscustomobject][ordered]@{
                    Provider       = 'AzureOpenAI'
                    Response      = $responseString
                    ResponseObject = $r
                    Messages       = $body.messages + $this.NewMessage("assistant", $responseString)
                    isStop         = $r.choices.finish_reason -eq "stop"
                    isFunctionCall = $null -ne $r.choices[0].message.tool_calls
                }
            }
            $responseString
        }
    }
}