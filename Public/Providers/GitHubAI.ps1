@{

    Provider   = @{
        Name     = "GitHubAI"
        Provider = "GitHubAI"
        BaseUri  = "https://models.inference.ai.azure.com/chat/completions"
        Version  = "v1"
    }

    # Model section. Several models can be configured with the same provider
    Models     = @(
        (Invoke-RestMethod -Uri "https://models.inference.ai.azure.com/models").Name
    )

    # messeges sent to the model are configured in various ways.
    # The new message method must be valid for the model

    NewMessage = {
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

    Chat       = {
        [CmdletBinding()]
        param(
            $prompt,
            [switch]$ReturnObject,
            [hashtable]$BodyOptions = @{},
            [array]$messages = @()
        )
    
        #Initiialize a body object
        $body = [ordered]@{
            model = $this.Name
        }
    
        #Add options to the body object
        $BodyOptions.Keys | ForEach-Object {
            $body[$_] = $BodyOptions[$_]
        }

        #Add prompt to messages
        if ($prompt) {
            $messages += $this.NewMessage("user", $prompt)
        }

        #Add messages to the body object
        if ($null -ne $body.messages) {$body.messages += $messages}

        $params = @{
            Headers     = @{ "Authorization" = "$($this.Provider.GetApiKey())" }
            Uri         = $this.Provider.BaseUri
            Method      = 'POST'
            ContentType = 'application/json'
            Body        = $body | ConvertTo-Json -Depth 10
        }

        $r = Invoke-RestMethod @params
    
        if ($ReturnObject) {
            [pscustomobject][ordered]@{
                Provider       = 'GitHubAI'
                Response       = $r.choices[0].message.content
                ResponseObject = $r
            }
        }
        else {
            $r.choices[0].message.content
        }
    }

}