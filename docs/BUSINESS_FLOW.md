# Business Processes & Workflows: SAMS

This document details the core lifecycle and financial processing flows in SAMS.

---

## 1. Application Lifecycle & Approval Flow

This flow maps how a student's application moves from creation, through verification, financial checks, and final approval/rejection.

```mermaid
graph TD
    A[Wizard Submission] --> B[Application Created: Status = New]
    B --> C[Staff Initiates Document Verification]
    C --> D{All Docs Verified?}
    D -- No --> E[Status = In Review: Request Missing Files]
    E --> C
    D -- Yes --> F[Assess Einstein AI Risk Score]
    F --> G{Outstanding Balance > 0?}
    
    G -- Yes --> H[Block Approval Trigger: Force Payment]
    H --> I[Post Tuition Payment]
    I --> G
    
    G -- No --> J[Manager Grants Final Approval]
    J --> K[Update Student Status to Active]
    K --> L[Send Automated Success Email]
    
    E -- Applicant Abandons --> M[Status = Rejected]
```

---

## 2. Payment Collections & Balance Reconciliation

This flow maps how payments are processed, roll-ups are calculated, and balance alerts are triggered.

```mermaid
graph TD
    A[Initiate Payment Transaction] --> B[Verify Amount > 0]
    B --> C[Insert Payment__c Record: Status = Pending]
    C --> D{Transaction Successful?}
    
    D -- Yes --> E[Set Payment Status = Completed]
    E --> F[Trigger Roll-up Summary on Application]
    F --> G[Recalculate Outstanding Balance]
    G --> H[Send Success Notification Email]
    
    D -- No --> I[Set Payment Status = Failed]
    I --> J[Send Failure Notification Email]
```
| Step | Action | Outcome |
| :--- | :--- | :--- |
| **1** | Initiate Deposit | Payments can be created via wizard or the Payment Management component. |
| **2** | Amount Validation | Validation rule blocks transactions where amount is $\le 0$. |
| **3** | Transaction Logic | System tracks transition. Roll-up sums completed amounts. |
| **4** | Notification Trigger | Apex code sends transactional alerts to target student email. |
