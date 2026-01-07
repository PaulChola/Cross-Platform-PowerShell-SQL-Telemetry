#!/usr/bin/env pwsh
# =====================================================
# Script Name : Telemetry Runner
# Purpose     : Run endpoint telemetry collection and data processing
# Author      : Paul Chola Bwembya Mumbi
# =====================================================

param(
    [switch]$Collect,
    [switch]$Export,
    [string]$OutputFormat = "Console",
    [string]$OutputFile = "",
    [switch]$Help,
    [switch]$Menu
)

# Display help information
if ($Help) {
    Write-Host @"
Telemetry Runner - Help

USAGE:
    .\run.ps1 [options]

OPTIONS:
    -Collect        Run telemetry collection (auto-detects OS)
    -Menu           Show interactive menu to choose script
    -Export         Export results to file
    -OutputFormat   Output format: Console, JSON, CSV (default: Console)
    -OutputFile     Output file path (required with -Export)
    -Help           Show this help message

EXAMPLES:
    .\run.ps1 -Collect
    .\run.ps1 -Menu
    .\run.ps1 -Collect -Export -OutputFormat JSON -OutputFile results.json
    .\run.ps1 -Help

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

Available Scripts:
1. Windows Telemetry (WindowsEpoint.ps1)
2. Linux Telemetry (LinuxEpoint.ps1)
3. Cross-Platform Telemetry (endpoint_telemetry.ps1)
4. Exit

"@ -ForegroundColor Cyan

        $choice = Read-Host "Select an option (1-4)"

        switch ($choice) {
            "1" {
                Write-Host "`nStarting Windows telemetry collection..." -ForegroundColor Green
                if (Test-Path ".\WindowsEpoint.ps1") {
                    & ".\WindowsEpoint.ps1"
                } else {
                    Write-Host "Error: WindowsEpoint.ps1 not found!" -ForegroundColor Red
                }
                Read-Host "`nPress Enter to continue"
            }
            "2" {
                Write-Host "`nStarting Linux telemetry collection..." -ForegroundColor Green
                if (Test-Path ".\LinuxEpoint.ps1") {
                    & ".\LinuxEpoint.ps1"
                } else {
                    Write-Host "Error: LinuxEpoint.ps1 not found!" -ForegroundColor Red
                }
                Read-Host "`nPress Enter to continue"
            }
            "3" {
                Write-Host "`nStarting cross-platform telemetry collection..." -ForegroundColor Green
                if (Test-Path ".\endpoint_telemetry.ps1") {
                    & ".\endpoint_telemetry.ps1"
                } else {
                    Write-Host "Error: endpoint_telemetry.ps1 not found!" -ForegroundColor Red
                }
                Read-Host "`nPress Enter to continue"
            }
            "4" {
                Write-Host "`nExiting..." -ForegroundColor Yellow
                return
            }
            default {
                Write-Host "`nInvalid choice. Please select 1-4." -ForegroundColor Red
                Read-Host "`nPress Enter to continue"
            }
        }
    } while ($choice -ne "4")
}

# Function to run telemetry collection
function Invoke-TelemetryCollection {
    Write-Host "Starting endpoint telemetry collection..." -ForegroundColor Green

    # Detect OS and run appropriate script
    if ($IsWindows) {
        Write-Host "Detected Windows system. Running Windows telemetry..." -ForegroundColor Yellow
        & ".\WindowsEpoint.ps1"
    }
    elseif ($IsLinux) {
        Write-Host "Detected Linux system. Running Linux telemetry..." -ForegroundColor Yellow
        & ".\LinuxEpoint.ps1"
    }
    else {
        Write-Host "Unknown operating system. Running cross-platform telemetry..." -ForegroundColor Yellow
        & ".\endpoint_telemetry.ps1"
    }
}

# Function to export results
function Export-TelemetryResults {
    param([string]$Format, [string]$FilePath)

    Write-Host "Exporting telemetry results to $FilePath (Format: $Format)..." -ForegroundColor Green

    # This would need to be implemented based on how you capture the output
    # For now, just show a placeholder
    Write-Host "Export functionality to be implemented..." -ForegroundColor Yellow
}

# Main execution logic
if ($Menu) {
    Show-TelemetryMenu
}
elseif ($Collect) {
    Invoke-TelemetryCollection

    if ($Export) {
        if (-not $OutputFile) {
            Write-Host "Error: -OutputFile parameter is required when using -Export" -ForegroundColor Red
            exit 1
        }
        Export-TelemetryResults -Format $OutputFormat -FilePath $OutputFile
    }
}
elseif ($Help) {
    # Help is handled above
}
else {
    # No parameters specified - show menu by default
    Write-Host "No parameters specified. Launching interactive menu..." -ForegroundColor Yellow
    Start-Sleep -Seconds 1
    Show-TelemetryMenu
}