---
id: TASK-1.14.2
title: Migrate @ojson/http to @ojson/infra
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
Migrate `packages/http` to use `@ojson/infra` configs and tool runners.

Steps:
- Remove/rename conflicting files: `eslint.config.js`, `.prettierrc.json` (or other prettier configs), `vitest.config.ts`.
- Add `@ojson/infra` as devDependency (`workspace:*`).
- Run in `packages/http`: `pnpm exec ojson-infra init --yes --force`.
- Verify in `packages/http`:
  - `pnpm exec eslint src`
  - `pnpm exec prettier --check "src/**/*.ts"`
  - `pnpm exec vitest --run`
  - optionally `pnpm exec tsc --noEmit`
- Decide whether to keep migration or revert and document.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 `packages/http` uses `@ojson/infra` via `eslint.config.js`, `prettier.config.js`, `vitest.config.mjs` (and optionally `tsconfig.json` extends).
- [ ] #2 `packages/http` no longer carries duplicated tool deps that are now supplied by `@ojson/infra` (unless explicitly justified).
- [ ] #3 All verification commands pass from `packages/http` directory.
<!-- AC:END -->
