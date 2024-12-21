@{
    # Provider section. Only configure a single provider. Do not type the API Key here!
    Provider          = @{
        Name     = "Gemini"
        Provider = "Gemini"
        Version  = "v1beta"
        BaseUri  = "https://generativelanguage.googleapis.com"
    }

    # Model section. Several models can be configured with the same provider
    Models            = @(
        "gemini-1.5-flash"
        "gemini-2.0-flash-exp"
        "gemini-exp-1206"
        'gemini-2.0-flash-thinking-exp-1219'
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
            if ($APIPath -eq "") { $APIPath = "generateContent" }
            $PathClean = $APIPath.TrimStart('/|:').TrimEnd('?')
            $uri = "$($this.Provider.BaseUri)/$($this.Provider.Version)/models/$($this.Name):$($PathClean)?key=$($this.Provider.GetApiKey())"
            $uri
        }
        
        NewMessage = {
            [outputType([hashtable])]
            [CmdletBinding()]
            param(
                [ValidateSet('user', 'model')]
                [string]$role = "user",
                [string]$Content,
                [string]$type = "text",
                [array]$parts = @()
            )

            $message = @{
                role    = $role
                "parts" = $parts
            }
            if ($Content) {
                $message.parts += @{
                    $type = $Content
                }
            }
            $message
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

            # Gemini uses contents in the body in stead of messages
            if ($BodyOptions.Keys -contains 'messages') {
                     $BodyOptions.contents += $BodyOptions.messages
                     $BodyOptions.Remove('messages')
                 }
            if ($BodyOptions.Keys -notcontains 'contents') {
                     $BodyOptions.contents = @()
                 }
                
            #Add prompt to messages
            if ($prompt.Length -gt 0) {
                $messages += $this.NewMessage("user", $prompt)
            }


            #Initiialize a body object
            #Add messages to the body object
            if ($messages) { $BodyOptions.contents += $messages }


            $params = @{
                Uri         = $this.GetUri($Uri)
                Method      = $Method
                ContentType = 'application/json'
                Body        = $BodyOptions | ConvertTo-Json -Depth 10
            }
            Write-Debug ($params | Convertto-json -Depth 10)
            
            try{
                $r = Invoke-RestMethod @params  -ErrorVariable InvokeRestError
            }
            catch {}

            if ($InvokeRestError) {
                return $InvokeRestError
            }
            $responseString = $r.candidates[0]?.content?.parts[0]?.text
            if ($ReturnObject) {
                return  [pscustomobject][ordered]@{
                    Provider       = 'Gemini'
                    Response       = $responseString
                    ResponseObject = $r
                    Messages       = $BodyOptions.contents + $this.NewMessage("model", $responseString)
                    isStop         = $r.candidates?.finishReason -eq "STOP"
                    isFunctionCall = $false # Not implemented yet
                }
            }
            $responseString
        }
    }
}

