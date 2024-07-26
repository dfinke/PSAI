## 0.2.6

- Added `Show-OAIStatus` takes you to the current status of the OpenAI API website

## 0.2.5

- Fix $model to 'gpt-4o-mini'

## v0.2.4

- Update default model to 'gpt-4o-mini' in Invoke-OAIChat.ps1, Invoke-OAIChatCompletion.ps1, and New-OAIAssistant.ps1

## v0.2.3

- Add model `GPT-4o mini`. Most advanced model in the small models category, and cheapest model yet.

## v0.2.2

- Remove unused Show-OAILocalPlayground.tests.ps1 file
- Add Show-OAIBilling function to open OpenAI platform billing
- Update Invoke-OAIChatCompletion.ps1 to handle JSON response
- Update `dumpJson` with `-Depth` parameter to control the depth of the JSON output

## v0.2.1

- Updated `New-OAIThread` to support the the correct payload for the provider
- Updated `Invoke-OAIChatCompletion` to support Azure OpenAI

## v0.2.0

In the latest update to the PSAI module, several new features and enhancements were introduced. This supports the OpenAI V2 capabilities. 

New functions include `Add-OAIVectorStore`, `Enable-AIShortCutKey`, `Enable-OAIFileSearchTool`, and various `Get-`, `New-`, `Remove-`, `Show-`, `Stop-`, and `Update-` commands focusing on vector stores, chat functionalities, and file operations. 

Enhancements were made to existing commands like `Get-AzOAISecrets`, `Get-OAIAssistant`, `Invoke-OAIChat`, and others to improve functionality and performance.

These updates expand the module's capabilities in managing vector stores, enhancing chat interactions, and integrating with OpenAI and Azure services.

## v0.1.2

- Thank you to [Pete Cook](https://github.com/Blindpete) for adding a script designed to identify the top 5 critical events in the Windows event log. [critical-events.ps1](examples/Review-Critical-Events/critical-events.ps1)
- Added [Invoke-FilesToPrompt.ps1](Public/Invoke-FilesToPrompt.ps1) that concatenates a directory full of files into a single prompt for use with LLMs

## v0.1.1

- Fix `Invoke-OAIChat` to handle the userInput and Instructions correctly

## v0.1.0

- Initial release