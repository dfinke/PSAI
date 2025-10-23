@{
    RootModule        = 'PSToolboxAI.psm1'
    ModuleVersion     = '0.1.0'
    GUID              = 'a1b2c3d4-e5f6-4a5b-8c9d-0e1f2a3b4c5d'
    Author            = 'PSAI Contributors'
    CompanyName       = 'PSAI'
    Copyright         = '© 2025 All rights reserved.'
    Description       = 'Sourcegraph Toolbox integration for PSAI - Enables discovery and loading of toolbox-style tools for AI agents'
    PowerShellVersion = '7.1'
    
    RequiredModules   = @()
    
    FunctionsToExport = @(
        'Get-PSAIToolboxPath'
        'Get-PSAIToolbox'
        'New-PSAIToolboxAgent'
    )
    
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @()
    
    PrivateData       = @{
        PSData = @{
            Tags       = @('PowerShell', 'AI', 'Toolbox', 'Sourcegraph', 'PSAI')
            LicenseUri = 'https://github.com/dfinke/PSAI/blob/main/LICENSE'
            ProjectUri = 'https://github.com/dfinke/PSAI'
        }
    }
}
