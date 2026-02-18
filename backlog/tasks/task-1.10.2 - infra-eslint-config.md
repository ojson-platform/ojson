---
id: TASK-1.10.2
title: '@ojson/infra: ESLint flat config'
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
Add ESLint flat config for TypeScript, exported as default from `@ojson/infra/eslint`. Extract the common shape from `packages/http/eslint.config.js`: recommended + TypeScript rules for `src/**/*.ts`, lighter rules for `**/*.spec.ts`, eslint-config-prettier, and ignores for build/node_modules. Config must be ESM (e.g. `eslint.config.mjs`) and use paths that resolve from the consuming package (e.g. `project: './tsconfig.json'`).
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 File implementing `@ojson/infra/eslint` exists (e.g. `eslint.config.mjs`) and exports default config array
- [x] #2 Config uses @eslint/js, @typescript-eslint, eslint-plugin-import, eslint-config-prettier; includes blocks for source and spec files and standard ignores
- [x] #3 A consuming package can do `export { default } from '@ojson/infra/eslint'` and run ESLint successfully
<!-- AC:END -->

## Implementation Plan

<!-- SECTION:PLAN:BEGIN -->
### Findings

**Reference configs**
- **packages/http**, **packages/services**: Identical flat config. Structure: (1) `js.configs.recommended`, (2) block for `src/**/*.ts` (exclude `**/*.spec.ts`) with typescript parser, `project: './tsconfig.json'`, typescript + import plugins, recommended + custom rules (unused-vars with _ ignore, import/order, no-explicit-any warn, etc.), (3) block for `src/**/*.spec.ts` with parser but no project, lighter rules (no-explicit-any off, no-undef off), (4) `prettier`, (5) global ignores: `build/`, `node_modules/`, `dist/`, `*.config.js`, `*.config.ts`, `scripts/`.
- **packages/models**: Same as http/services plus `no-restricted-imports` for internal paths and ignores include `examples/`. Package-specific; not included in shared config. Consumers can extend.

**Path resolution**
- Config is loaded from `node_modules/@ojson/infra` (or workspace link). When ESLint runs, the **current working directory** is the consuming package root. So `project: './tsconfig.json'` and `files: ['src/**/*.ts']` resolve in the consumer’s tree — correct. No changes needed.

**File format**
- Replace `devops/infra/eslint.config.mjs` (current placeholder). Use ESM: `import js from '@eslint/js'`, etc. All deps (eslint, @eslint/js, @typescript-eslint/*, eslint-plugin-import, eslint-config-prettier) are already in infra’s package.json (TASK-1.10.1).

**Ignores**
- Use common set: `build/`, `node_modules/`, `dist/`, `*.config.js`, `*.config.ts`, `*.config.mjs`, `scripts/`. Optional: `examples/` can be added if we want to cover models; safer to keep minimal and let packages that need it add an extra ignore block.

---

### Steps

1. **Replace** `devops/infra/eslint.config.mjs` with the full flat config:
   - Import: `@eslint/js`, `@typescript-eslint/eslint-plugin`, `@typescript-eslint/parser`, `eslint-plugin-import`, `eslint-config-prettier`.
   - Export default array: `[ js.configs.recommended, sourceBlock, specBlock, prettier, ignoreBlock ]`.

2. **Source block** (`src/**/*.ts`, exclude `**/*.spec.ts`):
   - languageOptions: parser, parserOptions (ecmaVersion 2020, sourceType module, project `./tsconfig.json`), globals (setTimeout, console, Buffer, process, etc.).
   - plugins: @typescript-eslint, import.
   - rules: typescript.configs.recommended.rules, @typescript-eslint/no-unused-vars (argsIgnorePattern/varsIgnorePattern `^_`), explicit-function-return-type off, no-explicit-any warn, no-unsafe-function-type off, import/order (groups, newlines-between always, alphabetize), import/no-unresolved off.

3. **Spec block** (`src/**/*.spec.ts`):
   - Same parser and globals; no `project` (faster, avoids type-aware on tests if not needed).
   - plugins: @typescript-eslint only (no import plugin needed for specs).
   - rules: recommended, no-unused-vars as above, no-explicit-any off, no-undef off.

4. **Prettier**: spread `prettier` as last rule block before ignores.

5. **Ignore block**: `ignores: ['build/', 'node_modules/', 'dist/', '*.config.js', '*.config.ts', '*.config.mjs', 'scripts/']`.

6. **Verify**: From a package that has `export { default } from '@ojson/infra/eslint'` in eslint.config.js (e.g. temporarily in http or after adding devDependency to a package), run `pnpm exec eslint src` and confirm no resolution errors and expected lint run.
<!-- SECTION:PLAN:END -->
