---
id: TASK-1.14.3
title: Migrate @ojson/models to @ojson/infra
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
Migrate `packages/models` to use `@ojson/infra`.

Notes: models may have package-specific lint/tsconfig needs; keep those as a small local layer (extra block) on top of infra rather than forking infra.

Follow TASK-1.14 procedure: remove conflicting configs, add `@ojson/infra` devDependency (`workspace:*`), run `pnpm exec ojson-infra init --yes --force`, verify eslint/prettier/vitest/tsc, document deltas.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 `packages/models` uses `@ojson/infra` configs (re-exports / extends) with any package-specific additions layered locally.
- [ ] #2 Verification commands pass from `packages/models` directory.
<!-- AC:END -->
