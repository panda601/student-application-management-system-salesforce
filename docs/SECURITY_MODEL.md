# Security Model & Access Controls: SAMS

SAMS utilizes standard Salesforce security mechanisms to protect student data and enforce compliance rules.

## 1. Profiles & Permission Sets
Rather than modifying default profiles, SAMS uses two specific permission sets to grant object and field-level permissions:

### A. SAMS Manager (`SAMS_Manager`)
*   **Target Audience**: Admissions Managers & Directors.
*   **Object Permissions**: Full Create, Read, Update, Delete (CRUD) privileges across `Student__c`, `Application__c`, and `Payment__c`.
*   **Field Permissions**: View and edit authority on sensitive financial columns (such as `Course_Fee__c` and `Amount__c`).
*   **System Permissions**: Granted authority to run/approve Salesforce Approval Processes and access full dashboard and reporting folders.

### B. SAMS Staff (`SAMS_Staff`)
*   **Target Audience**: Onboarding specialists and coordinators.
*   **Object Permissions**: Create, Read, and Update (CRU) access on `Student__c`, `Application__c`, and `Payment__c`. Delete access is revoked.
*   **Field Permissions**: Access to view and edit student biographical fields, but restricted from editing historical payment ledgers or course fees directly on the application records (read-only).

---

## 2. Duplicate Match Rules
To ensure data integrity, duplicate checks prevent registering a student profile multiple times:
1.  **Duplicate Rule**: Active on the `Student__c` object.
2.  **Matching Rule**: Compares email strings: `Student__c.Email__c EXACT Match`.
3.  **Action**: If a match is found on insert, creation is blocked, throwing: `A student with this email address already exists.`

---

## 3. Financial Integrity Validations
System-level validation rules ensure logical financial inputs:
*   **Rule**: `Total_Payments_Non_Negative` on `Student__c`/`Application__c` checks that total registered payments are greater than or equal to zero.
*   **Rule**: `Payment_Amount_Valid` on `Payment__c` ensures the transaction amount is strictly positive.
*   **Apex Validation (Zero-Balance Rule)**: The trigger handler enforces that no application status transitions to `Approved` if there is any `Outstanding_Balance__c` remaining on the record.
