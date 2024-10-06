<p align="center">
    <img src="Media/PSAI.png" alt="drawing" width="200"/>
</p>

<p align="center">
  <a href="https://x.com/dfinke">
    <img src="https://img.shields.io/twitter/follow/dfinke.svg?style=social&label=Follow%20%40dfinke"></a>
  <a href="https://youtube.com/@dougfinke">
    <img src="https://img.shields.io/youtube/channel/subscribers/UCP47ZkO5EDkoI2sr-3P4ShQ"></a>
</p>

<p align="center">
  <a href="https://www.powershellgallery.com/packages/PSAI/">
    <img src="https://img.shields.io/powershellgallery/v/PSAI.svg"></a>
  <a href="https://www.powershellgallery.com/packages/PSAI/">
    <img src="https://img.shields.io/powershellgallery/dt/PSAI.svg"></a> 
</p>

<p align="center">
    • <a href="https://github.com/dfinke/PSAI/wiki">Documentation</a> •
</p>

# PSAI

Imagine empowering your PowerShell scripts with the intelligence of OpenAI. With PSAI, I’ve transformed how we interact with AI, making it as simple as running a command. PSAI bridges the gap between PowerShell and AI, enabling seamless integration for file searches, data analysis, and more. It's not just about automation; it's about revolutionizing what we can achieve with just a few lines of code. This module opens a world of possibilities, making AI accessible directly from your console and your scripts.

## Autonomous Agents

**PSAI** brings the power of autonomous agents to PowerShell, allowing you to seamlessly integrate AI capabilities into your scripts and terminal workflows. PSAI Agents enable you to build powerful, interactive tools that handle a variety of tasks, all powered by OpenAI's models. From quick calculations to detailed web searches, PSAI offers a flexible and intuitive way to create agents that can autonomously solve complex problems.

Think of PSAI Agents as digital Swiss Army knives—each agent is a specialized tool capable of running calculations, interacting with web services, fetching data, and executing multi-step tasks, all from within your PowerShell console.

Check out [What Are Autonomous Agents](#what-are-autonomous-agents) in this README for more information.

## Philosophy: Be the Automator, Not the Automated

PSAI and Agents embody the principle of "be the automator, not the automated." By giving you the tools to create sophisticated agents, PSAI empowers you to automate repetitive, data-driven tasks and allows you to focus on strategy and creativity.

----

## Installation

```powershell
Install-Module -Name PSAI
```

After installing the module, you can start working with it by getting your [OpenAI API key](#openai-api-key) or [Azure OpenAI secrets](#azure-openai). Or both.

## OpenAI API KEY

Get/Create your OpenAI API key from https://platform.openai.com/account/api-keys.

Then set `$env:OpenAIKey` to your key.

## Azure OpenAI 

After creating an [Azure OpenAI resource](https://learn.microsoft.com/en-us/azure/ai-services/openai/how-to/create-resource?pivots=web-portal), you can use the `PSAI` module to interact with it. 

You need to get the following secrets form the Azure Portal and Azure AI Studio - `apiURI`,`apiVersion`,`apiKey`,`deploymentName`.

```powershell
$secrets = @{
    apiURI         = "<Your Azure OpenAI API URI>"
    apiVersion     = "<Your Azure OpenAI API Version>"
    apiKey         = "<Your Azure OpenAI API Key>"
    deploymentName = "<Your Azure OpenAI Deployment Name>"
}

Set-OAIProvider AzureOpenAI
Set-AzOAISecrets @secrets
```

## Usage

The full set of functions can be found here https://github.com/dfinke/PSAI/wiki/

```powershell
Invoke-OAIChat 'How do I output all files in a directory PowerShell?'
```

### GPT Response

To output all files in a directory using PowerShell, you can use the `Get-ChildItem` cmdlet. Here's an example of how you can do it:


```powershell
Get-ChildItem -Path "C:\Path\To\Directory" -File
```

Replace `"C:\Path\To\Directory"` with the path to the directory whose files you want to output. This command will list only files in the specified directory.

If you want to list all files, including files in subdirectories, you can add the `-Recurse` parameter to `Get-ChildItem`:

```powershell
Get-ChildItem -Path "C:\Path\To\Directory" -File -Recurse
```

This command will recursively list all files in the specified directory and its subdirectories.

Run either of these commands in PowerShell to output all files in a directory.


## What Are Autonomous Agents?

Autonomous agents are AI-driven entities capable of making decisions and completing tasks without continuous human guidance. PSAI Agents combine the scripting power of PowerShell with the intelligence of OpenAI’s models to automate workflows that require both information processing and decision-making capabilities.

### Features of PSAI Agents
- **Modular Tools Integration**: Agents can leverage various specialized tools, such as:
  - **CalculatorTool**: Handles arithmetic and mathematical operations.
  - **WebSearchTool**: Retrieves information from the web.
  - **StockTickerTool**: Fetches stock information in real time.  

- **Customizable Agents**: Create agents that use predefined tools or add custom ones. Easily expand agent capabilities by registering new tools tailored to specific needs.

- **Natural Language Interaction**: Utilize OpenAI models to interpret complex prompts and provide contextual, intelligent responses using natural language.

### Creating Your First Agent

Here’s how to create a simple agent using the **CalculatorTool**:

```powershell
$calculatorTool = New-CalculatorTool
$agent = New-Agent -Tools $calculatorTool -Name "CalculatorAgent" -Description "An agent that performs basic arithmetic operations"
```

Once created, you can interact with the agent using the `Get-AgentResponse` command:

```powershell
$agent | Get-AgentResponse '3 * 5 + 6 - is it prime?'
```

The agent will respond with step-by-step calculations, such as:

```
Multiplying 3 and 5 to get 15
Adding 15 and 6 to get 21
The result of (3 * 5 + 6) is 21, and 21 is not a prime number.
```

### Examples: What PSAI Agents Can Do

Below are a few examples that showcase PSAI's capabilities:

#### **Basic Agent**
Create a simple agent with instructions:

```powershell
$SecretAgent = New-Agent -Instructions "Recipes should be under 5 ingredients"
$SecretAgent | Get-AgentResponse 'Share a breakfast recipe.'
```

#### **Calculator Tool**
A calculator agent can solve arithmetic problems and check properties like primality:

```powershell
param(
    [string]$prompt = 'is 5 * 2 + 1 a prime number?',
    [Switch]$ShowToolCalls
)

$agent = New-Agent -Tools (New-CalculatorTool) -ShowToolCalls:$ShowToolCalls
$agent | Get-AgentResponse $prompt
```

#### **Web Search Tool**
Search for information using the TavilyAI tool:
NOTE: You need to set the `TavilyAIKey` environment variable with your API key. You can get a free key at https://tavily.com.

```powershell
$agent = New-Agent -Tools (New-TavilyAITool) -ShowToolCalls
$agent | Get-AgentResponse 'what is the latest news on PowerShell?'
```

#### **Finance Tool**
Fetch stock market data
NOTE You can obtain an API key from: https://intelligence.financialmodelingprep.com/developer/docs

```powershell
$agent = New-Agent -Tools (New-StockTickerTool) -ShowToolCalls
$agent | Get-AgentResponse 'What did Microsoft, Apple, and Google close at?'
```

#### **Multi-Agent**
Combining multiple tools to handle complex tasks:

```powershell
$tools = $(
  New-TavilyAITool
  New-StockTickerTool
)

$agent = New-Agent -Tools $tools -ShowToolCalls
$agent | Get-AgentResponse 'What did Microsoft close at and the latest news for them?'
```

## Future Roadmap

We are continuously evolving PSAI Agents to meet more diverse automation needs:

- **More Tools**: Including weather information, document parsing, and task automation features.
- **Interactive Sessions**: Richer CLI interactions for more dynamic agent conversations.
- **Workflow Automation**: Agents capable of multi-step workflows that integrate with existing scripts and systems.

## Questions? Feedback?

For questions or feedback, open an issue on GitHub or reach out via [Twitter](https://x.com/dfinke) or [LinkedIn](https://www.linkedin.com/in/douglasfinke/).

Happy Automating!