---
id: TASK-1.10.1
title: '@ojson/infra: package skeleton'
status: Done
assignee: []
created_date: '2026-02-17'
labels:
  - devops
  - metapackage
dependencies: []
parent_task_id: TASK-1.10
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Create the `devops/infra/` package with `package.json` only: name `@ojson/infra`, version, exports for all entry points (eslint, prettier, tsconfig/base, tsconfig/build, tsconfig/test, vitest), dependencies (ESLint stack, Prettier, Vitest), and `type: "module"`. No config files yet — export paths can point to placeholder files or be added when configs exist. Ensures the package is linkable in the workspace and ready for config deliverables in follow-up tasks.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 Directory `devops/infra/` exists with valid `package.json`
- [x] #2 `package.json` has `name: "@ojson/infra"`, `version`, `type: "module"`, and `exports` for `/eslint`, `/prettier`, `/tsconfig/base`, `/tsconfig/build`, `/tsconfig/test`, `/vitest`
- [x] #3 Dependencies include eslint, @eslint/js, @typescript-eslint/*, eslint-config-prettier, eslint-plugin-import, prettier, vitest (versions aligned with packages/http)
- [x] #4 From metapackage root, `pnpm install` links `devops/infra` and no install errors
<!-- AC:END -->

## Implementation Plan

<!-- SECTION:PLAN:BEGIN -->
### Findings

**Workspace**
- `pnpm-workspace.yaml` already includes `devops/*`; no need to change it.
- Root `package.json`: `packageManager: pnpm@10.30.0`, `engines.node: ">=20.0.0"`.
- `devops/` exists and is empty — create `devops/infra/` from scratch.

**Versions to align with** (from `packages/http` and `packages/models`):
- eslint: `^9.39.2`
- @eslint/js: `^9.39.2`
- @typescript-eslint/eslint-plugin: `^8.50.0`
- @typescript-eslint/parser: `^8.50.0`
- eslint-config-prettier: `^10.1.8`
- eslint-plugin-import: `^2.32.0`
- prettier: `^3.7.4`
- vitest: `^3.2.3` (models also has @vitest/coverage-v8 `^3.2.4` — can add to infra so coverage works without consumer adding it)

**Exports and missing files**
- Task allows "no config files yet" and "export paths can point to placeholder files". If we only add `package.json` with exports pointing to `./eslint.config.mjs`, `./prettier.config.mjs`, etc., those files don't exist yet — `pnpm install` will still succeed, but `import('@ojson/infra/eslint')` will fail at runtime until 1.10.2 adds the file.
- **Recommendation**: add minimal **placeholder files** in this task so the package is resolvable and the workspace can optionally smoke-test linking. Placeholders: `eslint.config.mjs` → `export default [];`, `prettier.config.mjs` → `export default {};`, `vitest.config.mjs` → `export default {};`, `tsconfig/base.json` (and build/test) with minimal valid JSON. Then 1.10.2–1.10.5 replace with real config. If you prefer zero placeholders, we only create `package.json` and accept broken imports until follow-up tasks.

**package.json shape**
- `name`: `"@ojson/infra"`
- `version`: `"1.0.0"`
- `description`: e.g. "Shared dev infrastructure for ojson packages (ESLint, Prettier, TypeScript, Vitest)"
- `private`: omit or `false` (publishable)
- `type`: `"module"`
- `exports`: object with keys `"./eslint"`, `"./prettier"`, `"./tsconfig/base"`, `"./tsconfig/build"`, `"./tsconfig/test"`, `"./vitest"` and values pointing to the corresponding files (e.g. `"./eslint.config.mjs"`). For tsconfig, TypeScript resolves `@ojson/infra/tsconfig/base` to the file; use `"./tsconfig/base.json"` etc.
- `files`: `["eslint.config.mjs", "prettier.config.mjs", "vitest.config.mjs", "tsconfig"]` (so publish includes them; adjust if we skip placeholders)
- `engines`: `"node": ">=20"`
- `dependencies`: as above (eslint, @eslint/js, @typescript-eslint/eslint-plugin, @typescript-eslint/parser, eslint-config-prettier, eslint-plugin-import, prettier, vitest). Optionally add @vitest/coverage-v8 so coverage works out of the box.
- No `main` or `module` — no default entry.

---

### Steps

1. **Create directory** `devops/infra/`.

2. **Create `devops/infra/package.json`** with name, version, description, type, exports, files, engines, dependencies (and optionally placeholder file list). Use the versions from Findings.

3. **Optional placeholders** (if we want the package resolvable immediately):
   - `eslint.config.mjs`: `export default [];`
   - `prettier.config.mjs`: `export default {};`
   - `vitest.config.mjs`: `export default {};`
   - `tsconfig/base.json`: `{"compilerOptions":{},"exclude":[]}` (or minimal valid base)
   - `tsconfig/build.json`: `{"extends":"./base.json","compilerOptions":{}}`
   - `tsconfig/test.json`: `{"extends":"./base.json","compilerOptions":{}}`
   If we skip placeholders, create only `package.json`; exports will work once 1.10.2–1.10.5 add the real files.

4. **Verify**: from repo root run `pnpm install`. Check that `devops/infra` is linked (e.g. `pnpm list @ojson/infra` or that `node_modules/@ojson/infra` exists when installing from root). No install errors.

---

### Deliverables

| Item | Action |
|------|--------|
| `devops/infra/package.json` | Create with exports and deps |
| `devops/infra/*.mjs` and `tsconfig/*.json` | Optional placeholders (recommended) or leave for 1.10.2–1.10.5 |
<!-- SECTION:PLAN:END -->
