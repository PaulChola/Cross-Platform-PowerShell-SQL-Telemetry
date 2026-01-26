# Cross-Platform PowerShell & SQL Telemetry

## 🔹 Overview

This project is designed to **collect critical endpoint telemetry** such as operating system information, authentication events, and system activity from endpoints (Windows-focused).

Collected data is stored in a **structured SQL database** (SQLite / MariaDB), enabling efficient querying, analysis, and future integration with **SIEM pipelines**.

**Purpose:**  
Support **SOC Analysts** and **Blue Teamers** in detecting suspicious behavior, investigating incidents, and maintaining endpoint visibility.

---

## 🔹 SOC Use Cases

- Detect unauthorized logins or abnormal authentication patterns
- Identify potential privilege escalation activity
- Investigate compromised or suspicious endpoints
- Audit system activity for security and compliance
- Feed structured telemetry into SIEM platforms (Splunk, Microsoft Sentinel, Elastic)

---

## 🔹 Features

- Endpoint telemetry collection via PowerShell
- Authentication / session activity logging
- Hostname and OS metadata collection
- SQL-based structured storage
- Lightweight, modular, and extensible
- Designed with SOC workflows in mind

---

## 🔹 Tech Stack

- **PowerShell** – endpoint data collection  
- **SQLite / MariaDB** – structured telemetry storage  
- **Linux / Windows** – analysis environment  
- Optional: **Python** for enrichment and reporting  

---

## 🔹 Screenshot / Sample Output

### Database Telemetry View (Sanitized)

<p align="center">
  <img src="images/telemetry-db.png" alt="Telemetry Database Screenshot" width="750">
</p>

Example queried data:

| Hostname | Username | EventType | Timestamp        | OS           | Notes          |
|---------|----------|-----------|------------------|--------------|----------------|
| LAPTOP1 | paul     | Logon     | 2026-01-26 10:45 | Windows 10   | Normal login   |
| SERVER1 | admin    | Logoff    | 2026-01-26 10:50 | Windows 2019 | Session ended  |

---

## 🔹 Installation & Usage

### 1️⃣ Clone the Repository
```bash
git clone https://github.com/PaulChola/Cross-Platform-PowerShell-SQL-Telemetry.git
