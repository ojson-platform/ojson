---
id: TASK-1.14.1
title: Migrate @ojson/services to @ojson/infra
status: Done
assignee: []
created_date: '2026-02-18 15:26'
updated_date: '2026-02-19 10:10'
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
Migrate `packages/services` to use `@ojson/infra` configs and tool runners. Follow TASK-1.14 procedure and validate lint/format/test.

## Research Findings

### Current Package State

**devDependencies (11 total to potentially migrate):**
- `@eslint/js`: ^9.39.2
- `@typescript-eslint/eslint-plugin`: ^8.50.0
- `@typescript-eslint/parser`: ^8.50.0
- `eslint`: ^9.39.2
- `eslint-config-prettier`: ^10.1.8
- `eslint-plugin-import`: ^2.32.0
- `prettier`: ^3.7.4
- `typescript`: ^5.7.2
- `vitest`: ^3.2.4
- `husky`: ^9.1.7 (keep - not in infra)
- `lint-staged`: ^16.2.7 (keep - not in infra)

**Current Configuration Files:**
- `eslint.config.js` (98 lines, 2 configs - src + spec files)
- `tsconfig.json` (ES2020 + Bundler, standalone - no extends)
- `vitest.config.ts` (minimal config)
- `.prettierrc.json` (identical to infra config)

**with-* Modules:**
- `src/with-services/` - Will trigger cascading ESLint restrictions

### Key Findings

1. **TypeScript Config**: Uses standalone ES2020 + Bundler - needs migration to ESNext+NodeNext from infra
2. **Vitest Config**: Minimal - easy to replace with infra config
3. **ESLint Config**: Similar structure to http - can use cascading approach
4. **Prettier**: Already identical to infra config

## Implementation Plan

### Strategy
Full migration to ESNext+NodeNext as originally planned. Fix any compatibility issues that arise.

### Steps

1. **Backup current configs**:
   - `eslint.config.js` → `eslint.config.js.backup`
   - `tsconfig.json` → `tsconfig.json.backup`
   - `vitest.config.ts` → `vitest.config.ts.backup`
   - `.prettierrc.json` → `.prettierrc.json.backup`

2. **Update dependencies**:
   - Add `@ojson/infra: "workspace:*"`
   - Keep `husky` and `lint-staged` (not in infra)
   - Remove duplicate tool deps (9 → 1 infra)

3. **Apply infrastructure configs**:
   - **TypeScript**: Extend `@ojson/infra/tsconfig/base` with ESNext+NodeNext
   - **ESLint**: Replace with `@ojson/infra/eslint` export (auto-detect with-services)
   - **Prettier**: Keep `.prettierrc.json` (already identical)
   - **Vitest**: Replace with `export { default } from '@ojson/infra/vitest'`

4. **Run scaffolding**: `pnpm exec ojson-infra init --yes --force`

5. **Fix any TypeScript issues**:
   - Extension resolution errors → use transformers or fix imports
   - Web API globals → add to ESLint if missing
   - Declaration issues → adjust tsconfig

6. **Verify**:
   - `pnpm exec eslint src` → 0 errors
   - `pnpm exec prettier --check "src/**/*.ts"` → passes
   - `pnpm exec vitest --run` → all tests pass
   - `pnpm run build` → should pass

### Expected Outcome

**Before:**
- 9 tool dependencies (eslint, prettier, vitest, typescript, etc.)
- 4 config files (eslint, prettier, vitest, tsconfig)

**After:**
- 1 core dependency (@ojson/infra) + keep husky/lint-staged
- 4 config files (simplified re-exports from infra)
- TypeScript: ESNext+NodeNext from infra
- ESLint with cascading restrictions for with-* modules
- Consistent tooling across packages
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 `packages/services` uses `@ojson/infra` configs (re-exports / extends).
- [ ] #2 Verification commands pass from `packages/services` directory.
<!-- AC:END -->

## Implementation Plan

<!-- SECTION:PLAN:BEGIN -->
## Implementation Plan

### Strategy
Full migration to ESNext+NodeNext from @ojson/infra, fixing compatibility issues.

### Steps

1. **Backup current configs**:
   - `eslint.config.js` → `eslint.config.js.backup`
   - `tsconfig.json` → `tsconfig.json.backup`
   - `vitest.config.ts` → `vitest.config.ts.backup`
   - `.prettierrc.json` → `.prettierrc.json.backup`

2. **Update dependencies**:
   - Add `@ojson/infra: "workspace:*"`
   - Keep `husky` and `lint-staged` (not in infra)
   - Remove duplicate tool deps (9 → 1 infra)

3. **Apply infrastructure configs**:
   - **TypeScript**: Extend `@ojson/infra/tsconfig/base` with ESNext+NodeNext
   - **ESLint**: Replace with `@ojson/infra/eslint` export
   - **Prettier**: Keep `.prettierrc.json` (identical to infra)
   - **Vitest**: Replace with `export { default } from '@ojson/infra/vitest'`

4. **Run scaffolding**: `pnpm exec ojson-infra init --yes --force`

5. **Fix TypeScript issues**:
   - Extension resolution for relative imports
   - Web API globals (URL, Request, Response, etc.)
   - Any declaration/d.ts issues

6. **Verify**:
   - `pnpm exec eslint src` → 0 errors
   - `pnpm exec prettier --check "src/**/*.ts"` → passes
   - `pnpm exec vitest --run` → all tests pass
   - `pnpm run build` → should pass

### Key Differences from http
- Full ESNext+NodeNext migration (not standalone config)
- Fix issues instead of avoiding them
- Goal: Consistent TypeScript config across all packages
<!-- SECTION:PLAN:END -->

## Final Summary

<!-- SECTION:FINAL_SUMMARY:BEGIN -->
## ✅ Migration Complete

### Changes

- ✅ **Deps**: 9 → 1 (@ojson/infra) + keep husky/lint-staged

- ✅ **ESLint**: @ojson/infra/eslint (auto-detects with-services)

- ✅ **Vitest**: @ojson/infra/vitest config

- ✅ **Prettier**: .prettierrc.json with ojson config

- ✅ **Build**: ESNext+NodeNext with transformer plugin

### Verification

✅ ESLint: 0 errors + cascading restrictions

✅ Prettier: All files formatted

✅ Vitest: 9 tests pass

✅ Build: 6 JS files in build/

### Note

Used same approach as @ojson/models with transformer plugin

for ESNext+NodeNext compatibility.
<!-- SECTION:FINAL_SUMMARY:END -->
