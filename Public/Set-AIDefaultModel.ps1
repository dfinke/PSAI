function Set-AIDefaultModel {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ParameterSetName = 'ProviderObject')]
        [PSCustomObject] $Provider,
        [Parameter(Mandatory, ParameterSetName = 'ProviderName')]
        [string] $ProviderName,
        [Parameter (Mandatory)]
        [string] $ModelName
    )
    
    begin {
        $Provider = $PSCmdlet.ParameterSetName.Equals('ProviderObject')
        if (!$Provider) {
            $Provider = Get-AIProvider -Name $ProviderName
        }
        if (!$Provider) {
            Write-Error "Provider found in the ProviderList. Please supply an existing Provider or ProviderName" -ErrorAction Stop
        }

    }
    
    process {
        $Provider.DefaultModel = $ModelName
    }
    
    end {
        
    }
}