#!/usr/bin/env pwsh
# =====================================================
# Script Name : Endpoint Visibility - Month 01
# Days        : Day 1 (OS Detection) + Day 2 (OS Info)
#               + Day 3 (Login & Logout History)
# Purpose     : Detect OS and collect endpoint telemetry
# Author      : Paul Chola Bwembya Mumbi
# =====================================================


# -------------------------------
# DAY 1: OPERATING SYSTEM DETECTION
# -------------------------------

# List of supported operating systems
$PCName = @("Windows", "Linux", "Unknown")

# Initialize OS variable
$os = $null

# Detect Windows PowerShell (Desktop Edition)
if ($PSVersionTable.PSEdition -eq "Desktop") {
    $os = $PCName[0]
}

# Detect Linux (PowerShell Core)
elseif ($IsLinux) {
    $os = $PCName[1]
}

# Fallback if OS is not detected
else {
    $os = $PCName[2]
}

Write-Host "Detected Operating System: $os"


# -------------------------------
# DAY 2: OPERATING SYSTEM DETAILS
# -------------------------------

# Initialize OS information variable
$OSInfo = $null

# -------------------------------
# Windows OS Information
# -------------------------------
if ($os -eq $PCName[0]) {

    $OSInfo = Get-CimInstance Win32_OperatingSystem | Select-Object `
        Caption,
        Version,
        BuildNumber,
        LastBootUpTime
}

# -------------------------------
# Linux OS Information
# -------------------------------
elseif ($os -eq $PCName[1]) {

    try {
        $osReleaseContent = Get-Content /etc/os-release
        $prettyNameMatch = $osReleaseContent | Select-String -Pattern '^PRETTY_NAME='
        if ($prettyNameMatch) {
            $OSName = $prettyNameMatch.Line.Split('=')[1].Trim('"')
        } else {
            $OSName = "Unknown Linux Distribution"
        }
    } catch {
        $OSName = "Unable to read /etc/os-release"
    }

    $OSInfo = [PSCustomObject]@{
        OSName           = $OSName
        LoggedInUser     = (whoami)
        LoggedInTerminal = (tty)
        Hostname         = (hostname)
        Architecture     = (uname -m)
        KernelVersion    = (uname -r)
        PcProcessor      = (uname -p)
        GnuLinux         = (uname -o)
        Uptime           = (uptime -p)
    }
}

# Unknown OS handling
else {
    $OSInfo = "OS information could not be collected"
}

Write-Host "`nOperating System Information:"
$OSInfo | Format-List


# -------------------------------
# DAY 3: LOGIN & LOGOUT HISTORY
# -------------------------------

$SessionHistory = $null

# -------------------------------
# Windows Login & Logout History
# -------------------------------
if ($os -eq $PCName[0]) {

    try {
        $Logins = Get-WinEvent -FilterHashtable @{
            LogName = 'Security'
            Id = 4624
        } -MaxEvents 50 -ErrorAction Stop | ForEach-Object {
            [PSCustomObject]@{
                User      = $_.Properties[5].Value
                EventType = "Login"
                Time      = $_.TimeCreated
            }
        }
    } catch {
        $Logins = @()
    }

    try {
        $Logouts = Get-WinEvent -FilterHashtable @{
            LogName = 'Security'
            Id = 4634
        } -MaxEvents 50 -ErrorAction Stop | ForEach-Object {
            [PSCustomObject]@{
                User      = $_.Properties[1].Value
                EventType = "Logout"
                Time      = $_.TimeCreated
            }
        }
    } catch {
        $Logouts = @()
    }

    $SessionHistory = $Logins + $Logouts | Sort-Object Time -Descending
}

# -------------------------------
# Linux Login & Logout History
# -------------------------------
elseif ($os -eq $PCName[1]) {

    try {
        $SessionHistory = last -F 2>/dev/null | Where-Object {
            $_ -notmatch "reboot|shutdown"
        } | ForEach-Object {
            $parts = $_ -split '\s+'
            if ($parts.Count -ge 11) {
                [PSCustomObject]@{
                    User       = $parts[0]
                    Terminal   = $parts[1]
                    LoginTime  = "$($parts[4]) $($parts[5]) $($parts[6])"
                    LogoutTime = "$($parts[8]) $($parts[9]) $($parts[10])"
                }
            }
        }
    } catch {
        $SessionHistory = "Unable to retrieve session history"
    }
}

# Unknown OS handling
else {
    $SessionHistory = "Session history could not be collected"
}

Write-Host "`nLogin & Logout History:"
$SessionHistory | Format-Table -AutoSize
