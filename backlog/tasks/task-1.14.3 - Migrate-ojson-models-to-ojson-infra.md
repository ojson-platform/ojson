---
id: TASK-1.14.3
title: Migrate @ojson/models to @ojson/infra
status: Done
assignee: []
created_date: '2026-02-18 15:27'
updated_date: '2026-02-19 01:23'
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
- [x] #1 `packages/models` uses `@ojson/infra` configs (re-exports / extends) with any package-specific additions layered locally.
- [x] #2 Verification commands pass from `packages/models` directory.
<!-- AC:END -->

## Research Notes (current state)

<!-- SECTION:NOTES:BEGIN -->
Current `packages/models` state (pre-migration):
- **ESLint**: local `eslint.config.js` (flat config) with `no-restricted-imports` always enabled for `with-*` modules.
- **Prettier**: local `.prettierrc.json` (matches infra config 1:1).
- **Vitest**: local `vitest.config.ts` includes both `src/**/*.spec.ts` and `examples/**/*.spec.ts`.
- **TypeScript**:
  - `tsconfig.json` uses `ts-patch` plugin `./scripts/extensions.js` to rewrite extensionless relative imports to `.js` (ESM-friendly output).
  - Build uses `tspc`, types test uses `tspc -p tsconfig.types.json`.
- **CI**: has its own `.github/workflows/*` already; infra must not introduce extra workflows.

Key requirement for migration:
- Keep the **ts-patch transformer workflow** (so we do not need to add file extensions in source imports), but migrate it to the shared infra transformer (`@ojson/infra/lib/transformer.mjs`) and infra-provided tool runners.
<!-- SECTION:NOTES:END -->

## Proposed file/script deltas (for implementation)

<!-- SECTION:PLAN:BEGIN -->
Expected file changes:
- **Remove**: `.prettierrc.json`, `vitest.config.ts`, `scripts/extensions.js`.
- **Add**: `prettier.config.js` (re-export from infra), `vitest.config.mjs` (layer on top of infra to keep `examples/**/*.spec.ts` in include), `.agents/*`, `.infra.json`.
- **Update**:
  - `eslint.config.js` → re-export `@ojson/infra/eslint` (auto-detect should enable with-* restrictions because `src/with-*` exists).
  - `tsconfig.json` → `extends: "@ojson/infra/tsconfig/base"` + keep `outDir/rootDir/declaration*` + configure `plugins` to use `./node_modules/@ojson/infra/lib/transformer.mjs` + override `module/moduleResolution/target` as needed to preserve current compile behavior.
  - `tsconfig.types.json` should remain (extends `tsconfig.json`) and continue working with transformer.

Expected `package.json` changes:
- Add `@ojson/infra` as `devDependency: "workspace:*"`.
- Remove duplicated toolchain devDependencies supplied by infra (`eslint`, `prettier`, `vitest`, `typescript`, `ts-patch`, and related eslint plugins/configs), keep package-specific dev deps (e.g. `vitest-when`, `husky`, `lint-staged`, OTEL test deps).
- Prefer scripts using tool names (`eslint`, `prettier`, `vitest`, `tsc`) so infra runners are used. Replace direct `tspc` calls with `tsc` (infra `tsc` runner auto-switches to `tspc` when transformer plugins are present).

Verification commands (from `packages/models`):
- `pnpm -s run lint`
- `pnpm -s run format:check`
- `pnpm -s run test:units`
- `pnpm -s run test:types`
- `pnpm -s run build`
<!-- SECTION:PLAN:END -->

## Final Summary

<!-- SECTION:FINAL_SUMMARY:BEGIN -->
Migration completed:
- Configs moved to `@ojson/infra`:
  - `eslint.config.js` uses `@ojson/infra/eslint` (+ local override for `__tests__` files to disable type-aware parsing)
  - `prettier.config.js` re-exports `@ojson/infra/prettier`
  - `vitest.config.mjs` layers on top of `@ojson/infra/vitest` while keeping `examples/**/*.spec.ts`
- TypeScript:
  - `tsconfig.json` extends `@ojson/infra/tsconfig/base`
  - Build keeps extensionless imports via infra transformer (`@ojson/infra/lib/transformer.mjs`)
  - `__tests__` sources are excluded from build compilation
- Toolchain devDependencies removed in favor of `@ojson/infra` runners; `@types/node` kept as a direct devDependency for TS.
- Infra scaffolding applied (`ojson-infra init`) to create `.agents/*`, `.infra.json`, and managed section in `AGENTS.md`.

Verification (from `packages/models`):
- `pnpm -s run lint`
- `pnpm -s run format:check`
- `pnpm -s run test:units:fast`
- `pnpm -s run test:types`
- `pnpm -s run build`
<!-- SECTION:FINAL_SUMMARY:END -->
