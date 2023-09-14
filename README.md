# PowerBIWorkspaceUserMonitor
A PowerShell script for monitoring Power BI workspace users and their roles across multiple workspaces and tenants, with GDPR compliance options. Easily track who has access to what within your Power BI environments.

Monitor and export information about Power BI workspace users across multiple tenants and workspaces.

## Introduction 📊

Welcome to `PowerBIWorkspaceUserMonitor`! This PowerShell script enables you to monitor Power BI workspace users and their respective roles across multiple tenants and workspaces. Use this script to get insights into your workspace users, with an option for GDPR compliance.

## Features 🔍

- Checks if the required Power BI management modules are installed.
- Supports GDPR compliance by hashing email addresses.
- Fetches and exports user data for each workspace and tenant to a CSV file.

## Pre-requisites 🛠

- PowerShell. If you need help, check out [New Stars of Data 2023](https://github.com/Jojobit/Speaking/tree/bcfd8393332398d482756ee7cead7f506bb445e9/New%20Stars%20of%20Data%202023)
- Valid credentials in the form of username and password for each Power BI tenant you intend to monitor.

## How to Use 🚀

1. Clone this repository to your local machine.
2. Populate the `tenants` folder with text files for each tenant. Each text file should be named `Tenant.txt` (where `Tenant` is the name you call the tenant) and contain the username on the first line and password on the second line.
3. Run the script from PowerShell.

## Output Files 🗂

- `users.csv` - Contains information about the workspace users, their roles, and the workspaces and tenants they belong to.

## Note 📝

- The script has a `GDPRCompliance` flag which, when set to `true`, will hash the email addresses to be GDPR compliant.
- The data will be appended to the existing CSV file on each run.

## Let's #BuildSomethingAwesome Together! 🌟

Feel free to contribute or report issues. Your feedback is always welcome!

Happy Monitoring! 😊
