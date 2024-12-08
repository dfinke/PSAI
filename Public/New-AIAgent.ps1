function New-AIAgent {
    [CmdletBinding()]
    param (
        $Instructions = "You are a helpful agent",
        $Model = (Get-AIModel),
        $Tools = @()
        
    )
    
    begin {
        $Agent = [PSCustomObject]@{
            PSTypeName = 'AIAgent'
            Instructions = $Instructions
            Model = $Model
            Tools = $Tools
            Messages = @()
        }
    }
    
    process {
        Add-Member -InputObject $Agent -MemberType ScriptMethod -Name GetMessages -Value {
            param([string]$Last = $this.Messages.Count)
            return $this.Messages | Select-Object -Last $Last
        }
        Add-Member -InputObject $Agent -MemberType ScriptMethod -Name AddInstructions -Value {
            if ($this.Instructions) {
                $this.Messages += $this.Model.NewMessage('system', $this.Instructions)
            }
        }
        
        Add-Member -InputObject $Agent -MemberType ScriptMethod -Name ClearMessages -Value {
            $this.Messages = @()
            $this.AddInstructions()
        }

        Add-Member -InputObject $Agent -MemberType ScriptMethod -Name Prompt -Value {
            Invoke-AgentChatCompletion -Agent $this -Prompt $Args[0] -ShowFunctionCalls:$(if ($args.Length -gt 1) {$args[1]} else {$false})
        }

        
    }
    
    end {
        $Agent.AddInstructions()
        $Agent
    }
}