function Add-AIProviderToList {
    [CmdletBinding()]
    param (
        [PSCustomObject] $Provider,
        [switch] $Default,
        $Force
    )
    
    begin {
        $ProviderList = Get-AIProviderList
        if (-not $ProviderList) {
            $ProviderList = New-AIProviderList -PassThru
        }
    }
    
    process {
        if ($ProviderList.Providers.ContainsKey($Provider.Name)) {
            $null = $Force ? 
                ($ProviderList.Remove($Provider.Name)) :
                (Write-Error "Provider with name $($Provider.Name) already exists in the list. Use -Force to overwrite" -ErrorAction Stop)
        }

        [void]$ProviderList.Add($Provider, $Default)
    }
    
    end {
        
    }
}