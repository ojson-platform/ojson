---
id: TASK-1.14
title: Migrate all packages to @ojson/infra (configs + deps cleanup)
status: To Do
assignee: []
created_date: '2026-02-18 15:25'
labels:
  - metapackage
  - devops
dependencies:
  - TASK-1.10.8
  - TASK-1.10.10
parent_task_id: TASK-1
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Goal: migrate all packages to consume dev tooling from `@ojson/infra` in a controlled, per-package way.

Motivation: `@ojson/infra` is intended to be truly "one devDependency" (it provides configs, scaffolding, and tool runners via `bin` overrides). Packages should stop carrying duplicated ESLint/Prettier/Vitest/TS config and tool dependencies.

Per-package procedure (recommended):
1) Remove/rename conflicting config files in the package root (examples: `eslint.config.*`, `prettier.config.*` / `.prettierrc*`, `vitest.config.*`, optionally `tsconfig.json` if you switch to extends).
2) Remove tool dependencies that should now be supplied by `@ojson/infra` (eslint/prettier/vitest/typescript and related plugins), unless the package has a strong reason to pin a tool directly.
3) Add `@ojson/infra` as devDependency (in metapackage: `workspace:*`).
4) Run scaffolding from the package root:
   - `pnpm exec ojson-infra init --yes --force`
   Use `--force` to avoid partial "skipped but applied" state.
5) Verify in that package:
   - `pnpm exec eslint src`
   - `pnpm exec prettier --check "src/**/*.ts"` (or package-equivalent)
   - `pnpm exec vitest --run`
   - optionally `pnpm exec tsc --noEmit` (if TS presets adopted)
6) Decide whether to keep the package migrated or revert (git) and record the decision.

Important caveats:
- Running `ojson-infra init` without `--force` can skip existing files and still mark migrations as applied in `.infra.json`.
- If a package installs tool runners directly, pnpm may prefer those bins over `@ojson/infra`'s overrides.

Out of scope: pnpm migration / lockfile migration (tracked separately in TASK-1.11).
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 Each target package is migrated in its own subtask with the above procedure and a recorded verification log (what was removed, what was generated, what commands were run).
- [ ] #2 After migration, package root uses config re-exports / extends from `@ojson/infra` (ESLint/Prettier/Vitest; TS optionally via extends).
- [ ] #3 After migration, tool runner deps are removed where appropriate (eslint/prettier/vitest/typescript etc.), relying on `@ojson/infra` one-dependency model unless intentionally pinned.
- [ ] #4 For each migrated package, `pnpm exec eslint`, `pnpm exec prettier`, and `pnpm exec vitest` run successfully in the package directory (workspace consumption).
<!-- AC:END -->
