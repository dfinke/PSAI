# <#
# .SYNOPSIS
# Starts a local playground interface that lets you play with OAI
# #>

# function Show-OAILocalPlayground {
#     param(
#         $Port = 8080,
#         $Threads = 2,
#         [switch]$DisableLaunch
#     )
#     $script:port = $port

#     if (-not $ENV:OpenAIKey) {
#         Write-Warning 'No $ENV:OpenAIKey found.'
#     }

#     # When someone clones the PowerShellAIAssistant repo, but it isn't in any PSModulePath, the playground will fail.
#     if (-not (Get-Module -list PowerShellAIAssistant)) {
#         throw 'PowerShellAIAssistant not found in any module directories. Please add a PSModulePath to the correct location if using a custom one. e.g. $ENV:PSModulePath += "; $pwd"'
#     }

#     # This is almost like a proxy function since it is directly stolen from Pode.Web and then edited so that
#     # ConvertTo-PodeWebPage works with advanced parameter blocks on pwsh 7.4+
#     # Also has a slight improvement to use ConvertTo-Json for output results.
#     # Likely remove this function as soon as Pode.Web >v0.8.3 is released.
#     function Convertto-PodeWebPage {
#         [CmdletBinding()]
#         param(
#             [Parameter(ValueFromPipeline = $true)]
#             [string[]]
#             $Commands,

#             [Parameter()]
#             [string]
#             $Module,

#             [switch]
#             $GroupVerbs,

#             [Parameter()]
#             [Alias('NoAuth')]
#             [switch]
#             $NoAuthentication
#         )

#         # if a module was supplied, import it - then validate the commands
#         if (![string]::IsNullOrWhiteSpace($Module)) {
#             Import-PodeModule -Name $Module
#             Export-PodeModule -Name $Module

#             Write-Verbose "Getting exported commands from module"
#             $ModuleCommands = (Get-Module -Name $Module | Sort-Object -Descending | Select-Object -First 1).ExportedCommands.Keys

#             # if commands were supplied validate them - otherwise use all exported ones
#             if (Test-PodeIsEmpty $Commands) {
#                 Write-Verbose "Using all commands in $($Module) for converting to Pages"
#                 $Commands = $ModuleCommands
#             }
#             else {
#                 Write-Verbose "Validating supplied commands against module's exported commands"
#                 foreach ($cmd in $Commands) {
#                     if ($ModuleCommands -inotcontains $cmd) {
#                         throw "Module $($Module) does not contain function $($cmd) to convert to a Page"
#                     }
#                 }
#             }
#         }

#         # if there are no commands, fail
#         if (Test-PodeIsEmpty $Commands) {
#             throw 'No commands supplied to convert to Pages'
#         }

#         $sysParams = [System.Management.Automation.PSCmdlet]::CommonParameters.GetEnumerator() | ForEach-Object { $_ }

#         # create the pages for each of the commands
#         foreach ($cmd in $Commands) {
#             Write-Verbose "Building page for $($cmd)"
#             $cmdInfo = (Get-Command -Name $cmd -ErrorAction Stop)

#             $sets = $cmdInfo.ParameterSets
#             if (($null -eq $sets) -or ($sets.Length -eq 0)) {
#                 continue
#             }

#             # for cmdlets this will be null
#             $ast = $cmdInfo.ScriptBlock.Ast
#             $paramDefs = $null
#             if ($null -ne $ast) {
#                 $paramDefs = $ast.FindAll({ $args[0] -is [System.Management.Automation.Language.ParameterAst] }, $true) | Where-Object {
#                     $_.Parent.Parent.Parent.Name -ieq $cmd
#                 }
#             }

#             $tabs = New-PodeWebTabs -Tabs @(foreach ($set in $sets) {
#                     $elements = @(foreach ($param in $set.Parameters) {
#                             if ($sysParams -icontains $param.Name) {
#                                 continue
#                             }

#                             $type = $param.ParameterType.Name

#                             $default = $null
#                             if ($null -ne $paramDefs) {
#                                 $default = ($paramDefs | Where-Object { $_.DefaultValue -and $_.Name.Extent.Text -ieq "`$$($param.Name)" }).DefaultValue.Value
#                             }

#                             if ($type -iin @('boolean', 'switchparameter')) {
#                                 New-PodeWebCheckbox -Name $param.Name -AsSwitch
#                             }
#                             else {
#                                 switch ($type) {
#                                     'pscredential' {
#                                         New-PodeWebCredential -Name $param.Name
#                                     }

#                                     default {
#                                         $multiple = $param.ParameterType.Name.EndsWith('[]')

#                                         if ($param.Attributes.TypeId.Name -icontains 'ValidateSetAttribute') {
#                                             $values = ($param.Attributes | Where-Object { $_.TypeId.Name -ieq 'ValidateSetAttribute' }).ValidValues
#                                             New-PodeWebSelect -Name $param.Name -Options $values -SelectedValue $default -Multiple:$multiple
#                                         }
#                                         elseif ($param.ParameterType.BaseType.Name -ieq 'enum') {
#                                             $values = [enum]::GetValues($param.ParameterType)
#                                             New-PodeWebSelect -Name $param.Name -Options $values -SelectedValue $default -Multiple:$multiple
#                                         }
#                                         else {
#                                             New-PodeWebTextbox -Name $param.Name -Value $default
#                                         }
#                                     }
#                                 }
#                             }
#                         })

#                     $elements += (New-PodeWebHidden -Name '_Function_Name_' -Value $cmd)

#                     $name = $set.Name
#                     if ([string]::IsNullOrWhiteSpace($name) -or ($set.Name -iin @('__AllParameterSets'))) {
#                         $name = 'Default'
#                     }

#                     $formId = "form_param_$($cmd)_$($name)"

#                     $form = New-PodeWebForm -Name Parameters -Id $formId -Content $elements -AsCard -NoAuthentication:$NoAuthentication -ScriptBlock {
#                         $cmd = $WebEvent.Data['_Function_Name_']
#                         $WebEvent.Data.Remove('_Function_Name_')

#                         $_args = @{}
#                         foreach ($key in $WebEvent.Data.Keys) {
#                             if ($key -imatch '(?<name>.+)_(Username|Password)$') {
#                                 $name = $Matches['name']
#                                 $uKey = "$($name)_Username"
#                                 $pKey = "$($name)_Password"

#                                 if (![string]::IsNullOrWhiteSpace($WebEvent.Data[$uKey]) -and ![string]::IsNullOrWhiteSpace($WebEvent.Data[$pKey])) {
#                                     $creds = (New-Object System.Management.Automation.PSCredential -ArgumentList $WebEvent.Data[$uKey], (ConvertTo-SecureString -AsPlainText $WebEvent.Data[$pKey] -Force))
#                                     $_args[$name] = $creds
#                                 }
#                             }
#                             else {
#                                 if ($WebEvent.Data[$key] -iin @('true', 'false')) {
#                                     $_args[$key] = ($WebEvent.Data[$key] -ieq 'true')
#                                 }
#                                 else {
#                                     if ($WebEvent.Data[$key].Contains(',')) {
#                                         $_args[$key] = ($WebEvent.Data[$key] -isplit ',' | ForEach-Object { $_.Trim() })
#                                     }
#                                     else {
#                                         $_args[$key] = $WebEvent.Data[$key]
#                                     }
#                                 }
#                             }
#                         }

#                         try {
#                     (. $cmd @_args) | ConvertTo-Json | Out-PodeWebTextbox -Multiline -Preformat
#                         }
#                         catch {
#                             $_.Exception | ConvertTo-Json -Depth 0 | Out-PodeWebTextbox -Multiline -Preformat
#                         }
#                     }

#                     New-PodeWebTab -Name $name -Layouts $form
#                 })

#             $group = [string]::Empty
#             if ($GroupVerbs) {
#                 $group = $cmdInfo.Verb
#                 if ([string]::IsNullOrWhiteSpace($group)) {
#                     $group = '_'
#                 }
#             }

#             Add-PodeWebPage -Name $cmd -Icon Settings -Layouts $tabs -Group $group -NoAuthentication:$NoAuthentication
#         }
#     }

#     # Avoid the ugly logic of (-not () -or -not ())
#     if ((Get-Module -list Pode) -and (Get-Module -list Pode.Web)) {}
#     else {
#         # Get enthusiastic consent before installing extra modules on someone's system
#         if ("y" -eq (Read-Host "The local playground requires Pode and Pode.Web. Type 'y' to install to local user from PSGallery")) {
#             if (-not (Get-Module -list Pode)) { Install-Module Pode -Scope CurrentUser -Force }
#             if (-not (Get-Module -list Pode.Web)) { Install-Module Pode.Web -Scope CurrentUser -Force }
#         }
#         else {
#             throw "Pode and Pode.Web are not installed and consent was not given."
#         }
#     }

#     # Pode.Web needs to be in the global scope for runspaces to access functions
#     Import-Module Pode.Web -Scope Global

#     Start-PodeServer -Browse:(-not $DisableLaunch) -StatusPageExceptions Show -Threads $Threads {
#         $endpoint_param = @{
#             Address  = "localhost"
#             Port     = $script:Port
#             Protocol = "Http"
#             Name     = "Local Playground"
#         }
#         Add-PodeEndpoint @endpoint_param

#         # Enable sessions so that user data can be stored server side easily
#         Enable-PodeSessionMiddleware -Duration ([int]::MaxValue)

#         Use-PodeWebTemplates -Title SampleApp -Theme Dark


#         # You want the assistants and history to be accessible regardless of session
#         New-PodeLockable "historyList_lock"
#         Set-PodeState -Name "historyList" -Value @()
#         New-PodeLockable "assistantList_lock"
#         Set-PodeState -Name "assistantList" -Value @()

#         Lock-PodeObject -Name "historyList_lock" -ScriptBlock {
#             Set-PodeState -Name "historyList" -Value ([array](Get-PodeState -Name "historyList") + "Get-OAIAssistant")
#         }
#         $assistantList = Get-OAIAssistant
#         Lock-PodeObject -Name "assistantList_lock" -ScriptBlock {
#             Set-PodeState -Name "assistantList" -Value $assistantList
#         }

#         Add-PodeWebPage -Name CodeHistory -DisplayName "Code history" -ScriptBlock {
#             New-PodeWebCard -Content @(
#                 New-PodeWebTextbox -Name "Cmdlets" -Multiline -ReadOnly -Value (Get-History).CommandLine
#             )
#         }

#         # This page will create a conversation with an assistant, but does not use the boilerplate cmdlets
#         # included in the PowerShellAIAssistant module like New-OAIThreadQuery because it doesn't save any
#         # actual calls to remote resources and doesn't as easily allow for follow up messages
#         Add-PodeWebPage -Name ChatGPT -ScriptBlock {
#             # Provide an all-in-one interface to make it as easy as possible to stay on this page
#             New-PodeWebCard -Content @(
#                 New-PodeWebButton -Name "Update assistant list" -ScriptBlock {
#                     $assistantList = Get-OAIAssistant

#                     Lock-PodeObject -Name "historyList_lock" -ScriptBlock {
#                         Set-PodeState -Name "historyList" -Value ([array](Get-PodeState -Name "historyList") + "Get-OAIAssistant")
#                     }
#                     Lock-PodeObject -Name "assistantList_lock" -ScriptBlock {
#                         Set-PodeState -Name "assistantList" -Value $assistantList
#                     }
#                     Move-PodeWebUrl -Url /pages/ChatGPT
#                 }
#             ) -CssStyle @{"max-width" = "800px" }

#             New-PodeWebCard -Content @(
#                 New-PodeWebForm -Name 'Example' -Content @(
#                     New-PodeWebSelect -Name "Assistant" -Id "Assistant" -Options (@((Get-PodeState -Name "assistantList").id) + "New") -DisplayOptions (@((Get-PodeState -Name "assistantList").Name) + "New (Sample assistant)")
#                     New-PodeWebSelect -Name "Thread" -Id "Thread" -Options (@($WebEvent.Session.Data.Threads.id) + "New...") -SelectedValue $WebEvent.Session.Data.Thread.id
#                     New-PodeWebTextbox -Name 'Message'
#                 ) -ScriptBlock {
#                     if ($WebEvent.Data['Assistant'] -eq "New") {
#                         $assistant = New-OAIAssistant -Name 'Math Tutor' -Instructions 'You are a helpful math assistant. Please explain your answers.'
#                         Lock-PodeObject -Name "assistantList_lock" -ScriptBlock {
#                             $assistantList = Get-PodeState -Name "assistantList"
#                             $assistantList = @($assistantList) + $assistant
#                             Set-PodeState -Name "assistantList" -Value $assistantList
#                         }
#                         Update-PodeWebSelect -Id "Assistant" -SelectedValue $assistant.id -Options (@((Get-PodeState -Name "assistantList").id) + "New") -DisplayOptions (@((Get-PodeState -Name "assistantList").Name) + "New (Sample assistant)")
#                         $assistantID = $assistant.id
#                     }
#                     else {
#                         $assistantID = $WebEvent.Data['Assistant']
#                     }

#                     if ($WebEvent.Data['Thread'] -eq "New...") {
#                         $WebEvent.Session.Data.Thread = New-OAIThread
#                         $WebEvent.Session.Data.Threads = @($WebEvent.Session.Data.Threads) + $WebEvent.Session.Data.Thread | Sort-Object -Unique -Property created_at
#                         @($WebEvent.Session.Data.Threads.id) + "New..." | Update-PodeWebSelect -Id "Thread" -SelectedValue $WebEvent.Session.Data.Thread
#                     }
#                     else {
#                         $WebEvent.Session.Data.Thread = $WebEvent.Session.Data.Threads | Where-Object id -EQ $WebEvent.Data['Thread']
#                     }

#                     New-OAIMessage -ThreadId $WebEvent.Session.Data.Thread.id -Role user -Content $WebEvent.Data['Message'] | Out-Null

#                     $run = New-OAIRun -ThreadId $WebEvent.Session.Data.Thread.id -AssistantId $assistantID
#                     Wait-OAIOnRun -Run $run -Thread $WebEvent.Session.Data.Thread | Out-Null

#                     $messages = Get-OAIMessage -ThreadId $WebEvent.Session.Data.Thread.id -Order asc
#                     $messages.data | Select-Object Role, @{n = 'Message'; e = { $_.content.text.value } } | ForEach-Object {
#                         "{0}: {1}" -f $_.Role, $_.Message
#                         if ($_.Role -eq "Assistant") { "" }
#                     } | Out-String | Out-PodeWebTextbox -Multiline -ReadOnly

#                     Clear-PodeWebTextbox -Name Message
#                 }
#             ) -CssStyle @{"max-width" = "800px" }
#         }



#         ConvertTo-PodeWebPage -Module PowerShellAIAssistant -Commands @(
#             "Get-OAIAssistant"
#             "New-OAIAssistant"
#             # "New-OAIThread"
#             # "New-OAIMessage"
#             "New-OAIRun"
#             # "Wait-OAIOnRun"
#             "Get-OAIMessage"
#             "Remove-OAIThread"
#             "Remove-OAIAssistant"
#         )
#     }
# }
