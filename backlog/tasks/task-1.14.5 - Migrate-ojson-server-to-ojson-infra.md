---
id: TASK-1.14.5
title: Migrate @ojson/server to @ojson/infra
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
Migrate `packages/server` to use `@ojson/infra` configs and tool runners. Follow TASK-1.14 procedure; ensure build/test remain green.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 `packages/server` uses `@ojson/infra` configs (re-exports / extends).
- [ ] #2 Lint/format/test/build commands pass after migration.
<!-- AC:END -->
