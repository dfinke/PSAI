# PSAI Module: Empowering PowerShell with Autonomous AI Agents

## Overview

**PSAI** brings the power of autonomous agents to PowerShell, allowing you to seamlessly integrate AI capabilities into your scripts and terminal workflows. PSAI Agents enable you to build powerful, interactive tools that handle a variety of tasks, all powered by OpenAI's models. From quick calculations to detailed web searches, PSAI offers a flexible and intuitive way to create agents that can autonomously solve complex problems.

Think of PSAI Agents as digital Swiss Army knives—each agent is a specialized tool capable of running calculations, interacting with web services, fetching data, and executing multi-step tasks, all from within your PowerShell console.

## What Are Autonomous Agents?

Autonomous agents are AI-driven entities capable of making decisions and completing tasks without continuous human guidance. PSAI Agents combine the scripting power of PowerShell with the intelligence of OpenAI’s models to automate workflows that require both information processing and decision-making capabilities.

### Features of PSAI Agents
- **Modular Tools Integration**: Agents can leverage various specialized tools, such as:
  - **CalculatorTool**: Handles arithmetic and mathematical operations.
  - **WebSearchTool**: Retrieves information from the web.
  - **StockTickerTool**: Fetches stock information in real time.  

- **Customizable Agents**: Create agents that use predefined tools or add custom ones. Easily expand agent capabilities by registering new tools tailored to specific needs.

- **Natural Language Interaction**: Utilize OpenAI models to interpret complex prompts and provide contextual, intelligent responses using natural language.

## Getting Started

### Installation

To start using PSAI, install it from the PowerShell gallery:

```powershell
Install-Module -Name PSAI
```

Ensure you have set up the required API keys for services such as OpenAI, stock market data providers, and others as needed.

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

```powershell
param(
    [string]$prompt = 'what is the latest news on PowerShell?',
    [Switch]$ShowToolCalls
)

$agent = New-Agent -Tools (New-TavilyAITool) -ShowToolCalls:$ShowToolCalls
$agent | Get-AgentResponse $prompt
```

#### **Finance Tool**
Fetch stock market data:

```powershell
param(
    [string]$prompt = 'What did Microsoft, Apple, and Google close at?',
    [Switch]$ShowToolCalls
)

$agent = New-Agent -Tools (New-StockTickerTool) -ShowToolCalls:$ShowToolCalls
$agent | Get-AgentResponse $prompt
```

#### **Multi-Agent**
Combining multiple tools to handle complex tasks:

```powershell
param(
    [string]$prompt = 'What did Microsoft close at and the latest news for them?',
    [Switch]$ShowToolCalls
)

$tools = $(New-TavilyAITool; New-StockTickerTool)
$agent = New-Agent -Tools $tools -ShowToolCalls:$ShowToolCalls
$agent | Get-AgentResponse $prompt
```

## Philosophy: Be the Automator, Not the Automated

PSAI Agents embody the principle of "be the automator, not the automated." By giving you the tools to create sophisticated agents, PSAI empowers you to automate repetitive, data-driven tasks and allows you to focus on strategy and creativity.

## Future Roadmap

We are continuously evolving PSAI Agents to meet more diverse automation needs:

- **More Tools**: Including weather information, document parsing, and task automation features.
- **Interactive Sessions**: Richer CLI interactions for more dynamic agent conversations.
- **Workflow Automation**: Agents capable of multi-step workflows that integrate with existing scripts and systems.

## Questions? Feedback?

For questions or feedback, open an issue on GitHub or reach out via [Twitter](https://x.com/dfinke) or [LinkedIn](https://www.linkedin.com/in/douglasfinke/).

Happy Automating!