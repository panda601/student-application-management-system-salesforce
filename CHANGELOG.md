# Changelog

All notable changes to the **Student Application Management System (SAMS)** will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-07-07

### Added
*   **Custom Objects**:
    *   `Student__c` to manage biographical data.
    *   `Application__c` to manage enrollment records.
    *   `Payment__c` to track financial transactions.
*   **Apex Service Architecture**:
    *   `StudentService.cls` with unique Student ID generator and duplicate email validations.
    *   `ApplicationService.cls` for student activation and outstanding balance validations.
    *   `PaymentService.cls` for payment audit trails.
    *   `NotificationService.cls` for handling template emails.
*   **Interactive Lightning Web Components (LWCs)**:
    *   `samsApplicationWizard`: Multi-step registry tool.
    *   `samsPaymentManagement`: Real-time payment processing and ledger.
    *   `samsApplicationTimeline`: Interactive stage stepper.
    *   `samsDocumentManager`: Upload and checklist system.
    *   `samsAiRecommendation`: Einstein AI scorecard mockup.
    *   `samsAnalyticsDashboard`: Dashboard widgets.
*   **Declarative Automations**:
    *   4 Record-triggered flows for data alignments.
    *   `Application_Wizard` screen flow.
    *   Manager approval routing rules.
*   **Reports & Dashboards**:
    *   `SAMS_Executive_Dashboard` for metrics visualizations.
