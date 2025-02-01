Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force

if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Этот скрипт необходимо запускать от имени администратора!" -ForegroundColor Red
    exit
}

New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows Defender\Features" -Name "TamperProtection" -Value 0 -PropertyType DWord -Force

Set-MpPreference -DisableRealtimeMonitoring $true
Set-MpPreference -DisableBehaviorMonitoring $true
Set-MpPreference -DisableBlockAtFirstSeen $true
Set-MpPreference -DisableIOAVProtection $true
Set-MpPreference -DisablePrivacyMode $true
Set-MpPreference -SignatureDisableUpdateOnStartupWithoutEngine $true
Set-MpPreference -DisableArchiveScanning $true
Set-MpPreference -DisableIntrusionPreventionSystem $true
Set-MpPreference -DisableScriptScanning $true

Stop-Service -Name WinDefend -Force
Set-Service -Name WinDefend -StartupType Disabled

New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "EnableSmartScreen" -Value 0 -PropertyType DWord -Force
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name "SmartScreenEnabled" -Value "Off" -PropertyType String -Force

New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\MicrosoftEdge\PhishingFilter" -Name "EnabledV9" -Value 0 -PropertyType DWord -Force

New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "EnableSmartScreen" -Value 0 -PropertyType DWord -Force

New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender" -Name "DisableAntiSpyware" -Value 1 -PropertyType DWord -Force
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender" -Name "DisableRoutinelyTakingAction" -Value 1 -PropertyType DWord -Force

$DefenderPath = "$env:ProgramData\Microsoft\Windows Defender"
if (Test-Path $DefenderPath) {
    icacls $DefenderPath /deny SYSTEM:(OI)(CI)F
}

New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Signature Updates" -Name "ForceUpdateFromMU" -Value 0 -PropertyType DWord -Force

Stop-Service -Name SecurityHealthService -Force
Set-Service -Name SecurityHealthService -StartupType Disabled

New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender" -Name "DisableAntiSpyware" -Value 1 -PropertyType DWord -Force
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender" -Name "DisableRoutinelyTakingAction" -Value 1 -PropertyType DWord -Force

Get-ScheduledTask | Where-Object { $_.TaskName -like "*Windows Defender*" } | Disable-ScheduledTask

New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Security Center" -Name "AntiVirusOverride" -Value 1 -PropertyType DWord -Force

Write-Host "Windows Defender, SmartScreen, Security Center, Tamper Protection и задачи Defender отключены! Перезагрузите компьютер для применения изменений." -ForegroundColor Green
