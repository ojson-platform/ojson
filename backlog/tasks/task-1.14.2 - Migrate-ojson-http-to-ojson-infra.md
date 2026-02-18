---
id: TASK-1.14.2
title: Migrate @ojson/http to @ojson/infra
status: To Do
assignee: []
created_date: '2026-02-18 15:27'
updated_date: '2026-02-18 19:32'
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

## Implementation Plan

<!-- SECTION:PLAN:BEGIN -->
## Final Implementation Plan (Cascading ESLint Strategy)

### Strategy Decisions
- ✅ **TypeScript**: ESNext+NodeNext everywhere  
- ✅ **Transformers**: Move to global infra with `tspc` instead of `tsc`
- ✅ **ESLint Restrictions**: Use cascading configs - base in root, restrictions in `src/`

### Enhanced Infrastructure Strategy

#### Phase 1: Infrastructure Enhancement
1. **Update @ojson/infra**:
   - Add `ts-patch` to devDependencies
   - Create shared `extensions.js` transformer export  
   - Update default `tsconfig.base.json` to ESNext+NodeNext
   - Add `tspc` binary wrapper

2. **Cascading ESLint Configuration System**:
   ```
   @ojson/infra exports:
   └── eslint/
       ├── base.config.mjs         # Standard ESLint (root level)
       └── with-restrictions.config.mjs  # Additional rules for with-* modules
   ```

#### Phase 2: Cascading Configuration Implementation
**Root `eslint.config.js`** (from @ojson/infra):
```javascript
export default [
  baseConfig,  // Standard rules for all files
  
  // Module restrictions for packages with with-* patterns
  {
    files: ['src/**/*'],  // Only source files, not tests
    rules: {
      'no-restricted-imports': [
        'error',
        { patterns: ['../with-*/**/*', '!../with-*'] }
      ]
    }
  }
];
```

**Package-specific override option**:
- Packages can create `src/eslint.config.js` with restrictions
- Or detect and auto-generate during scaffolding

#### Phase 3: Package Analysis & Auto-detection
**Scaffolding Logic**:
```javascript
// Detect if package has with-* modules
const hasWithModules = await glob('./src/with-*');
if (hasWithModules.length > 0) {
  // Add restrictions config
  await writeFile('src/eslint.config.js', restrictionsConfig);
}
```

#### Phase 4: Global Packages Assessment
**Apply restrictions to**:
- ✅ **@ojson/http** (5 with-* modules) 
- ✅ **@ojson/services** (1 with-* module)
- ✅ **@ojson/models** (already has, migrate to cascading)
- ❌ **@ojson/server** (no with-* modules)
- ❌ **@ojson/openapi** (no with-* modules)

#### Phase 5: HTTP Package Migration (Primary Task)
1. **Backup current configs**
2. **Add @ojson/infra** with `workspace:*`
3. **Install enhanced infra** with ts-patch support
4. **Apply cascading ESLint**:
   - Root config from @ojson/infra/base
   - Create `src/eslint.config.js` with restrictions (detected automatically)
5. **Use ESNext+NodeNext tsconfig**
6. **Evaluate transformer need** (scan for extensionless imports)
7. **Run migration**: `ojson-infra init --auto-detect`
8. **Verify all tools work**:
   - `pnpm exec eslint src` (should apply cascading rules)
   - `pnpm exec prettier --check "src/**/*.ts"`
   - `pnpm exec vitest --run`
   - `pnpm exec tspc --noEmit`

#### Phase 6: Documentation & Migration Guide
- Document cascading ESLint pattern
- Create migration guide for other packages
- Update scaffolding to auto-detect with-* modules

### Benefits of Cascading Approach
1. **Clean separation**: Base rules vs architectural restrictions
2. **Flexibility**: Easy to enable/disable per package
3. **Auto-detection**: CLI can detect with-* modules automatically
4. **Maintainability**: Restrictions concentrated in one place
5. **Scalability**: Easy to add other package-specific overrides

### Expected Outcomes
- **Standardized base configs** across all packages
- **Optional architectural restrictions** where needed
- **Flexible transformer support** for modular packages
- **Clear separation of concerns** in configuration
<!-- SECTION:PLAN:END -->
