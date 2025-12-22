---
name: PowerShell GUI
description: Create graphical user interfaces that can be run from PowerShell on Windows, with actions using PowerShell for business logic
---

# PowerShell GUI Skill

This skill guides the creation of graphical user interfaces (GUIs) using PowerShell on Windows. The GUIs can be built using Windows Forms or WPF, and the actions (button clicks, etc.) execute PowerShell code for business logic.

## Prerequisites

- Windows operating system
- PowerShell 5.1 or higher
- .NET Framework (usually included with Windows)

## Basic Structure

A typical PowerShell GUI script follows this pattern:

1. Load required assemblies
2. Create the main form
3. Add controls (buttons, textboxes, labels, etc.)
4. Define event handlers with PowerShell scriptblocks
5. Show the form and handle the application loop

## Commands and Examples

### Load Windows Forms Assembly

Load the necessary .NET assemblies for Windows Forms.

```powershell
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
```

### Create a Basic Form

Create a simple Windows Form.

```powershell
$form = New-Object System.Windows.Forms.Form
$form.Text = "My PowerShell GUI"
$form.Size = New-Object System.Drawing.Size(300, 200)
$form.StartPosition = "CenterScreen"
```

### Add Controls

Add buttons, textboxes, and other controls to the form.

```powershell
# Create a button
$button = New-Object System.Windows.Forms.Button
$button.Location = New-Object System.Drawing.Point(100, 50)
$button.Size = New-Object System.Drawing.Size(100, 30)
$button.Text = "Click Me"
$form.Controls.Add($button)

# Create a textbox
$textbox = New-Object System.Windows.Forms.TextBox
$textbox.Location = New-Object System.Drawing.Point(50, 100)
$textbox.Size = New-Object System.Drawing.Size(200, 20)
$form.Controls.Add($textbox)
```

### Handle Events with PowerShell Logic

Attach event handlers that execute PowerShell code.

```powershell
$button.Add_Click({
    # Business logic here
    $name = $textbox.Text
    [System.Windows.Forms.MessageBox]::Show("Hello, $name!", "Greeting")
    
    # Call a PowerShell function
    Do-Something -Parameter $name
})
```

### Show the Form

Display the form and start the application loop.

```powershell
$form.ShowDialog()
```

### Complete Example

Here's a complete example of a simple GUI with PowerShell business logic:

```powershell
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Define a function for business logic
function Get-Greeting {
    param($name)
    return "Hello, $name! Welcome to PowerShell GUI."
}

# Create form
$form = New-Object System.Windows.Forms.Form
$form.Text = "PowerShell GUI Example"
$form.Size = New-Object System.Drawing.Size(400, 250)
$form.StartPosition = "CenterScreen"

# Create controls
$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(50, 30)
$label.Size = New-Object System.Drawing.Size(100, 20)
$label.Text = "Enter your name:"
$form.Controls.Add($label)

$textbox = New-Object System.Windows.Forms.TextBox
$textbox.Location = New-Object System.Drawing.Point(150, 30)
$textbox.Size = New-Object System.Drawing.Size(200, 20)
$form.Controls.Add($textbox)

$button = New-Object System.Windows.Forms.Button
$button.Location = New-Object System.Drawing.Point(150, 70)
$button.Size = New-Object System.Drawing.Size(100, 30)
$button.Text = "Greet Me"
$form.Controls.Add($button)

$resultLabel = New-Object System.Windows.Forms.Label
$resultLabel.Location = New-Object System.Drawing.Point(50, 120)
$resultLabel.Size = New-Object System.Drawing.Size(300, 40)
$resultLabel.Text = ""
$form.Controls.Add($resultLabel)

# Event handler with PowerShell business logic
$button.Add_Click({
    $name = $textbox.Text
    if ($name) {
        $greeting = Get-Greeting -name $name
        $resultLabel.Text = $greeting
        
        # Additional business logic
        Write-Host "Greeting displayed for: $name"
    } else {
        [System.Windows.Forms.MessageBox]::Show("Please enter a name.", "Error")
    }
})

# Show the form
$form.ShowDialog()
```

## Advanced Features

### Using WPF

For more modern UIs, use Windows Presentation Foundation (WPF).

```powershell
Add-Type -AssemblyName PresentationFramework

# XAML for the UI
$xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        Title="WPF GUI" Height="200" Width="300">
    <StackPanel Margin="10">
        <TextBlock Text="Enter your name:"/>
        <TextBox Name="NameTextBox" Margin="0,5"/>
        <Button Name="GreetButton" Content="Greet" Margin="0,10"/>
        <TextBlock Name="ResultTextBlock" Margin="0,10"/>
    </StackPanel>
</Window>
"@

# Load XAML
$reader = New-Object System.Xml.XmlNodeReader ([xml]$xaml)
$window = [Windows.Markup.XamlReader]::Load($reader)

# Get controls
$nameTextBox = $window.FindName("NameTextBox")
$greetButton = $window.FindName("GreetButton")
$resultTextBlock = $window.FindName("ResultTextBlock")

# Event handler
$greetButton.Add_Click({
    $name = $nameTextBox.Text
    $resultTextBlock.Text = "Hello, $name!"
})

# Show window
$window.ShowDialog()
```

### Data Binding and Validation

Use PowerShell to handle data binding and validation logic.

### Calling External Scripts

Actions can call external PowerShell scripts for complex business logic.

```powershell
$button.Add_Click({
    & "C:\Scripts\MyBusinessLogic.ps1" -InputData $textbox.Text
})
```

## Best Practices

- Always load required assemblies at the beginning
- Use meaningful names for controls and variables
- Handle errors in event handlers
- Dispose of forms properly when done
- Test on target Windows version
- Consider using modules like 'ShowUI' for simplified syntax (if available)

## Common Controls

- Button: For actions
- TextBox: For text input
- Label: For displaying text
- ComboBox: For selections
- ListBox: For lists
- CheckBox/RadioButton: For options
- ProgressBar: For progress indication

Use these patterns to create rich, interactive GUIs with PowerShell driving the business logic.