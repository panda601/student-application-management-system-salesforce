# User Guide: Student Application Management System (SAMS)

This document provides step-by-step instructions for using the interactive Lightning Web Components (LWCs) and managing student registrations in SAMS.

---

## 1. Onboarding a New Student & Application

To register a prospective student, configure their course, and process an initial deposit in one seamless transaction, follow these steps:

1.  Navigate to the **SAMS Application** dashboard in your Salesforce Lightning Experience.
2.  Locate and click the **Admissions Registry Wizard** component.
3.  **Step 1: Student Information**
    *   Input the student's **Full Name**, **Email Address**, **Phone Number**, and **Date of Birth** (required fields).
    *   Select their **Student Classification** (`Domestic` or `International`) and input their **Country of Origin**.
    *   Click **Next**.
4.  **Step 2: Course Configurations**
    *   Select the applied **Course** program.
    *   Select the target **Academic Intake** (e.g. `Fall 2026`).
    *   Specify the application type classification (e.g. `Undergraduate` or `Postgraduate`).
    *   Verify the tuition **Course Fee** generated. Click **Next**.
5.  **Step 3: Deposit & Payment Configuration**
    *   Enter the initial **Deposit Amount** (which will be deducted from their total tuition fee).
    *   Select the **Payment Method** (`Credit Card`, `Bank Transfer`, or `PayPal`).
    *   Input the **Transaction Date**. Click **Next**.
6.  **Step 4: Review Submission**
    *   Audit the summarized card values for accuracy.
    *   A unique Student ID (e.g. `SAMS-2026-0001`) will be automatically stamped.

![Admissions Registry Wizard LWC](../screenshots/17-application-wizard.png)

---

## 2. Managing Tuition Fees & Recording Payments

To view transaction history or record new tuition payments for an active applicant:

1.  Open the student's specific **Application** record page.
2.  View the **Payment Management** panel.
3.  Observe the real-time **KPI Balance Tiles**:
    *   **Course Fee**: The total cost of the academic program.
    *   **Paid Amount**: Cumulative sum of all successful payments.
    *   **Outstanding Balance**: Remaining tuition owed.
4.  To record a payment:
    *   Locate the **Record New Deposit** card on the left panel.
    *   Input the **Amount**, **Payment Method**, and **Payment Date**.
    *   Click **Post Payment**.
    *   The transaction is immediately posted to the **Transaction History** ledger.

![Payment Management component](../screenshots/19-payment-management.png)

---

## 3. Running Admissions Approvals & Einstein AI Audit

Admissions Managers can run evaluations and approve records by doing the following:

1.  Navigate to the active **Application** record page.
2.  Review the **Einstein Admission Assistant** scorecard:
    *   Evaluate the **Admission/Approval Probability** score.
    *   Check the **Applicant Drop-out Risk** rating.
    *   Confirm the **Recommended Action Checklist** (e.g., verifying if visa copy or transcripts are missing).
3.  Inspect the **Document Checklist & Verification** panel:
    *   Staff can preview files by clicking the **Preview** button next to Academic Transcripts or Passport copies.
    *   Ensure all necessary files show a status of `Verified` or `Pending Verification`.
4.  Confirm the **Outstanding Balance** KPI shows `$0.00`.
    > [!WARNING]
    > If the student has an outstanding balance, the system will prevent approvals and throw a validation error. Ensure payments are logged to clear the balance.
5.  Submit the record to the approval process or toggle the status field to **Approved**.
6.  Upon saving, the linked Student profile changes to `Active` and an automated email notification is dispatched.

![Application Record Detail with Einstein AI and Verification panels](../screenshots/06-application-record.png)

![Document Upload Checklist component](../screenshots/18-document-upload.png)
