#!/usr/bin/env pwsh
# =====================================================
# Script Name : Single Telemetry Script
# Purpose     : Cross-platform endpoint telemetry collection in one script
# Author      : Paul Chola Bwembya Mumbi
# =====================================================

param(
    [switch]$Help,
    [switch]$Menu,
    [switch]$Store
)

# Import MySQL connector if storing data
if ($Store) {
    # Check if mysql command is available
    if (-not (Get-Command mysql -ErrorAction SilentlyContinue)) {
        Write-Host "Error: mysql command not found. Please install MySQL client." -ForegroundColor Red
        exit 1
    }
}

# Function to initialize database
function Initialize-TelemetryDatabase {
    try {
        # Create tables using mysql command
        $createSystemInfoTable = @"
CREATE TABLE IF NOT EXISTS SystemInfo (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    Hostname VARCHAR(255),
    OS VARCHAR(50),
    OSInfo TEXT,
    Timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
);
"@

        $createSessionHistoryTable = @"
CREATE TABLE IF NOT EXISTS SessionHistory (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    Hostname VARCHAR(255),
    User VARCHAR(100),
    EventType VARCHAR(20),
    Time DATETIME,
    Terminal VARCHAR(50),
    Timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
);
"@

        # Execute table creation
        $createSystemInfoTable | mysql -u telemetry_user -ptelemetry_pass telemetry_db
        if ($LASTEXITCODE -ne 0) { throw "Failed to create SystemInfo table" }

        $createSessionHistoryTable | mysql -u telemetry_user -ptelemetry_pass telemetry_db
        if ($LASTEXITCODE -ne 0) { throw "Failed to create SessionHistory table" }

        Write-Host "MySQL database initialized successfully" -ForegroundColor Green
    } catch {
        Write-Host "Error initializing database: $($_.Exception.Message)" -ForegroundColor Red
        throw
    }
}

# Function to store system info
function Store-SystemInfo {
    param([string]$Hostname, [string]$OS, [string]$OSInfoJson)

    try {
        # Escape single quotes in the data
        $escapedHostname = $Hostname -replace "'", "\'"
        $escapedOS = $OS -replace "'", "\'"
        $escapedOSInfo = $OSInfoJson -replace "'", "\'"

        $query = "INSERT INTO SystemInfo (Hostname, OS, OSInfo) VALUES ('$escapedHostname', '$escapedOS', '$escapedOSInfo');"

        $query | mysql -u telemetry_user -ptelemetry_pass telemetry_db
        if ($LASTEXITCODE -ne 0) { throw "Failed to insert system info" }
    } catch {
        Write-Host "Error storing system info: $($_.Exception.Message)" -ForegroundColor Red
        throw
    }
}

# Function to convert time string to MySQL datetime format
function Convert-ToMySQLDateTime {
    param([string]$TimeString)

    try {
        # Handle "still logged in" and other non-datetime strings
        if ($TimeString -match "still logged|crash|down|-") {
            return $null
        }

        # Try to parse the time string
        # Format is typically like "Jan 6 14:47:41" or "Dec 30 19:27:06"
        if ($TimeString -match '^(\w{3})\s+(\d{1,2})\s+(\d{1,2}):(\d{2}):(\d{2})$') {
            $month = $matches[1]
            $day = [int]$matches[2]
            $hour = [int]$matches[3]
            $minute = [int]$matches[4]
            $second = [int]$matches[5]

            # Convert month name to number
            $monthNames = @{
                'Jan' = 1; 'Feb' = 2; 'Mar' = 3; 'Apr' = 4; 'May' = 5; 'Jun' = 6;
                'Jul' = 7; 'Aug' = 8; 'Sep' = 9; 'Oct' = 10; 'Nov' = 11; 'Dec' = 12
            }

            if ($monthNames.ContainsKey($month)) {
                $monthNum = $monthNames[$month]
                $currentYear = (Get-Date).Year

                # Create DateTime object
                $dateTime = New-Object DateTime $currentYear, $monthNum, $day, $hour, $minute, $second

                # Return MySQL format
                return $dateTime.ToString("yyyy-MM-dd HH:mm:ss")
            }
        }

        # If parsing fails, return null
        return $null
    } catch {
        return $null
    }
}

# Function to store session history
function Store-SessionHistory {
    param([string]$Hostname, [array]$Sessions)

    try {
        foreach ($session in $Sessions) {
            # Convert time to MySQL format
            $mysqlTime = Convert-ToMySQLDateTime -TimeString $session.Time

            # Skip entries where time conversion failed
            if ($null -eq $mysqlTime) {
                continue
            }

            # Escape single quotes in the data
            $escapedHostname = $Hostname -replace "'", "\'"
            $escapedUser = $session.User -replace "'", "\'"
            $escapedEventType = $session.EventType -replace "'", "\'"
            $escapedTime = $mysqlTime -replace "'", "\'"
            $escapedTerminal = $session.Terminal -replace "'", "\'"

            $query = "INSERT INTO SessionHistory (Hostname, User, EventType, Time, Terminal) VALUES ('$escapedHostname', '$escapedUser', '$escapedEventType', '$escapedTime', '$escapedTerminal');"

            $query | mysql -u telemetry_user -ptelemetry_pass telemetry_db
            if ($LASTEXITCODE -ne 0) { throw "Failed to insert session history" }
        }
    } catch {
        Write-Host "Error storing session history: $($_.Exception.Message)" -ForegroundColor Red
        throw
    }
}

# Display help information
if ($Help) {
    Write-Host @"
Single Telemetry Script - Help

USAGE:
    .\single_telemetry.ps1 [options]

OPTIONS:
    -Menu           Show interactive menu
    -Store          Store collected data in MySQL database
    -Help           Show this help message

EXAMPLES:
    .\single_telemetry.ps1
    .\single_telemetry.ps1 -Menu
    .\single_telemetry.ps1 -Store
    .\single_telemetry.ps1 -Help

DATABASE:
    When using -Store, data is saved to MySQL database 'telemetry_db'
    Requires MySQL server running with user 'telemetry_user'

"@ -ForegroundColor Cyan
    exit
}

# Function to display interactive menu
function Show-TelemetryMenu {
    do {
        Clear-Host
        Write-Host @"
========================================
   Endpoint Telemetry Collection Menu
========================================

Available Options:
1. Run Telemetry Collection
2. Run Telemetry Collection & Store in Database
3. Exit

"@ -ForegroundColor Cyan

        $choice = Read-Host "Select an option (1-3)"

        switch ($choice) {
            "1" {
                Write-Host "`nStarting telemetry collection..." -ForegroundColor Green
                Invoke-TelemetryCollection
                Read-Host "`nPress Enter to continue"
            }
            "2" {
                Write-Host "`nStarting telemetry collection with database storage..." -ForegroundColor Green
                $script:Store = $true
                Invoke-TelemetryCollection
                Read-Host "`nPress Enter to continue"
            }
            "3" {
                Write-Host "`nExiting..." -ForegroundColor Yellow
                return
            }
            default {
                Write-Host "`nInvalid choice. Please select 1-3." -ForegroundColor Red
                Read-Host "`nPress Enter to continue"
            }
        }
    } while ($choice -ne "3")
}

# Function to run telemetry collection
function Invoke-TelemetryCollection {
    # Initialize database if storing
    if ($Store) {
        Initialize-TelemetryDatabase
    }

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
    $hostname = $null

    # -------------------------------
    # Windows OS Information
    # -------------------------------
    if ($os -eq $PCName[0]) {
        $OSInfo = Get-CimInstance Win32_OperatingSystem | Select-Object `
            Caption,
            Version,
            BuildNumber,
            LastBootUpTime
        $hostname = $env:COMPUTERNAME
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
        $hostname = hostname
    }

    # Unknown OS handling
    else {
        $OSInfo = "OS information could not be collected"
        $hostname = "Unknown"
    }

    Write-Host "`nOperating System Information:"
    $OSInfo | Format-List

    # Store system info if requested
    if ($Store) {
        $osInfoJson = $OSInfo | ConvertTo-Json -Compress
        Store-SystemInfo -Hostname $hostname -OS $os -OSInfoJson $osInfoJson
        Write-Host "`nSystem information stored in database." -ForegroundColor Green
    }

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
                    $loginTime = "$($parts[4]) $($parts[5]) $($parts[6])"
                    $logoutTime = "$($parts[8]) $($parts[9]) $($parts[10])"

                    # Create login event
                    [PSCustomObject]@{
                        User       = $parts[0]
                        EventType  = "Login"
                        Time       = $loginTime
                        Terminal   = $parts[1]
                    }

                    # Create logout event if logout time is not empty and not "still logged in"
                    if ($logoutTime -and $logoutTime -notmatch "still logged in" -and $logoutTime -notmatch "crash|down") {
                        [PSCustomObject]@{
                            User       = $parts[0]
                            EventType  = "Logout"
                            Time       = $logoutTime
                            Terminal   = $parts[1]
                        }
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
    if ($SessionHistory -is [array] -and $SessionHistory.Count -gt 0) {
        $SessionHistory | Format-Table User, Terminal, Time, EventType -AutoSize
    } else {
        Write-Host $SessionHistory
    }

    # Store session history if requested
    if ($Store -and $SessionHistory -is [array] -and $SessionHistory.Count -gt 0) {
        Store-SessionHistory -Hostname $hostname -Sessions $SessionHistory
        Write-Host "`nSession history stored in database." -ForegroundColor Green
    }
}

# Main execution logic
if ($Menu) {
    Show-TelemetryMenu
}
else {
    # No parameters specified - run collection directly
    Invoke-TelemetryCollection
}