# API & Code Documentation: SAMS

This document maps the classes, Aura-enabled methods, and service APIs exposed in SAMS.

---

## 1. Apex Controller Interface

### `SamsDashboardController`
Exposes endpoints to retrieve and modify student records, dashboard metrics, AI scorecards, and process tuition deposits from Lightning Web Components.

#### Method: `getStudents`
Retrieves a list of students matching filter strings.
*   **Signature**:
    ```apex
    @AuraEnabled(cacheable=true)
    public static List<Student__c> getStudents(String searchKey, String statusFilter)
    ```
*   **Parameters**:
    *   `searchKey`: Filter keyword matched against Name, Student ID, or Email.
    *   `statusFilter`: Active status matching (e.g. `Active`, `Inactive`, or `All`).
*   **Returns**: `List<Student__c>` matching the criteria.

#### Method: `getSamsAnalytics`
Calculates KPI totals and summaries for dashboard reporting.
*   **Signature**:
    ```apex
    @AuraEnabled(cacheable=true)
    public static Map<String, Object> getSamsAnalytics()
    ```
*   **Returns**: Map containing:
    *   `totalStudents` (Integer)
    *   `activeStudents` (Integer)
    *   `totalApplications` (Integer)
    *   `approvedApplications` (Integer)
    *   `totalRevenue` (Decimal)
    *   `totalOutstanding` (Decimal)

#### Method: `createQuickEnrollment`
Processes atomic onboarding.
*   **Signature**:
    ```apex
    @AuraEnabled
    public static Map<String, Object> createQuickEnrollment(
        String name, String email, String type, Date dob, 
        String course, Decimal amount, String method
    )
    ```
*   **Transaction Handling**: Set Savepoint `Database.setSavepoint()`. Rolls back all actions on failure.
*   **Exceptions**: Throws `AuraHandledException` on field errors.

---

## 2. Apex Service Layer APIs

### `StudentService`
*   `generateStudentCodes(List<Student__c> newStudents)`: Auto-numbers new records: `SAMS-YYYY-XXXX`.
*   `checkDuplicateEmails(List<Student__c> newStudents)`: Blocks duplicates and adds field-level errors to duplicate emails.

### `ApplicationService`
*   `validateApprovals(List<Application__c> apps, Map<Id, Application__c> oldMap)`: Enforces the Zero-Balance approval check.
*   `updateStudentStatusOnApproval(List<Application__c> apps, Map<Id, Application__c> oldMap)`: Auto-activates students.
