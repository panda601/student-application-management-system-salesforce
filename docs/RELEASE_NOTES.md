# Release Notes: SAMS v1.0.0 (Initial Release)

We are excited to announce the initial production release of the **Student Application Management System (SAMS) v1.0.0**. This release builds a unified platform in Salesforce for onboarding prospective students, processing applications, tracking payments, and enforcing admissions compliance.

---

## What's New in v1.0.0

### 1. Admissions Registry Wizard LWC
*   A responsive step-by-step onboarding tool.
*   Enables transactional record generation (Student, Application, Payment) in one click.

### 2. Real-time Payment & Balance Ledger
*   The `samsPaymentManagement` LWC on the Application page offers direct KPI tiles for course fees, payments made, and outstanding balance.
*   Enables admissions staff to post payments directly to the ledger.

### 3. Financial Integrity Triggers
*   Enforces the Zero-Balance Approval rule, blocking managers from approving applications where `Outstanding_Balance__c > 0`.

### 4. Einstein AI Admission Assistant Mockup
*   Exposes a predictive probability scorecard, applicant risk metric, and missing document checklist to help managers evaluate applications faster.

### 5. Document Verification Manager
*   File upload and preview capabilities for verification checklists (Transcripts, Passports, English proficiency test reports).

---

## Deployed Components List

*   **Apex Controllers & Services**: `SamsDashboardController`, `StudentService`, `ApplicationService`, `PaymentService`, `NotificationService`.
*   **Triggers**: `StudentTrigger`, `ApplicationTrigger`, `PaymentTrigger`.
*   **Lightning Web Components**: `samsApplicationWizard`, `samsPaymentManagement`, `samsApplicationTimeline`, `samsDocumentManager`, `samsAiRecommendation`, `samsAnalyticsDashboard`, `samsStudentDashboard`.
*   **Permission Sets**: `SAMS_Manager`, `SAMS_Staff`, `SAMS_Manager_Permissions`, `SAMS_Staff_Permissions`.
*   **Custom Objects**: `Student__c`, `Application__c`, `Payment__c`.
