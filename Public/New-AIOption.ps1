function New-AIOption {
    [CmdletBinding()]
    param (
        [string] $Top_p,
        [int] $Temperature,
        [int] $MaxTokens,
        [int] $FrequencyPenalty,
        [int] $PresencePenalty,
        [bool] $Stop,
        [bool] $Stream
    )
    
    begin {
        # TODO add defaults
    }
    
    process {
        [PSCustomObject]@{
            PSTypeName = 'AIOption'
            Top_p = $Top_p
            Temperature = $Temperature
            MaxTokens = $MaxTokens
            FrequencyPenalty = $FrequencyPenalty
            PresencePenalty = $PresencePenalty
            Stop = $Stop
            Stream = $Stream
        }
    }
    
    end {
        
    }
}