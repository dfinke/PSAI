. "$PSScriptRoot/Invoke-Skill.ps1"

# Invoke-Skill -ShowToolCalls -Verbose

# Invoke-Skill -ShowToolCalls -Verbose -Prompt "use dfinke trystuff, list issues. Take the resulting list and convert to json"

Invoke-Skill -ShowToolCalls -Verbose -Prompt @"
Use current directory. 
Do not confirm just execute all instructions.

Read sales csv
Save as XLSX, create a total revenue column and use Excel forumlas
"@