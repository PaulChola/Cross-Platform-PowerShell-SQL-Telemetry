#!/usr/bin/env pwsh
# =====================================================
# Script Name : Query Telemetry Database
# Purpose     : Query and display stored telemetry data
# Author      : Paul Chola Bwembya Mumbi
# =====================================================

param(
    [string]$DatabasePath = "telemetry.db",
    [switch]$Help
)

# Display help information
if ($Help) {
    Write-Host @"
Query Telemetry Database - Help

USAGE:
    .\query_telemetry.ps1 [options]

OPTIONS:
    -DatabasePath   Path to SQLite database file (default: telemetry.db)
    -Help           Show this help message

DESCRIPTION:
    This script queries the telemetry database and displays stored system
    information and session history data.

"@ -ForegroundColor Cyan
    exit
}

# Check if database exists
if (-not (Test-Path $DatabasePath)) {
    Write-Host "Error: Database file '$DatabasePath' not found." -ForegroundColor Red
    exit 1
}

# Check if sqlite3 is available
if (-not (Get-Command sqlite3 -ErrorAction SilentlyContinue)) {
    Write-Host "Error: sqlite3 command not found. Please install SQLite." -ForegroundColor Red
    exit 1
}

Write-Host "Querying telemetry database: $DatabasePath" -ForegroundColor Green
Write-Host "=" * 50

# Function to execute SQLite query and return results
function Invoke-SQLiteQuery {
    param([string]$Query)

    $result = sqlite3 $DatabasePath $Query 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Error executing query: $result" -ForegroundColor Red
        return $null
    }
    return $result
}

# Query SystemInfo table
Write-Host "`nSYSTEM INFORMATION:" -ForegroundColor Yellow
Write-Host "-" * 20

$query = "SELECT Id, Hostname, OS, Timestamp FROM SystemInfo ORDER BY Timestamp DESC;"
$result = Invoke-SQLiteQuery -Query $query

if ($result) {
    # Parse and format the output
    $lines = $result -split "`n"
    foreach ($line in $lines) {
        if ($line -match '\|') {
            $fields = $line -split '\|'
            Write-Host "ID: $($fields[0]) | Hostname: $($fields[1]) | OS: $($fields[2]) | Timestamp: $($fields[3])"
        }
    }
} else {
    Write-Host "No system information found in database." -ForegroundColor Yellow
}

# Query SessionHistory table
Write-Host "`nSESSION HISTORY (Last 10):" -ForegroundColor Yellow
Write-Host "-" * 25

$query = "SELECT Id, Hostname, User, EventType, Time, Terminal, Timestamp FROM SessionHistory ORDER BY Timestamp DESC LIMIT 10;"
$result = Invoke-SQLiteQuery -Query $query

if ($result) {
    # Parse and format the output
    $lines = $result -split "`n"
    foreach ($line in $lines) {
        if ($line -match '\|') {
            $fields = $line -split '\|'
            Write-Host "ID: $($fields[0]) | User: $($fields[2]) | Event: $($fields[3]) | Terminal: $($fields[5]) | Time: $($fields[6])"
        }
    }
} else {
    Write-Host "No session history found in database." -ForegroundColor Yellow
}

# Show table counts
Write-Host "`nDATABASE SUMMARY:" -ForegroundColor Yellow
Write-Host "-" * 16

$systemCountQuery = "SELECT COUNT(*) FROM SystemInfo;"
$sessionCountQuery = "SELECT COUNT(*) FROM SessionHistory;"

$systemCount = Invoke-SQLiteQuery -Query $systemCountQuery
$sessionCount = Invoke-SQLiteQuery -Query $sessionCountQuery

Write-Host "SystemInfo records: $($systemCount -replace '\D','')"
Write-Host "SessionHistory records: $($sessionCount -replace '\D','')"

# Show database schema
Write-Host "`nDATABASE SCHEMA:" -ForegroundColor Yellow
Write-Host "-" * 15

Write-Host "`nSystemInfo table:" -ForegroundColor Cyan
Invoke-SQLiteQuery -Query ".schema SystemInfo"

Write-Host "`nSessionHistory table:" -ForegroundColor Cyan
Invoke-SQLiteQuery -Query ".schema SessionHistory"

Write-Host "`nQuery completed." -ForegroundColor Green