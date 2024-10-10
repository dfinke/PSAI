@{

    Provider   = @{
        Name     = "AzureOpenAI"
        Provider = "AzureOpenAI"
        Version  = "2024-05-01-preview"
    }

    # Model section. Several models can be configured with the same provider
    Models     = @(
        "GPT-4o"
    )

    # messeges sent to the model are configured in various ways.
    # The new message method must be valid for the model

    NewMessage = {
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
        if ($prompt.Length -gt 0) {
            $messages += $this.NewMessage("user", $prompt)
        }

        #Add messages to the body object
        if ($messages) {$body.messages += $messages}

        $params = @{
            Headers     = @{ "api-key" = "$($this.Provider.GetApiKey())" }
            Uri         = "$($this.Provider.BaseUri)/openai/deployments/$($this.Name)/chat/completions?api-version=$($this.Provider.Version)"
            Method      = 'POST'
            ContentType = 'application/json'
            Body        = $body | ConvertTo-Json -Depth 15
        }

        try {
            $r = Invoke-RestMethod @params -ErrorVariable woops
        } catch {}

         if ($woops){
            return $woops
            }
        if ($ReturnObject) {
            return [pscustomobject][ordered]@{
                Provider       = 'AzureOpenAI'
                Response       = $r.choices[0].message.content
                ResponseObject = $r
            }
        }
        $r.choices[0].message.content

    }

}