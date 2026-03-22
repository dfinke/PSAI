# PSAI Project Conventions

## Build & Development Commands
- **Install Dependencies:** `Import-Module ./PSAI.psd1 -Force`
- **Run Tests:** `Invoke-Pester ./Tests` (Ensure Pester 5.x is used)
- **Static Analysis:** `Invoke-ScriptAnalyzer -Path ./PSAI.psm1`
- **Build Module:** `./Build/BuildModule.ps1` (if applicable)

## Engineering Standards & Patterns
- **Architecture:** Follow High-Agency Agent patterns. Decouple LLM logic from PowerShell provider logic.
- **TDD:** All new features or bug fixes must include a corresponding Pester test in the `/Tests` directory.
- **Style:** Follow the [PowerShell Practice and Style Guide](https://poshcode.gitbooks.io/powershell-practice-and-style-guide/).
- **Naming:** Use standard `Verb-Noun` pairs. Avoid aliases in module code.
- **Error Handling:** Use `try/catch` blocks for all API calls; provide meaningful error objects to the LLM context.

## Agentic Workflow
- When refactoring, maintain the "Be the Automator, Not the Automated" philosophy.
- Tools should be modular and discoverable via `Get-Command -Module PSAI`.
- Reference the `ConvertTo-AIPrompt` logic when packaging codebase context for LLM windows.