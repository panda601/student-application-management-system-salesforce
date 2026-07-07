# User Personas: SAMS

This document profiles the core personas interacting with the Student Application Management System (SAMS).

---

## 1. Prospective Student: Sarah Jenkins
*   **Role**: Applicant
*   **Objective**: Easily submit enrollment details, track application progress online, upload requested checklists, and pay tuition fees.
*   **Pain Points**:
    *   Confused by complicated forms requiring different login screens.
    *   Wants real-time visibility into when their transcript or passport copies have been received and verified.
*   **System Interaction**:
    *   Fills out the `samsApplicationWizard` registry.
    *   Views progress statuses on `samsApplicationTimeline`.
    *   Uploads verification documents using the `samsDocumentManager`.

---

## 2. Admissions Specialist: Marcus Reynolds
*   **Role**: SAMS Staff
*   **Objective**: Manage incoming applicant streams, verify submitted high school transcripts, review passport documents, and post tuition payments.
*   **Pain Points**:
    *   Manually updating student records across multiple tables is time-consuming.
    *   Difficult to track who has completed payments vs. who has outstanding balances.
*   **System Interaction**:
    *   Reviews profiles using the **Student Directory**.
    *   Uploads and previews files using `samsDocumentManager`.
    *   Logs student tuition payments in the `samsPaymentManagement` panel.
*   **Access Level**: `SAMS_Staff` Permission Set (CRU access, restricted delete, read-only on payment ledger overrides).

---

## 3. Admissions Director: Dr. Evelyn Vance
*   **Role**: SAMS Manager
*   **Objective**: Approve final admissions files, audit application metrics, review risk factor recommendations, and report overall enrollment progress.
*   **Pain Points**:
    *   Unknowingly approving students who have not completed their enrollment deposits.
    *   Needs pipeline charts and summaries for monthly executive meetings.
*   **System Interaction**:
    *   Reviews risk scorecard recommendations via `samsAiRecommendation`.
    *   Approves or rejects applications in Salesforce.
    *   Views executive charts using the `samsAnalyticsDashboard` and reports.
*   **Access Level**: `SAMS_Manager` Permission Set (Full CRUD access, approval authority, folder edit access).
