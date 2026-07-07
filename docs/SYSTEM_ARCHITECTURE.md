# System Architecture: SAMS

SAMS utilizes the Salesforce multi-tenant platform architecture, separating presentation, business logic, and database layers to ensure security, scalability, and performance.

## 1. System Architecture Diagram

```mermaid
graph TD
    subgraph Presentation Layer
        UI1[samsApplicationWizard LWC]
        UI2[samsPaymentManagement LWC]
        UI3[samsApplicationTimeline LWC]
        UI4[samsDocumentManager LWC]
        UI5[samsAiRecommendation LWC]
    end

    subgraph Controller Layer
        Controller[SamsDashboardController Apex]
    end

    subgraph Service & Handler Layer
        StudentSrv[StudentService Apex]
        AppSrv[ApplicationService Apex]
        PaySrv[PaymentService Apex]
        NotifSrv[NotificationService Apex]
        AppHandler[ApplicationTriggerHandler Apex]
        PayHandler[PaymentTriggerHandler Apex]
    end

    subgraph Automations Layer
        Flows[Record-Triggered & Screen Flows]
        Approval[Approval Processes]
    end

    subgraph Data Layer
        DB[(Salesforce Custom Objects)]
    end

    Presentation Layer --> Controller Layer
    Controller Layer --> Service & Handler Layer
    Service & Handler Layer --> Automations Layer
    Automations Layer --> Data Layer
    Service & Handler Layer --> Data Layer
```

## 2. Layer Descriptions

### A. Presentation Layer (Lightning Web Components)
*   Provides responsive, modern interfaces using **HTML5**, **JavaScript (ES6+)**, and **Vanilla CSS**.
*   Built utilizing the **Salesforce Lightning Design System (SLDS)** to match platform aesthetics.
*   Uses `@wire` service adapters and Apex action calls to load/update database records dynamically.

### B. Controller Layer (Apex Controllers)
*   Exposes `@AuraEnabled` static methods to handle LWC requests.
*   Enforces platform security through `with sharing` declarations.
*   Handles transaction rollbacks using standard database Savepoint APIs.

### C. Service & Handler Layer (Apex Services & Trigger Handlers)
*   Implements Object-Oriented Programming (OOP) patterns, extending a standard base service class.
*   Delegates database triggers to corresponding handler classes (`before/after` operations).
*   Enforces business rules (uniqueness check, zero-balance approval checks) and triggers transaction email updates.

### D. Automations Layer
*   **Flows**: Executes declarative logic such as status field updates or audit log creation.
*   **Approval Process**: Routes records through standard approval queues, mapping them to management roles.

### E. Data Layer (Salesforce Database)
*   Stores data securely in custom objects: `Student__c`, `Application__c`, and `Payment__c`.
*   Enforces field-level validation rules and calculates roll-ups.
