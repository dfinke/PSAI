@{

    Provider       = @{
        Name     = "GitHubAI"
        Provider = "GitHubAI"
        BaseUri  = "https://models.inference.ai.azure.com"
        Version  = "v1"
    }

    # Model section. Several models can be configured with the same provider
    Models         = @(
        (Invoke-RestMethod -Uri "https://models.inference.ai.azure.com/models").Name
    )

    # messeges sent to the model are configured in various ways.
    # The new message method must be valid for the model
    ModelFunctions = @{
        # The URI structure for calls to the provider
        # The URI has minor variations or each provider. This function will return the URI for the provider.
        GetUri      = {
            [CmdletBinding()]
            param(
                [string]$APIPath = "chat/completions"
            )
            $PathClean = $APIPath.TrimStart('/').TrimEnd('?')
            $uri = "$($this.Provider.BaseUri)/$($PathClean)"
            $uri
        }
        
        NewMessage  = {
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
                [hashtable]$BodyOptions = @{},
                [array]$messages = @(),
                [string]$Uri = $this.GetUri(),
                [string]$Method = 'Post',
                [string]$ContentType = 'application/json'
            )
    
            #Initiialize a body object
            $body = [ordered]@{}
    
            #Add options to the body object
            $BodyOptions.Keys | ForEach-Object {
                $body[$_] = $BodyOptions[$_]
            }

            #Add prompt to messages
            if ($prompt.Length -gt 0) {
                $messages += $this.NewMessage("user", $prompt)
            }

            #Add messages to the body object
            if ($messages) { $BodyOptions.messages += $messages }

            $params = @{
                Headers     = @{ 
                    "Authorization"              = "$($this.Provider.GetApiKey())"
                    "x-ms-model-mesh-model-name" = $this.name 
                }
                Uri         = $this.GetUri()
                Method      = $Method
                ContentType = $ContentType
            }
            if ($BodyOptions -is [System.IO.MemoryStream]) {
                $params['Body'] = $BodyOptions
            }
            elseif ($BodyOptions.Keys.Count -gt 0) {
                $params['Body'] = $BodyOptions | ConvertTo-Json -Depth 10
            }

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
                    Provider       = 'GitHubAI'
                    Response       = $responseString
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