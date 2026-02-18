---
id: TASK-2.2
title: 'openapi: generation tests'
status: To Do
assignee: []
created_date: '2026-02-17 22:03'
labels:
  - openapi
  - testing
dependencies: []
parent_task_id: TASK-2
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Add automated tests for all key aspects of the generator. There are no tests yet.

**To do** (stage 6 from `openapi-client.md`):

**6.1 Fixtures** — `fixtures/todo-api.yaml` already exists. Add fixtures: single method, path/query/body, base, nested schemas

**6.2 Logic checks** — unit tests for `mapOperations`, `generateTypes`, `generateClient`. Snapshots or explicit assertions (no CLI)

**6.3 Transport integration** — call generated client with mock `bound.request`

**6.4 CLI E2E** (after TASK-2.1) — run command, verify generated files

**Infrastructure**: use Vitest (via `@ojson/infra` after TASK-1.10)
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 `pnpm test` runs vitest
- [ ] #2 `mapOperations` tests cover: path params, query params, body, different HTTP methods
- [ ] #3 `generateTypes` tests cover: object, array, enum, nullable, $ref
- [ ] #4 Integration test: generated client calls `bound.request` with correct route/options
<!-- AC:END -->
