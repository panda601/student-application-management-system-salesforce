# User Stories: SAMS

This document maps user stories, business requirements, and acceptance criteria to metadata features and backend services in SAMS.

---

## Story 1: Onboarding Registry
**As a** prospective student,
**I want** to submit my personal details, course selection, and initial deposit in a unified form,
**so that** I don't have to navigate multiple complex objects or processes.

### Acceptance Criteria
1.  **Atomic Creation**: Creating a student profile, creating an application, and posting a deposit must be executed within a single transaction. If one step fails, the entire transaction is rolled back.
2.  **Required Validations**: Essential details (Email, Date of Birth, Course Fee, Classification) must be validated prior to submission.
3.  **Auto-Generation**: A unique `Student_ID__c` must be stamped in the format `SAMS-YYYY-XXXX` upon successful submission.
4.  **Confirmations**: An email confirmation is sent automatically to the applicant.

### Implemented Feature Map
*   **Front-end**: `samsApplicationWizard` LWC component.
*   **Back-end**: `@AuraEnabled` method `createQuickEnrollment` inside `SamsDashboardController.cls` with transactional Savepoints.
*   **Automations**: `StudentService.cls` for student ID formatting.

---

## Story 2: Outstanding Balance Validation
**As a** university financial manager,
**I want** the system to enforce that no application status is changed to Approved unless all tuition fees have been paid,
**so that** we avoid unpaid enrollments.

### Acceptance Criteria
1.  **Block Approval**: If an application status transitions to `Approved` while `Outstanding_Balance__c > 0`, the edit is blocked.
2.  **Detailed Messages**: The validation error must display the exact outstanding amount: `Cannot approve application with an outstanding balance of $X. Please complete payment first.`

### Implemented Feature Map
*   **Back-end Triggers**: `ApplicationTrigger.trigger` listening to `before insert` and `before update`.
*   **Service Class**: `ApplicationService.cls` (method `validateApprovals`).

---

## Story 3: On-Approval Account Activation
**As an** admissions manager,
**I want** the system to set the applicant's student status to Active as soon as their application is approved,
**so that** they can access student portal systems.

### Acceptance Criteria
1.  **Auto-Update**: When `Application__c.Status__c` changes to `Approved`, the corresponding `Student__c.Status__c` is immediately updated to `Active`.
2.  **Notification**: An automated approval confirmation email containing course details is dispatched to the student's email address.

### Implemented Feature Map
*   **Back-end Triggers**: `ApplicationTrigger.trigger` listening to `after update`.
*   **Service Class**: `ApplicationService.cls` (method `updateStudentStatusOnApproval`) and `NotificationService.cls` (method `sendEmailNotification`).
