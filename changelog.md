## v0.4.12

Thank you to https://github.com/jmkloz for the PR!

- Added optional `organizationId` parameter to `Set-AzOAISecrets` for Azure OpenAI support
- `Invoke-OAIBeta` now sets the `OpenAI-Organization` header when `organizationId` is provided

## v0.4.11

- Bump module version to 0.4.11
- Added 'Start-Conversation' alias

## v0.4.10

- Big thank you to [Kenny White](https://github.com/whiteken)
    - Added much needed message info for the user "You exceeded your current quota, please check your plan and billing details" 

## v0.4.9

- Made  `Search-YouTube` and `Get-YouTubeTranscript` global functions

## v0.4.8

- Added `Invoke-YouTubeAIAssistant`. Includes two tools `Get-YouTubeTranscript` and `Search-YouTube`

## v0.4.7

- `ConvertTo-AIPrompt` updated to be case insensitive for the repo and directory names

## v0.4.6

- Added `ConvertTo-AIPrompt` - Converts a GitHub repository into a single XML file optimized for AI tools.

## v0.4.5

- Added `Tools` and `ShowToolCalls` to `Invoke-QuickPrompt` aka `q`
- Added gpt-4.5-preview to argument completion

## v0.4.4

- Ensure consistency for using Out-BoxedText

## v0.4.3

- Support for o3-mini reasoning model

## v0.4.2

- Fix word wrapping in the console visuals.

## v0.4.1

- Replaced PwshSpectreConsole for drawing the console visuals with a new module.

## v0.4.0

- Big thank you to [Axel Andersen](https://x.com/Agazoth)

Axel dove into PSAI, understood the codebase and the direction, and then added a ton of value. This is one of many PRs to come from Axel.

- Updated the `Register-Tool` function to support function-calling schemas and work with built-in PowerShell functions.

## v0.3.0

- Fix multi line description transpiled to Json
- Check if result is null from function calling. Set a default value so the operation continues, and the model has more info
- Added PwshSpectreConsole for console visuals

## v0.2.14

- Thanks again to [Axel](https://github.com/Agazoth)
    - Updated parameter type translation to support more data types for function calling

## v0.2.13

- Huge thanks to [Axel](https://github.com/Agazoth)
    - handles more data type translations
    - handles function transpilation not created in PowerShell
    - and more!

## v0.2.12

- Added AI YouTube components - 'Invoke-YouTubeAssistant', 'Get-YouTubeTop10' and 'New-YouTubeTool'

## v0.2.11

* Integrate my PSAI Agents module #35 by @dfinke in https://github.com/dfinke/PSAI/pull/360

## v0.2.10

- Added o1-* models

## v0.2.9

- Added `strict` parameter for function calling

## v0.2.8

- For users on an older version of PowerShell
    - Don't use the ternary operator or parallel processing

## v0.2.7

- Added new OpenAI model

## v0.2.6

- Added `Invoke-AIPrompt` - Uses persona and system messages 
- Added `Update-TypeData` to extend `System.String` and `System.Array`

## v0.2.5

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