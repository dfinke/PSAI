<#
.SYNOPSIS
This script is designed to identify the top 5 critical events in the Windows event log.

.DESCRIPTION
The script provides a step-by-step guide on how to analyze the Windows event log and prioritize events based on their potential impact or importance. It filters the event log based on specific criteria and then organizes the events in descending order of importance. Finally, it provides a brief summary of each of the top 5 events, highlighting why they are critical.

.PARAMETER None

.EXAMPLE
.\critical-events.ps1
This command runs the script and identifies the top 5 critical events in the Windows event log.

.NOTES
- This script requires administrative privileges to access the Windows event log.
- The script outputs the results in markdown format.
- The script analyzes events from various event log sources, including Application, Security, System, and others.
- The severity levels considered for filtering are Level 1, Level 2, and Level 3.
- The script provides guidance on how to review and prioritize events based on their severity, impact, or relevance to system operation.
#>
#Requires -RunAsAdministrator

$aiinput = @'
You will be tasked with identifying the top 5 things in the Windows event log provided. Here's how you should proceed:
1. Begin by reviewing the Windows event log that has been provided to you. 
2. Look for entries in the log that stand out as critical events. These could include errors or warnings.
3. Identify the three most important or noteworthy entries based on their severity, impact, or relevance to system operation.
4. Once you have identified the top 5 events, organize them in descending order of importance, with the most critical event listed first.
5. Provide a brief summary of each of the top 5 events, highlighting why they are critical.
6. When you are ready to present your findings, list the top 3 events in order of importance with a short summary for each entry.
7. Remember to be concise but informative in your summaries, focusing on the key details that make each event stand out in the log.
Please make sure to carefully analyze the log and prioritize events based on their potential impact or importance.
Allways Output markdown format
`n
'@

$eventfilter = @'
<QueryList>
  <Query Id="0" Path="Application">
    <Select Path="Application">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="Security">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="System">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="HardwareEvents">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="Intel-GFX-Info/Application">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="Intel-GFX-Info/System">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="Internet Explorer">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="Key Management Service">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="Microsoft-AppV-Client/Admin">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="Microsoft-AppV-Client/Virtual Applications">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="Microsoft-Windows-All-User-Install-Agent/Admin">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="Microsoft-Windows-AppHost/Admin">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="Microsoft-Windows-Application Server-Applications/Admin">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="Microsoft-Windows-AppModel-Runtime/Admin">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="Microsoft-Windows-AppReadiness/Admin">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="Microsoft-Windows-AssignedAccess/Admin">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="Microsoft-Windows-AssignedAccessBroker/Admin">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="Microsoft-Windows-Storage-ATAPort/Admin">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="Microsoft-Windows-BitLocker-DrivePreparationTool/Admin">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="Microsoft-Client-Licensing-Platform/Admin">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="Microsoft-Windows-Containers-CCG/Admin">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="Microsoft-Windows-DataIntegrityScan/Admin">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="Microsoft-Windows-DataIntegrityScan/CrashRecovery">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="Microsoft-Windows-DSC/Admin">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="Microsoft-Windows-DeviceManagement-Enterprise-Diagnostics-Provider/Admin">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="Microsoft-Windows-DeviceManagement-Enterprise-Diagnostics-Provider/Autopilot">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="Microsoft-Windows-DeviceSetupManager/Admin">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="Microsoft-Windows-Dhcp-Client/Admin">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="Microsoft-Windows-Dhcpv6-Client/Admin">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="Microsoft-Windows-Diagnosis-Scripted/Admin">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="Microsoft-Windows-Storage-Disk/Admin">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="Microsoft-Windows-DxgKrnl-Admin">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="Microsoft-Windows-EDP-Application-Learning/Admin">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="Microsoft-Windows-EDP-Audit-Regular/Admin">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="Microsoft-Windows-EDP-Audit-TCB/Admin">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="Microsoft-Client-License-Flexible-Platform/Admin">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="Microsoft-Windows-GenericRoaming/Admin">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="Microsoft-Windows-Guest-Network-Service-Admin">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="Microsoft-Windows-Host-Network-Service-Admin">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="Microsoft-Windows-HostGuardianClient-Service/Admin">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="Microsoft-Windows-HostGuardianService-CA/Admin">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="Microsoft-Windows-HostGuardianService-Client/Admin">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="Microsoft-Windows-Hyper-V-Compute-Admin">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="Microsoft-Windows-Hyper-V-Config-Admin">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="Microsoft-Windows-Hyper-V-Guest-Drivers/Admin">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="Microsoft-Windows-Hyper-V-Hypervisor-Admin">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="Microsoft-Windows-Hyper-V-StorageVSP-Admin">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="Microsoft-Windows-Hyper-V-VID-Admin">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="Microsoft-Windows-Hyper-V-VMMS-Admin">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="Microsoft-Windows-Hyper-V-VMMS-Networking">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="Microsoft-Windows-Hyper-V-VMMS-Storage">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="Microsoft-Windows-Hyper-V-VMSP-Admin">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="Microsoft-Windows-Hyper-V-Worker-Admin">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="Microsoft-Windows-Kernel-EventTracing/Admin">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="Microsoft-Windows-KeyboardFilter/Admin">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="Microsoft-Windows-ModernDeployment-Diagnostics-Provider/Admin">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="Microsoft-Windows-ModernDeployment-Diagnostics-Provider/Autopilot">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="Microsoft-Windows-ModernDeployment-Diagnostics-Provider/Diagnostics">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="Microsoft-Windows-ModernDeployment-Diagnostics-Provider/ManagementService">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="Microsoft-Windows-MUI/Admin">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="Microsoft-Windows-PowerShell/Admin">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="Microsoft-Windows-PrintBRM/Admin">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="Microsoft-Windows-PrintService/Admin">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="Microsoft-Windows-Provisioning-Diagnostics-Provider/Admin">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="Microsoft-Windows-Provisioning-Diagnostics-Provider/AutoPilot">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="Microsoft-Windows-Provisioning-Diagnostics-Provider/ManagementService">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="Microsoft-Windows-PushNotification-Platform/Admin">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="Microsoft-Windows-RemoteApp and Desktop Connections/Admin">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="Microsoft-Windows-RemoteAssistance/Admin">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="Microsoft-Windows-RemoteDesktopServices-RdpCoreTS/Admin">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="Microsoft-Windows-RetailDemo/Admin">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="Microsoft-Windows-SecurityMitigationsBroker/Admin">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="Microsoft-Windows-SmartCard-TPM-VCard-Module/Admin">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="Microsoft-Windows-SMBDirect/Admin">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="Microsoft-Windows-SMBWitnessClient/Admin">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="Microsoft-Windows-Storage-Tiering/Admin">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="Microsoft-Windows-Storage-ClassPnP/Admin">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="Microsoft-Windows-Storage-Storport/Admin">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="Microsoft-Windows-TerminalServices-ClientUSBDevices/Admin">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="Microsoft-Windows-TerminalServices-LocalSessionManager/Admin">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="Microsoft-Windows-TerminalServices-PnPDevices/Admin">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="Microsoft-Windows-TerminalServices-Printers/Admin">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="Microsoft-Windows-TerminalServices-RemoteConnectionManager/Admin">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="Microsoft-Windows-TerminalServices-ServerUSBDevices/Admin">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="Microsoft-Windows-Troubleshooting-Recommended/Admin">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="Microsoft-Windows-User Device Registration/Admin">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="Microsoft-Windows-VerifyHardwareSecurity/Admin">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="Microsoft-Windows-WindowsBackup/ActionCenter">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="Microsoft-Windows-Workplace Join/Admin">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="OAlerts">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="OneApp_IGCC">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="OpenSSH/Admin">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="USER_ESRV_SVC_QUEENCREEK">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
    <Select Path="Windows PowerShell">*[System[(Level=1  or Level=2 or Level=3)]]</Select>
  </Query>
</QueryList>
'@

# only use glow if you have it installed
$aiinput += (Get-WinEvent -FilterXml $eventfilter -MaxEvents 15 | ConvertTo-Xml).OuterXml
$result = ai $aiinput -model:gpt-4 

if (Get-Command glow -ErrorAction SilentlyContinue) {
  $result | glow
} else {
  $result        
}