#!/usr/bin/env pwsh
# =====================================================
# Script Name : Endpoint Visibility - Linux
# Days        : Day 1 (OS Check)
#               Day 3 (Login & Logout History)
# Purpose     : Linux endpoint session visibility
# Author      : Paul Chola Bwembya Mumbi
# =====================================================

# -------------------------------
# DAY 1: OS CHECK
# -------------------------------

if (-not $IsLinux) {
    Write-Host "[!] This script must be run on Linux."
    exit
}

Write-Host "[+] Operating System: Linux"

# -------------------------------
# DAY 3: LOGIN & LOGOUT HISTORY
# -------------------------------

Write-Host "[+] Collecting login & logout history..."

$SessionHistory = last -F | Where-Object {
    $_ -notmatch "reboot|shutdown"
} | ForEach-Object {

    $parts = $_ -split '\s+'

    [PSCustomObject]@{
        User       = $parts[0]
        Terminal   = $parts[1]
        LoginTime  = "$($parts[4]) $($parts[5]) $($parts[6])"
        LogoutTime = if ($parts.Count -ge 10) {
            "$($parts[8]) $($parts[9])"
        } else {
            "Still Logged In"
        }
    }
}

$SessionHistory
