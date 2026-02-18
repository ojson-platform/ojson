---
id: TASK-1.10.5
title: '@ojson/infra: Vitest config with coverage'
status: Done
assignee: []
created_date: '2026-02-17'
labels:
  - devops
  - metapackage
dependencies:
  - TASK-1.10.1
parent_task_id: TASK-1.10
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Add Vitest base config exported as default from `@ojson/infra/vitest`. Include test include pattern (e.g. `src/**/*.spec.ts`), coverage with v8 provider, reporters (text, json, html, lcov), and standard excludes (node_modules, build, spec files, config files). ESM file (e.g. `vitest.config.mjs`).
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 File implementing `@ojson/infra/vitest` exists and exports default defineConfig result
- [x] #2 Config includes coverage (v8) with include/exclude and reporters
- [x] #3 A consuming package can do `export { default } from '@ojson/infra/vitest'` and run tests with coverage
<!-- AC:END -->

## Implementation Plan

<!-- SECTION:PLAN:BEGIN -->
### Findings

**Reference configs**
- **packages/http**, **packages/server**: `defineConfig` from `vitest/config`, `test.include: ['src/**/*.spec.ts']`, `coverage.provider: 'v8'`, `coverage.reporter: ['text', 'json', 'html', 'lcov']`, `coverage.include: ['src/**/*.ts']`, and a long `coverage.exclude` list (node_modules, build, dist, **/*.spec.ts, **/*.test.ts, __tests__, scripts, *.config.ts, *.config.js, vitest.config.ts, eslint.config.js). http also excludes `examples/`, `**/types.ts`.
- **packages/models**: Same structure; `test.include` also has `examples/**/*.spec.ts`; exclude includes `examples/` so examples are not in coverage.
- **packages/services**: Minimal — only `test.include: ['src/**/*.spec.ts']`, no coverage block (coverage may be enabled via CLI). Task requires coverage in the shared config.

**Common shape**
- `test.include`: `['src/**/*.spec.ts']` (models adds examples in its own config).
- `coverage`: provider v8, reporters text/json/html/lcov, include `['src/**/*.ts']`, exclude: node_modules, build, dist, **/*.spec.ts, **/*.test.ts, **/__tests__/**, scripts, *.config.ts, *.config.js, *.config.mjs, vitest.config.*, eslint.config.*. Omit package-specific entries (examples/, **/types.ts) from the shared preset; consumers can extend and add more excludes.

**Export**
- `package.json` already has `"./vitest": "./vitest.config.mjs"`. Replace placeholder content. Use ESM: `import { defineConfig } from 'vitest/config'; export default defineConfig({ ... });`. Vitest is already a dependency of @ojson/infra (TASK-1.10.1); @vitest/coverage-v8 is also present.

**Resolution**
- When a consumer runs Vitest with a config that re-exports from `@ojson/infra/vitest`, the config is loaded from infra; paths like `src/**/*.spec.ts` are resolved from the **consumer’s cwd** (where Vitest runs), so they are correct. No path changes needed.

---

### Steps

1. **Replace** `devops/infra/vitest.config.mjs` with:
   - `import { defineConfig } from 'vitest/config';`
   - `export default defineConfig({ test: { include: ['src/**/*.spec.ts'], coverage: { provider: 'v8', reporter: ['text', 'json', 'html', 'lcov'], include: ['src/**/*.ts'], exclude: [ ... ] } } });`
   - Exclude list: `node_modules/`, `build/`, `dist/`, `**/*.spec.ts`, `**/*.test.ts`, `**/__tests__/**`, `scripts/`, `*.config.ts`, `*.config.js`, `*.config.mjs`, `vitest.config.ts`, `vitest.config.mjs`, `eslint.config.js`, `eslint.config.mjs`.

2. **Verify**: In a package that has `@ojson/infra` as devDependency and `vitest.config.js` (or .mjs) with `export { default } from '@ojson/infra/vitest'`, run `pnpm exec vitest --run` and `pnpm exec vitest --run --coverage`. No resolution errors; tests run and coverage is generated.
<!-- SECTION:PLAN:END -->
