# Deployment & Setup Guide: SAMS

This guide explains how to deploy and configure the SAMS metadata in a Salesforce Scratch Org or Developer Sandbox using the Salesforce DX CLI.

---

## Prerequisites
1.  Install the **Salesforce CLI** (sf v2).
2.  Install **VS Code** with the **Salesforce Extension Pack**.
3.  Sign up for a **Developer Edition Org** or enable Dev Hub in your production environment.

---

## 1. Local Project Setup

Clone the repository and navigate to the project directory:
```bash
git clone https://github.com/your-username/student-application-management-system-salesforce.git
cd student-application-management-system-salesforce
```

---

## 2. Deploy to a Developer Sandbox or Scratch Org

### A. Authorize Target Org
Authorize your Developer Sandbox or Developer Edition Org:
```bash
sf org login web --alias sams-dev --set-default
```
*(Alternatively, create and authorize a new Scratch Org if Dev Hub is configured):*
```bash
sf org create scratch --definition-file config/project-scratch-def.json --alias sams-scratch --set-default --duration-days 30
```

### B. Deploy Metadata Sources
Push all project source code, triggers, layouts, and LWC components to the authorized org:
```bash
sf project deploy start --target-org sams-dev
```

### C. Assign Permission Sets
Assign the administrative `SAMS_Manager` permission set to your active deployment user:
```bash
sf org assign permset --name SAMS_Manager --target-org sams-dev
```
Assign the staff permission set to assistant users:
```bash
sf org assign permset --name SAMS_Staff --target-org sams-dev
```

### D. Load Sample Data
Load test student profiles, applications, and payments from the project data folder using SFDX tree import:
```bash
sf data import tree --files data/Student__c-Application__c-Payment__c-plan.json --target-org sams-dev
```

---

## 3. Post-Deployment Verification

### Run Automated Unit Tests
Verify the code builds and that unit test coverage metrics are met by executing:
```bash
sf apex run test --test-level RunLocalTests --target-org sams-dev --wait 10 --result-format human
```

### Setup Lightning Pages & Dashboards
1.  Open the authorized org: `sf org open`.
2.  Navigate to the **SAMS Application** (from the App Launcher).
3.  Verify the **SAMS Executive Dashboard** renders.
4.  Open any active student application record page and ensure that the **Admissions Wizard**, **Timeline**, **Payment Manager**, **Document Checklist**, and **AI Insights** components are visible.
