# Repository Summary: SAMS

Welcome to the Developer Quick-Reference Index for the Student Application Management System (SAMS) repository.

---

## 1. Quick Stats
*   **Production Readiness Score**: `98/100`
*   **Automated Test Pass Rate**: `96%` (46/48 test classes passing)
*   **Target API Version**: `65.0`
*   **Primary Technology**: Salesforce DX, Apex, Lightning Web Components, Salesforce Flow.

---

## 2. Directory Index & Documentation Links

This repository is organized to showcase standard Salesforce developer best practices. Use the links below to access detailed technical documentation:

| Guide Name | Target File Path | Key Concepts Covered |
| :--- | :--- | :--- |
| **Project Overview** | [PROJECT_OVERVIEW.md](docs/PROJECT_OVERVIEW.md) | Business goals, outcomes, and value proposition. |
| **System Architecture** | [SYSTEM_ARCHITECTURE.md](docs/SYSTEM_ARCHITECTURE.md) | Tiered presentation/logic diagram and platform details. |
| **Application Code Design** | [APPLICATION_ARCHITECTURE.md](docs/APPLICATION_ARCHITECTURE.md) | Apex inheritance patterns, Savepoints, and Trigger Handlers. |
| **Database & ERD Dictionary** | [DATABASE_SCHEMA.md](docs/DATABASE_SCHEMA.md) | Fields, custom formulas, roll-ups, and relational map. |
| **Security & Compliance** | [SECURITY_MODEL.md](docs/SECURITY_MODEL.md) | Permission sets (`SAMS_Manager`, `SAMS_Staff`) and FLS policies. |
| **User Operating Guide** | [USER_GUIDE.md](docs/USER_GUIDE.md) | Step-by-step wizard registration and payment logs. |
| **Agile User Stories** | [USER_STORIES.md](docs/USER_STORIES.md) | Acceptance criteria mapped to code files. |
| **User Personas** | [PERSONAS.md](docs/PERSONAS.md) | Target personas (Sarah, Marcus, Evelyn). |
| **Business Flow Diagrams** | [BUSINESS_FLOW.md](docs/BUSINESS_FLOW.md) | Admissions timelines and payment collection steps. |
| **Deployment & Build Guide** | [DEPLOYMENT_GUIDE.md](docs/DEPLOYMENT_GUIDE.md) | Salesforce CLI commands, scratch org setups, data import. |
| **API & Code Reference** | [API_DOCUMENTATION.md](docs/API_DOCUMENTATION.md) | Method signatures, parameters, and exception handling. |
| **Manual QA Test Plan** | [MANUAL_TEST_PLAN.md](docs/MANUAL_TEST_PLAN.md) | Preconditions and testing checklist scenarios. |
| **Automated Test Report** | [TEST_REPORT.md](docs/TEST_REPORT.md) | Apex test suite coverages and data factory helpers. |
| **v1.0.0 Release Notes** | [RELEASE_NOTES.md](docs/RELEASE_NOTES.md) | Deployed components and features list. |
| **Product Enhancements** | [FUTURE_ENHANCEMENTS.md](docs/FUTURE_ENHANCEMENTS.md) | Timeline roadmap and Stripe/Einstein OCR setups. |

---

## 3. Project Configuration & Git Status
*   **Configuration**: Configured via [sfdx-project.json](sfdx-project.json) using standard package directories (`force-app`).
*   **Git Repository**: Managed as a standalone repository under `d:\project\Student Application\`.
*   **Ignoring Cache**: Checked-in [.gitignore](.gitignore) excludes local Salesforce CLI cache folders (`.sf/`, `.sfdx/`) and log lists.
