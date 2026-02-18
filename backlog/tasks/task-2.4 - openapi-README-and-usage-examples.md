---
id: TASK-2.4
title: 'openapi: README and usage examples'
status: To Do
assignee: []
created_date: '2026-02-17 22:04'
labels:
  - openapi
  - docs
dependencies: []
parent_task_id: TASK-2
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
The current README is minimal. Add a proper guide with examples.

**To do** (stage 7 from `openapi-client.md`):
- Installation, running the generator via CLI
- Examples: `prebuild` script, using `--base`, `compose` + `withAuth`/`withRetry`
- Options `x-retries`, `x-base`
- CLI options table

**Depends on**: TASK-2.1 (CLI must be finalized)
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 README includes example with `prebuild` script
- [ ] #2 All CLI options documented
- [ ] #3 Example with `compose(http, withAuth(...), withRetry(...))`
<!-- AC:END -->
