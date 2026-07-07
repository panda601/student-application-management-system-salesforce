# Manual Test Plan & Scenarios: SAMS

This document lists test scenarios to manually verify SAMS features in a Salesforce environment.

---

## Test Scenario 1: Onboarding Registry Wizard Validation
*   **Feature**: `samsApplicationWizard` LWC component.
*   **Objective**: Ensure the wizard blocks empty required fields and executes atomic record creation.

### Execution Steps
1.  Navigate to the SAMS Admissions App and open the **Admissions Registry Wizard**.
2.  Leave **Full Name** empty and try to click **Next**.
    *   *Expected Result*: System flags the field and blocks step progression.
3.  Fill in Step 1, Step 2, and Step 3 details. Verify that **Course Fee** adjusts according to the chosen course.
4.  On Step 4, review the values and click **Register & Submit Application**.
    *   *Expected Result*: Success toast displays. Open the new student record and verify:
        *   Student ID is generated (e.g. `SAMS-2206-0001`).
        *   Application is created and linked.
        *   Deposit payment is created and linked.

---

## Test Scenario 2: Outstanding Balance Approval Block
*   **Feature**: `ApplicationTrigger` & `ApplicationService`.
*   **Objective**: Verify that applications with unpaid balances cannot be approved.

### Execution Steps
1.  Open an active Application record where **Outstanding Balance** is greater than `$0.00`.
2.  Attempt to change the **Status** field to `Approved` and click **Save**.
    *   *Expected Result*: Save fails. An page-level error banner displays: `Cannot approve application with an outstanding balance of $X. Please complete payment first.`
3.  Go to the **Payment Management** LWC on the page.
4.  Log a new payment under **Record New Deposit** equal to the outstanding balance. Click **Post Payment**.
5.  Confirm the Outstanding Balance KPI changes to `$0.00`.
6.  Change the status to `Approved` and save the record.
    *   *Expected Result*: Save succeeds. The student's status changes to `Active` and an approval email is sent.

---

## Test Scenario 3: Duplicate Email Check
*   **Feature**: `StudentService` duplicate validation.
*   **Objective**: Verify that duplicate student registrations with matching email strings are blocked.

### Execution Steps
1.  Create a student record with email `test-student@example.com`. Save successfully.
2.  Attempt to create a second student record using the name `Duplicate Student` and email `test-student@example.com`.
    *   *Expected Result*: Save is blocked. The email field displays an error banner: `A student with this email address already exists.`
