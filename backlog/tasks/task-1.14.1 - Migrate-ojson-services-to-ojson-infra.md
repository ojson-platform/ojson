---
id: TASK-1.14.1
title: Migrate @ojson/services to @ojson/infra
status: To Do
assignee: []
created_date: '2026-02-18 15:26'
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
Migrate `packages/services` to use `@ojson/infra` configs and tool runners. Follow TASK-1.14 procedure and validate lint/format/test.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 `packages/services` uses `@ojson/infra` configs (re-exports / extends).
- [ ] #2 Verification commands pass from `packages/services` directory.
<!-- AC:END -->
