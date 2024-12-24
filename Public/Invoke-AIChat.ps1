function Invoke-AIChat {
    [CmdletBinding()]
    param (
        $Prompt = "What is the capitol of France"
    )
    
    begin {
        
    }
    
    process {
        $model = Get-AIModel
        $model.Chat($Prompt)
    }
    
    end {
        
    }
}