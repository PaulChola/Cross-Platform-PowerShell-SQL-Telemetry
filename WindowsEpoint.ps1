#!/usr/bin/env pwsh
# =====================================================
# Script Name : WindowsEpoint.ps1
# Days        : Day 1 (OS Check)
#               Day 3 (Login & Logout History)
# Purpose     : Windows endpoint session visibility
# Author      : Paul Chola Bwembya Mumbi
# =====================================================

# -------------------------------
# DAY 1: OPERATING SYSTEM CHECK
# -------------------------------

if ($PSVersionTable.PSEdition -ne "Desktop") {
    Write-Host "[!] This script must be run on Windows PowerShell."
    exit
}

Write-Host "`n[+] Operating System Detected: Windows"

# -------------------------------
# DAY 3: LOGIN & LOGOUT HISTORY
# -------------------------------

Write-Host "[+] Collecting login and logout events from Security log..."

# Successful logins
$LoginEvents = Get-WinEvent -FilterHashtable @{
    LogName = 'Security'
    Id      = 4624
} -MaxEvents 50 -ErrorAction SilentlyContinue

# Logouts
$LogoutEvents = Get-WinEvent -FilterHashtable @{
    LogName = 'Security'
    Id      = 4634
} -MaxEvents 50 -ErrorAction SilentlyContinue

$SessionHistory = @()

if ($LoginEvents) {
    $SessionHistory += $LoginEvents | ForEach-Object {
        [PSCustomObject]@{
            User      = $_.Properties[5].Value
            EventType = "Login"
            Time      = $_.TimeCreated
        }
    }
}

if ($LogoutEvents) {
    $SessionHistory += $LogoutEvents | ForEach-Object {
        [PSCustomObject]@{
            User      = $_.Properties[1].Value
            EventType = "Logout"
            Time      = $_.TimeCreated
        }
    }
}

if ($SessionHistory.Count -gt 0) {
    Write-Host "`n[+] Login & Logout History:"
    $SessionHistory | Sort-Object Time -Descending
}
else {
    Write-Host "[!] No login or logout events found in the Security log."
}
