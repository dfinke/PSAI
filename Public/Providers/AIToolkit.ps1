
@{
    Provider   = @{
        Name     = "AIToolkit"
        Provider = "AIToolkit"
        BaseUri  = "http://127.0.0.1:5272"
        Version  = "v1"
    }

    Models     = @(
        "Phi-3-mini-4k-directml-int4-awq-block-128-onnx"
    )

    NewMessage = {
        [outputType([hashtable])]
        [CmdletBinding()]
        param(
            [ValidateSet('user', 'assistant')]
            [string]$role = "user",
            [string]$Content
        )
        @{
            role    = $Actor
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
            $messages += $($this.NewMessage("user", $prompt))
        }


        $params = @{
            Uri         = "$($this.Provider.BaseUri)/$($this.Provider.Version)/chat/completions"
            Method      = 'POST'
            ContentType = 'application/json'
            Body        = $body | ConvertTo-Json -Depth 10
        }

        $r = Invoke-RestMethod @params

        if ($ReturnObject) {
            [pscustomobject][ordered]@{
                Provider       = 'AzureOpenAI'
                Response       = $r.choices[0].message.content
                ResponseObject = $r
            }
        }
        else {
            $r.choices[0].message.content
        }
    }

}