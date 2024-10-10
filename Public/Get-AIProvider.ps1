function Get-AIProvider {
    [CmdletBinding()]
    param (
        [string] $Name,
        [switch] $All
    )
    
    begin {
        $ProviderList = (Get-AIProviderList) 
        if (-not $ProviderList) {
            (Write-Error "No provider list found. Create a new list using New-AIProviderList before running this command" -ErrorAction Stop)
        }
    }
    
    process {
        if  ($All) { $script:ProviderList.Providers }
        elseif ($Name) { $script:ProviderList.Get($Name) }
        else { $script:ProviderList.GetDefault() }  
    }
    
    end {
        
    }
}