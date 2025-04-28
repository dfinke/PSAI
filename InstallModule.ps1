param ($fullPath)

if (-not $fullPath) {
    $fullpath = $env:PSModulePath -split ":(?!\\)|;|," | Select-Object -First 1
    $fullPath = Join-Path $fullPath -ChildPath "PSAI"
}

Push-location $PSScriptRoot

Robocopy . $fullPath /mir /XD .vscode images .git .github CI __tests__ data mdHelp spikes /XF README.md README.original.md .gitattributes .gitignore filelist.txt install.ps1 InstallModule.ps1 PublishToGallery.ps1

Pop-Location