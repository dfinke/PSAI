<#
.SYNOPSIS
Creates and manages a list of AI providers.

.DESCRIPTION
The New-AIProviderList function initializes a global AI provider list with methods to add, remove, set default, and retrieve providers. 
It supports overwriting the existing list with the -Force parameter and returning the list object with the -PassThru parameter.

.PARAMETER Force
If specified, forces the creation of a new provider list even if one already exists.

.PARAMETER PassThru
If specified, returns the created provider list object.

.EXAMPLE
PS C:\> New-AIProviderList

Creates a new AI provider list if one does not already exist.

.EXAMPLE
PS C:\> New-AIProviderList -Force

Creates a new AI provider list, overwriting any existing list.

.EXAMPLE
PS C:\> $providerList = New-AIProviderList -PassThru

Creates a new AI provider list and returns the list object.

.NOTES
The function creates a global variable $script:ProviderList to store the provider list. 
The provider list is a custom object with methods to manage providers:
- Add: Adds a new provider to the list.
- Remove: Removes a provider from the list.
- SetDefault: Sets a provider as the default.
- Get: Retrieves a provider by name.
- GetDefault: Retrieves the default provider.

#>
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
                Providers = [System.Collections.Generic.Dictionary[string,PSCustomObject]]::new([StringComparer]::OrdinalIgnoreCase)
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