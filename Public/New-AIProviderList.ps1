function New-AIProviderList {
    [CmdletBinding()]
    param (
        [switch]
        $Force,
        [switch]
        $PassThru
    )
    
    begin {
        
    }
    
    process {
        if ($script:ProviderList -and !$Force) {
            Write-Warning "ProviderList already exists. Use -Force to overwrite."
            break
        }
        If (!$script:ProviderList -or $Force) {
            $script:ProviderList = [PSCustomObject]@{
                PSTypeName = 'AIProviderList'
                Providers = [System.Collections.Generic.Dictionary[string,PSCustomObject]]@{}
                DefaultProvider = ''
            }
        }
        Add-Member -InputObject $script:ProviderList -MemberType ScriptMethod -Name Add -Value {
            param([PSCustomObject]$Provider, [bool]$Default = $false)
            $this.Providers.TryAdd($Provider.Name,$Provider)
            if ($this.DefaultProvider.Equals('') -or $Default) {
                $this.DefaultProvider = $Provider.Name
            }
        }

        Add-Member -InputObject $script:ProviderList -MemberType ScriptMethod -Name Remove -Value {
            param([string]$Name)
            $this.Providers.ContainsKey($Name) ? 
                $this.Providers.Remove($Name) :
                (Write-Error "Provider '$Name' not found in the list." -ErrorAction Stop)
            if ($this.DefaultProvider.Equals($Name)) {
                $this.DefaultProvider = ''
                Write-Warning "Default provider removed. Please set a new default provider."
            } 
        }

        Add-Member -InputObject $script:ProviderList -MemberType ScriptMethod -Name SetDefault -Value {
            param([string]$Name)
            $this.Providers.ContainsKey($Name) ? (
                $this.DefaultProvider = $Name
            ) : (
                Write-Warning "Provider '$Name' not found in the list."
            )
        }

        Add-Member -InputObject $script:ProviderList -MemberType ScriptMethod -Name Get -Value {
            param([string]$Name)
            return $this.Providers[$Name]
        }

        Add-Member -InputObject $script:ProviderList -MemberType ScriptMethod -Name GetDefault -Value {
            return $this.Providers[$this.DefaultProvider]
        }
    }
    
    end {
        if ($PassThru) {
            return $script:ProviderList
        }
    }
}