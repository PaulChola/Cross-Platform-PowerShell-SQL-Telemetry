

## Overview

**Cross-Platform PowerShell & SQL Telemetry** is a cybersecurity project that focuses on collecting **endpoint telemetry** from both **Windows and Linux systems** using PowerShell and storing that data in a **SQL database** for analysis.

The collected data enables **endpoint visibility**, **risk assessment**, and **vulnerability analysis** by allowing security practitioners to run structured SQL queries against centralized endpoint information.

This project is designed as a foundation for:

* SOC operations
* Blue team monitoring
* Endpoint security assessments
* SIEM-style data pipelines

---

## Core Concept

**Endpoint → PowerShell → SQL → Analysis**

1. PowerShell runs on Windows and Linux endpoints
2. System and authentication telemetry is collected
3. Data is normalized and stored in a SQL database
4. SQL queries are used to assess risk, exposure, and anomalies

---

## Objectives

* Detect and identify the operating system (Windows or Linux)
* Collect detailed operating system and system metadata
* Gather login and logout activity from endpoints
* Store telemetry data in a SQL database
* Enable risk and vulnerability assessment through queries
* Build a scalable foundation for future SIEM integration

---

## Features

### 1. Cross-Platform OS Detection

* Automatically detects:

  * Windows endpoints
  * Linux endpoints
* Handles unknown or unsupported systems gracefully

---

### 2. Operating System Telemetry

#### Windows

Collected using native Windows APIs (CIM):

* OS name and version
* Build number
* System architecture
* Last boot time

#### Linux

Collected using native GNU/Linux utilities:

* Distribution name
* Logged-in user
* Hostname
* Kernel version
* System architecture
* Uptime

---

### 3. Authentication & Session Telemetry

#### Windows

* Collects authentication events from **Windows Security Logs**
* Event IDs:

  * `4624` – Successful logon
  * `4634` – Logoff
* Captures:

  * Username
  * Event type (Login / Logout)
  * Timestamp

#### Linux

* Collects session history using the `last` command
* Filters out reboot and shutdown entries
* Captures:

  * User
  * Terminal
  * Login time
  * Logout time (best-effort parsing)

---

## Data Storage (SQL)

All collected telemetry is designed to be stored in a **SQL database**, enabling:

* Centralized endpoint visibility
* Historical tracking
* Risk scoring
* Vulnerability trend analysis
* Query-driven investigations

Example analysis use cases:

* Identify stale or rarely rebooted systems
* Detect unusual login patterns
* Track endpoint uptime and exposure
* Compare endpoint configurations for inconsistencies

---

## Project Structure

```text
Cross-Platform-PowerShell-SQL-Telemetry/
│
├── endpoint_telemetry.ps1    # PowerShell telemetry collection script
├── README.md                 # Project documentation
```

---

## Requirements

### Windows

* PowerShell 5.1 or PowerShell 7+
* Administrator privileges (for Security Event Logs)

### Linux

* PowerShell 7+
* Standard GNU/Linux utilities
* Permission to read login history

---

## Usage

```powershell
# Run the telemetry collection script
./endpoint_telemetry.ps1
```

The script outputs:

* Detected operating system
* OS and system information
* Login and logout session history

This output is intended to be **stored in SQL** for further analysis.

---

## Use Cases

* SOC analyst endpoint investigations
* Blue team monitoring and visibility
* Risk assessment and exposure analysis
* Vulnerability assessment support
* PowerShell cross-platform automation practice
* Foundation for SIEM or log aggregation systems

---

## Future Enhancements

Planned improvements include:

* Automated SQL ingestion
* JSON and CSV export options
* Field normalization across operating systems
* Risk scoring logic
* MITRE ATT&CK technique mapping
* Centralized collection from multiple endpoints
* Integration with SIEM platforms

---

## Author

**Paul Chola Bwembya Mumbi**
Cybersecurity | Endpoint Security | Blue Team
Zambia 🇿🇲

---

## Disclaimer

This project is intended for **educational and defensive security purposes only**.
Ensure proper authorization before collecting or storing endpoint telemetry.

