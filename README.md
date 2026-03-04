# Bug Tracker — Starter Code

## Development Scenario

Your teammate has been building a simplified bug tracking system and just left for a two-week vacation. They've implemented **core functionality across three classes** — `Developer`, `BugReport`, and `Tracker`. The code runs, but there are no tests yet.

Your team lead wants confidence in the current system before it grows in complexity, so they've asked you to write **comprehensive tests for all the existing code**. This will provide a solid testing foundation and help catch issues before your teammate returns to expand the system.

The current implementation covers the minimum tracking operations: filing bug reports into sprints and reviewing history. Future work will add integrations with pull requests and CI pipelines, but for now the focus is on **testing what already exists**.

## Classes

> Professor's Note: This is a teaching/learning tool. **It is not how real bug trackers work.** Real systems like Jira or GitHub Issues are much more complex and support rich metadata, integrations, and workflows. Here, the design is intentionally minimal.

### Developer

- Represents a developer who files bug reports
- Validates that name and email are provided and that the email is correctly formatted
- Validates that role is one of the allowed values

### BugReport

- Represents a single filed bug report
- Tracks:
    - a unique **12-character SHA-1–based ID**
    - title
    - reporter
    - severity (1–4, where 1 is most critical)
    - timestamp
- Validates report data on creation

### Tracker

- Represents a project bug tracker
- Starts with a single sprint, **`backlog`**
- Can create new sprints (each sprint holds an ordered list of reports)
- Can switch between sprints
- Can file new reports on the current sprint
- Provides a history of reports in a sprint, newest first (`history`)

## Notes

- Reports **do not store stack traces or code diffs** in this version — only metadata.
- Developers **do not track their reports** directly. Reports hold a reference to their `Developer`.
- Sprints are represented as named lists of reports.
- The system enforces only the most basic validations.

Your task: **write tests that confirm all validations, attributes, and Tracker operations behave as expected.**
