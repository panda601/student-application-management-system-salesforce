# Database Schema & Entity Dictionary: SAMS

This document provides a detailed schema dictionary of the custom objects and fields implemented in the SAMS application.

## 1. Entity Relationship Diagram (ERD)

```mermaid
erDiagram
    STUDENT ||--o{ APPLICATION : "has"
    APPLICATION ||--|{ PAYMENT : "collects"
    
    STUDENT {
        String Name "Full Name"
        String Student_ID__c "Unique Sequenced ID (SAMS-YYYY-XXXX)"
        String Email__c "Primary Contact Email (Unique)"
        String Phone__c "Contact Phone"
        Date Date_of_Birth__c "Birth Date"
        Number Age__c "Formula (Years)"
        String Student_Type__c "Domestic / International"
        String Status__c "Active / Inactive / Suspended"
        String Country__c "Country of origin"
        String Address__c "Full residential address"
    }
    
    APPLICATION {
        String Name "Auto-Number (APP-XXXX)"
        Lookup Student__c "Lookup to Student__c"
        String Course__c "Selected Academic Program"
        String Intake__c "Target Intake Term"
        Decimal Course_Fee__c "Tuition Cost"
        String Status__c "New / In Review / Approved / Rejected"
        String Approval_Status__c "Formula Indicator"
        Decimal Total_Payments__c "Roll-up Summary (Payments)"
        Decimal Outstanding_Balance__c "Formula (Fee - Payments)"
        Percent Application_Progress__c "Formula Indicator"
    }

    PAYMENT {
        String Name "Auto-Number (PAY-XXXX)"
        Lookup Application__c "Lookup to Application__c"
        Decimal Amount__c "Transaction Value"
        Date Payment_Date__c "Date Settled"
        String Payment_Method__c "Credit Card / Bank / PayPal"
        String Payment_Status__c "Pending / Completed / Failed"
    }
```

## 2. Field Dictionary & Metadata Configuration

### Student__c
*   **Object Label**: Student
*   **Plural Label**: Students
*   **Name Field**: Student Name (Text)
*   **Key Fields**:
    *   `Student_ID__c`: Unique, External ID field. Indexed. Format generated dynamically by trigger: `SAMS-YYYY-XXXX`.
    *   `Email__c`: Email field with system uniqueness rule checked.
    *   `Age__c`: Formula field calculating age from birth date:
        ```text
        FLOOR((TODAY() - Date_of_Birth__c) / 365.2425)
        ```

### Application__c
*   **Object Label**: Application
*   **Plural Label**: Applications
*   **Name Field**: Application Number (Auto-Number: `APP-{0000}`)
*   **Key Fields**:
    *   `Student__c`: Lookup relation back to the Student. Required.
    *   `Total_Payments__c`: Roll-up Summary field calculating the `SUM` of related `Payment__c.Amount__c` where `Payment_Status__c = 'Completed'`.
    *   `Outstanding_Balance__c`: Formula field displaying tuition balance:
        ```text
        Course_Fee__c - Total_Payments__c
        ```
    *   `Application_Progress__c`: Formula field returning percent of tuition paid:
        ```text
        IF(Course_Fee__c > 0, Total_Payments__c / Course_Fee__c, 0)
        ```

### Payment__c
*   **Object Label**: Payment
*   **Plural Label**: Payments
*   **Name Field**: Payment Number (Auto-Number: `PAY-{0000}`)
*   **Key Fields**:
    *   `Application__c`: Lookup relation back to the Application. Required.
    *   `Amount__c`: Decimal currency field representing paid money. Must be non-negative.
