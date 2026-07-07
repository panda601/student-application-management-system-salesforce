# Contributing to SAMS

Thank you for your interest in contributing to the Student Application Management System (SAMS)! We welcome feedback, issue reports, and pull requests to make this project even better.

## How to Contribute

### 1. Reporting Bugs & Requesting Features
*   Search the open Issues list to see if your topic is already under discussion.
*   If not, open a new Issue, describing the problem or proposal clearly. Include step-by-step instructions to reproduce the bug.

### 2. Developing Code
*   Fork this repository.
*   Create a local branch: `git checkout -b feature/your-feature-name` or `bugfix/your-fix-name`.
*   Ensure your development follows standard Salesforce DX directory structures and metadata guidelines.
*   Write Apex unit tests for any new Apex controller or service classes, maintaining coverage above 85%.
*   Verify that your Lightning Web Components have proper styling conforming to Salesforce Lightning Design System (SLDS).

### 3. Submitting Pull Requests (PRs)
*   Ensure all tests pass and there are no linting errors.
*   Submit your pull request against the `main` branch.
*   Provide a clear summary of your changes and reference any related issues (e.g. `Closes #12`).

## Code Style Guide
*   **Apex**: Keep business logic in helper service classes (`*Service.cls`) and delegate triggers to handler classes (`*TriggerHandler.cls`).
*   **LWC**: Maintain descriptive variable names, clean template rendering, and encapsulate logic into reusable subcomponents where applicable.
*   **Naming Conventions**: PascalCase for custom metadata/objects/classes, camelCase for JavaScript files/variables.
