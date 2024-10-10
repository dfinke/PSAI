function Set-AIDefaultProvider {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]
        $ProviderName
    )
    begin {
        if (!$(Get-AIProviderList)){
            Write-Error "No Providers in the list. Please add a provider first." -ErrorAction Stop
        } 
        if (!$(Get-AIProvider $ProviderName)){
            Write-Error "Provider $ProviderName not found in the list. Please add a provider first." -ErrorAction Stop
        }
    }
    process {
        $script:ProviderList.SetDefault($ProviderName)
    }
    end {}
}