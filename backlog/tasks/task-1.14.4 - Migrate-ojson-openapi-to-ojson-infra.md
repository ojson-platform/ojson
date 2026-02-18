---
id: TASK-1.14.4
title: Migrate @ojson/openapi to @ojson/infra
status: To Do
assignee: []
created_date: '2026-02-18 15:27'
labels:
  - devops
  - metapackage
dependencies:
  - TASK-1.10.8
  - TASK-1.10.10
parent_task_id: TASK-1.14
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Migrate `packages/openapi` to use `@ojson/infra` where applicable.

Notes: openapi may not currently run vitest; still apply ESLint/Prettier/TS presets and document what is (and isn't) adopted.

Follow TASK-1.14 procedure with verification appropriate to this package (lint/format at minimum).
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 `packages/openapi` uses `@ojson/infra` for ESLint/Prettier (and TS presets if applicable).
- [ ] #2 If vitest is not used in this package, document rationale; otherwise ensure vitest config works.
- [ ] #3 Lint/format (and tests if present) run successfully.
<!-- AC:END -->
