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

    $OSInfo = [PSCustomObject]@{
        OSName           = (Get-Content /etc/os-release | Select-String PRETTY_NAME).ToString().Split('=')[1].Trim('"')
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

Write-Host "Operating System Information:"
$OSInfo | Format-List   