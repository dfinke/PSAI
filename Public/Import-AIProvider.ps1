<#
    .SYNOPSIS
    Import a Provider definition from a file or by name

    .DESCRIPTION
    Import a Provider definition from a file or by name. The file should contain a hashtable with the Provider and Model definitions. Look at the included providers in the modules Providers folders for examples.

    .PARAMETER FilePath
    The path to the file holding the Provider definition. Import your own provider by creating a file with the same structure as the included providers

    .PARAMETER Provider
    The Provider object to import. Tab completion for included providers is available

    .PARAMETER ModelNames
    An array of Model names to import. The first Model will be set as the default

    .PARAMETER ApiKey
    The ApiKey to use for the Provider. Must be a SecureString

    .PARAMETER BaseUri
    The BaseUri to use for the Provider

    .PARAMETER Default
    Forces the Provider to be the default if other providers are already imported

    .PARAMETER PassThru
    Returns the imported Provider object to the pipeline

    .PARAMETER Force
    Creates a new Provider list and imports the Provider

    .EXAMPLE
    Import-AIProvider -Provider OpenAI -ApiKey $($env:OpenAIKey | ConvertTo-SecureString -AsPlainText)
    
    .EXAMPLE
    Import-AIProvider -Provider AzureOpenAI -ModelNames "GPT-4o" -ApiKey $($env:ApiKey | ConvertTo-SecureString -AsPlainText) -BaseUri $BaseUri

    Imports the AzureOpenAI provider with the GPT-4o model and sets the ApiKey and BaseUri

    .EXAMPLE
    Import-AIProvider -FilePath .\MyProvider.ps1 -ApiKey $(Get-Secret -Name MySecret)

    Imports the provider definition from the file MyProvider.ps1 and sets the ApiKey

    .EXAMPLE
    $provider = Import-AIProvider -Provider AzureOpenAI -ModelNames "GPT-4o" -ApiKey $($env:ApiKey | ConvertTo-SecureString -AsPlainText) -BaseUri $BaseUri -PassThru

    Imports the AzureOpenAI provider with the GPT-4o model and sets the ApiKey and BaseUri. The imported Provider object is returned to the pipeline

    .EXAMPLE
    Import-AIProvider -Provider AzureOpenAI -ModelNames "GPT-4o" -ApiKey $($env:ApiKey | ConvertTo-SecureString -AsPlainText) -BaseUri $BaseUri -Force

    Imports the AzureOpenAI provider with the GPT-4o model and sets the ApiKey and BaseUri. The Provider is set and owerwrites any existing AzureOpenAI Provider

#>
function Import-AIProvider {
    [CmdletBinding(DefaultParameterSetName = 'Provider')]
    param (
        [Parameter(
            Mandatory,
            HelpMessage = 'The path to the file holding the Provider definition',
            ParameterSetName = 'FilePath'
        )]
        [System.IO.FileInfo]$FilePath,
        [Parameter(
            Mandatory,
            HelpMessage = 'The Provider object to import',
            ParameterSetName = 'Provider'
        )]
        [ValidateSet('AzureOpenAI', 'OpenAI', 'Gemini', 'AIToolkit', 'Groq', 'Ollama', 'Anthropic','GitHubAI','xAI')]
        [string[]]$Provider,
        [Parameter(
            HelpMessage = 'Optional Model name. The configuration name will be overwritten if provided'
        )]
        [string[]]$ModelNames,
        [securestring]$ApiKey,
        [string]$BaseUri,
        [string]$Version,
        [switch]$Default,
        [switch]$PassThru,
        [switch]$Force,
        [switch]$ClearExistingList
    )

    begin {
        if (!$Script:ProviderList -or $ClearExistingList) {
            New-AIProviderList
        }
        if ($PSCmdlet.ParameterSetName -eq 'Provider') {
            $Provider | ForEach-Object {
                $providerFile = Join-Path -Path $PSScriptRoot -ChildPath "Providers\$_.ps1"
                $hashParams = Get-AIObjectParams $PSBoundParameters -Exclude 'Provider'
                $hashParams.Add('FilePath', $providerFile)
                Import-AIProvider @hashParams -Verbose:$VerbosePreference -Force:$Force
            }
        } 
    }
    
    process {
        if ($PSCmdlet.ParameterSetName -eq 'FilePath') {
            # Ensure the File is present and readable
            $File = $FilePath.FullName
            if (-not $FilePath.Exists) {
                Write-Error -Message "File does not exist: $File" -ErrorAction Stop
            }
            try {
                
                Write-Verbose "Reading $File"
                $Content = & $File
            }
            catch {
                Write-Error -Message "Unable to read file: $File" -ErrorAction Stop
            }
            # Extract the content and create the objects
            $providerHash = $Content.Provider
            if ($BaseUri) {
                $providerHash.BaseUri = $BaseUri
            }
            if ($ApiKey) {
                $providerHash.ApiKey = $ApiKey
            }
            
            $providerHash.Add('PassThru', $PassThru)
            $providerHash.Add('Default', $Default)
            $providerHash.Add('Force', $Force)
            $ProviderObject = New-AIProvider @providerHash -PassThru

            # First ModelNames will be default
            $models = $($ModelNames; $Content.Models) | Select-Object -Unique

            $models | ForEach-Object {
                # Override configured ModelName - this can cause conflicts if not unique
                $model = @{Name = $_}
                $model.Add('ModelFunctions', $Content.ModelFunctions)
                New-AIModel @model -Provider $providerHash['Name']
            }

        }
        if ($PassThru -and $ProviderObject) {$ProviderObject}
    }
    
    end {
        
    }
}