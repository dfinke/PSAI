function Get-AIObjectParams {
    [CmdletBinding()]
    param (
        [hashtable]$BoundParameters,
        [System.Collections.Generic.List[string]] $Exclude = @()
    )
    
    begin {
        
    }
    
    process {
        $hashData = @{}
        @('Verbose', 'Debug').ForEach{$Exclude.Add($_)}
        $BoundParameters.Keys.Where{$Exclude -notcontains $_}.ForEach{
            [void]$hashData.Add($_, $BoundParameters[$_])
        }
    }
    
    end {
        $hashData
    }
}