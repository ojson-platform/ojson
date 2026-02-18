---
id: TASK-1.14.2
title: Migrate @ojson/http to @ojson/infra
status: To Do
assignee: []
created_date: '2026-02-18 15:27'
updated_date: '2026-02-18 20:56'
labels:
  - devops
  - metapackage
dependencies:
  - TASK-1.10.8
  - TASK-1.10.10
  - TASK-1.14.6
  - TASK-1.14.7
parent_task_id: TASK-1.14
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Migrate `packages/http` to use `@ojson/infra` configs and tool runners.

Chosen migration mode: **Variant B** (apply `ojson-infra init` with `--force`).

Decisions:
- Keep `.agents/*` managed by infra — OK.
- Do **not** scaffold CI from infra: no `.github/workflows/ci.yml` should appear.
- `tsconfig.json` must extend `@ojson/infra/tsconfig/base` (drop the current Bundler-based setup).

High-level steps:
- Remove conflicting local configs so only infra-managed configs remain (`.prettierrc*`, `vitest.config.ts`, etc.).
- Add `@ojson/infra` as devDependency (`workspace:*`) and remove duplicated toolchain devDeps.
- Run in `packages/http`: `pnpm exec ojson-infra init --yes --force`.
- Ensure `package.json` scripts still work (and don't point to removed config filenames).
- Verify scripts and commit inside the `packages/http` submodule repo.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 `packages/http` uses infra-managed configs:
  - `eslint.config.js` re-exports `@ojson/infra/eslint`
  - `prettier.config.js` re-exports `@ojson/infra/prettier`
  - `vitest.config.mjs` re-exports `@ojson/infra/vitest`
  - `tsconfig.json` extends `@ojson/infra/tsconfig/base` (no Bundler)
- [ ] #2 Conflicting legacy configs are removed (at minimum): `.prettierrc.json`, `vitest.config.ts`.
- [ ] #3 Infra scaffolding creates/updates agent docs:
  - `.agents/*` present
  - `AGENTS.md` contains/updates the managed block between `<!-- OJSON_INFRA_AGENTS:BEGIN -->` and `<!-- OJSON_INFRA_AGENTS:END -->`
- [ ] #4 No new CI workflow is introduced by infra (specifically: no `.github/workflows/ci.yml` is added).
- [ ] #5 `packages/http/package.json` devDependencies are cleaned up: toolchain deps now provided by `@ojson/infra` are removed; `@ojson/infra` is added as `workspace:*`.
- [ ] #6 From `packages/http` directory, scripts succeed:
  - `pnpm -s run lint`
  - `pnpm -s run format:check`
  - `pnpm -s run test:units:fast`
  - `pnpm -s run test:types`
  - `pnpm -s run build`
<!-- AC:END -->

## Implementation Plan

<!-- SECTION:PLAN:BEGIN -->
### Plan (Variant B)

- Prepare `packages/http`:
  - Remove conflicting configs: `.prettierrc*`, `vitest.config.ts` (and any other non-infra configs that would still be discovered by tools).
  - Keep existing `.github/workflows/*` intact.
- Update `packages/http/package.json`:
  - Add `@ojson/infra` to `devDependencies` as `workspace:*`.
  - Remove duplicated toolchain devDependencies (`eslint`, `prettier`, `vitest`, `typescript`, and related plugins) that are now provided by `@ojson/infra`.
  - Ensure scripts still call the tools by name (no hard-coded removed config filenames).
- Run scaffolding (from `packages/http`):
  - `pnpm exec ojson-infra init --yes --force`
- Verify (from `packages/http`):
  - `pnpm -s run lint`
  - `pnpm -s run format:check`
  - `pnpm -s run test:units:fast`
  - `pnpm -s run test:types`
  - `pnpm -s run build`
- Commit in the `packages/http` submodule repo; then update the metapackage submodule pointer commit.
<!-- SECTION:PLAN:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
Notes / constraints:
- `ojson-infra init --force` overwrites managed files; avoid running `init` without `--force` first, otherwise you may get “skipped but applied” state in `.infra.json`.
- TypeScript: we intentionally drop the current Bundler-based `tsconfig.json` in favor of the infra base preset. If compilation fails, prefer adding minimal overrides on top of `extends` (while keeping `extends: "@ojson/infra/tsconfig/base"`).
- CI/workflows: infra should not introduce `.github/workflows/ci.yml` (CI is handled separately in `TASK-1.14.9`).
- Repo boundaries: `packages/http` is a git submodule; the migration requires commits inside the submodule repo, then updating the metapackage pointer.
<!-- SECTION:NOTES:END -->
