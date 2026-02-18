---
id: TASK-1.10.4
title: '@ojson/infra: TypeScript presets'
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
Add three tsconfig presets under `devops/infra/tsconfig/`: `base.json` (strict, ESNext, NodeNext, skipLibCheck, lib), `build.json` (extends base; declaration, sourceMap, outDir build, rootDir src), `test.json` (extends base; types for node and vitest). Export paths already declared in package.json; ensure JSON files exist and are valid.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 `tsconfig/base.json` exists with strict, ESNext, NodeNext (or equivalent), skipLibCheck, lib
- [x] #2 `tsconfig/build.json` extends base and sets declaration, declarationMap, sourceMap, outDir, rootDir
- [x] #3 `tsconfig/test.json` extends base and includes types for node and vitest
- [x] #4 Consumer can use `"extends": "@ojson/infra/tsconfig/base"` (and build/test) in tsconfig.json
<!-- AC:END -->

## Implementation Plan

<!-- SECTION:PLAN:BEGIN -->
### Findings

**Reference configs**
- **packages/http**: `target: "ES2020"`, `module: "ES2020"`, `moduleResolution: "Bundler"`, `strict: true`, `skipLibCheck: true`, `lib: ["ES2020","ES2021","ES2022","DOM"]`, `outDir: "build"`, `rootDir: "src"`, `declaration`, `declarationMap`, `sourceMap`. Single tsconfig; exclude spec/test from build.
- **packages/services**: Same shape, no `lib` (default).
- **packages/models**, **packages/server**: `moduleResolution: "Node"`, custom plugins, `rewriteRelativeImportExtensions`, etc. — package-specific; consumers can override in local tsconfig.
- **Variance**: moduleResolution is Bundler (http, services) vs Node (models, server). A shared **base** should pick one default; parent plan suggests `NodeNext`. Packages that need Bundler can set `moduleResolution: "Bundler"` in their extending config. Using `NodeNext` and `ESNext` keeps the preset suitable for Node packages and leaves overrides to consumers.

**Export**
- `package.json` already has `"./tsconfig/base": "./tsconfig/base.json"`, same for build and test. Placeholder JSONs exist (minimal content). Replace with full presets.

**Resolution**
- Consumer uses `"extends": "@ojson/infra/tsconfig/base"`. TypeScript resolves the subpath to the package and loads the JSON. No `include`/`exclude` in base so the consumer’s tsconfig supplies them. For build/test, `extends` inside the preset (e.g. `"extends": "./base.json"`) is relative to the preset file’s directory, so it correctly points to base.json in the same package.

**Vitest types**
- For test preset, add `"types": ["node", "vitest/globals"]` so test files get globals (describe, it, expect) without imports. Alternative: `"vitest/importMeta"` if only import.meta is needed; `vitest/globals` is the usual choice for Vitest.

---

### Steps

1. **Replace `tsconfig/base.json`** with a full base preset:
   - `compilerOptions`: `strict: true`, `target: "ESNext"`, `module: "ESNext"`, `moduleResolution: "NodeNext"`, `skipLibCheck: true`, `lib: ["ES2020", "ES2021", "ES2022"]` (optional DOM if we want browser types; omit for Node-only). Do **not** set `include`/`exclude` (consumer sets them).

2. **Replace `tsconfig/build.json`**:
   - `"extends": "./base.json"`
   - `compilerOptions`: `declaration: true`, `declarationMap: true`, `sourceMap: true`, `outDir: "build"`, `rootDir: "src"`. Consumer can extend this for `tsc -p tsconfig.build.json` or their main tsconfig.

3. **Replace `tsconfig/test.json`**:
   - `"extends": "./base.json"`
   - `compilerOptions`: `types: ["node", "vitest/globals"]`. Optionally `noEmit: true` if tests are type-checked only. Consumer extends this for test runs or type-checking spec files.

4. **Verify**: In a package with `tsconfig.json` containing `"extends": "@ojson/infra/tsconfig/base"` (and optional `include`/`exclude`), run `tsc --noEmit` and confirm resolution. Same for build/test if desired.
<!-- SECTION:PLAN:END -->
