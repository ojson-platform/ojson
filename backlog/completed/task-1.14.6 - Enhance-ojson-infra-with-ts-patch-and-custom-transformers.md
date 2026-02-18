---
id: TASK-1.14.6
title: Enhance @ojson/infra with ts-patch and custom transformers
status: Done
assignee: []
created_date: '2026-02-18 19:32'
updated_date: '2026-02-18 19:50'
labels:
  - infrastructure
  - typescript
  - devops
dependencies: []
parent_task_id: TASK-1.14
priority: high
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Enhance @ojson/infra to support custom TypeScript transformers used by @ojson/models and @ojson/server. This includes adding ts-patch, creating shared transformer export, and providing tspc wrapper for seamless integration.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 #1 ts-patch added to @ojson/infra devDependencies with proper version alignment
- [x] #2 #2 Shared extensions.js transformer exported from @ojson/infra
- [x] #3 #3 tspc binary wrapper available via @ojson/infra (replaces tsc when needed)
- [x] #4 #4 tsconfig.base.json updated to ESNext+NodeNext target
- [x] #5 #5 Documentation for transformer usage patterns included
<!-- AC:END -->

## Implementation Plan

<!-- SECTION:PLAN:BEGIN -->
### Research Findings

**Current @ojson/infra structure**:
- Located at `devops/infra/` as a git submodule (ojson-platform/infra)
- Already provides tool runner binaries via `bin/` directory
- Current exports: ESLint, Prettier, TypeScript presets, Vitest configs
- TypeScript version: ^5.7.2 (aligned across all packages)

**ts-patch usage analysis**:
- Both `packages/models` and `packages/server` use `"ts-patch": "^3.3.0"`
- Both use `tspc` command instead of `tsc` for building
- Both use identical `extensions.js` transformer (50 lines, ES modules)
- Both have `"rewriteRelativeImportExtensions": true` in tsconfig
- Both use `"transform": "./scripts/extensions.js"` with `"after": true`

**Current extensions.js transformer**:
- Purpose: Automatically adds file extensions to relative imports during compilation
- Logic: For relative imports without extensions, tries `.ts`, `.js`, `/index.ts`, `/index.js`
- Final output: Converts recognized extensions to `.js` for runtime compatibility
- Essential for ESM module resolution in compiled output

**TypeScript configurations across packages**:
- Models: ES2020 target, ES2020 module, Node resolution
- Server: ES2020 target, ES2020 module, Node resolution  
- HTTP: Uses standard `tsc` (no ts-patch/transformers)
- Services: Uses standard `tsc` (no ts-patch/transformers)
- Current @ojson/infra/base: ESNext target, NodeNext module and resolution

**Binary wrapper approach**:
- @ojson/infra already has pattern: `bin/tsc.cjs` → `./_tool-runner.cjs`
- Tool runners allow packages to use tools via `@ojson/infra` without direct deps
- Current `tsc.cjs` forwards to `typescript` package's `tsc` binary

---

### Implementation Steps

#### Step 1: Add ts-patch dependency and shared transformer

**Update devops/infra/package.json**:
- Add `"ts-patch": "^3.3.0"` to dependencies (to enable single-dependency model)
- Add new export: `"./transformer": "./lib/transformer.mjs"`
- Add new binary: `"tspc": "./bin/tspc.cjs"`

**Create devops/infra/lib/transformer.mjs**:
- Copy the identical extensions.js logic from packages/models/scripts
- Convert to standard ES module export for shared usage
- Include clear JSDoc documentation of transformer purpose and behavior
- Ensure path resolution works across different package contexts

#### Step 2: Create tspc binary wrapper

**Create devops/infra/bin/tspc.cjs**:
- Follow existing `_tool-runner.cjs` pattern
- Wrap `ts-patch` package's `tspc` binary
- Ensure automatic `ts-patch install` if needed (like server package does)
- Handle version alignment and error messaging
- Accept all standard tsc/tspc arguments transparently

#### Step 3: Update tsconfig.base.json for modern targets

**Update devops/infra/tsconfig/base.json**:
- Current: `"target": "ESNext", "module": "NodeNext", "moduleResolution": "NodeNext"`
- Add transformer-friendly options: `"rewriteRelativeImportExtensions": true`
- Add compatibility settings for ts-patch usage
- Maintain backward compatibility for packages without transformers
- Consider adding optional transformer plugin configuration as commented example

#### Step 4: Update exports and documentation

**Update devops/infra/package.json exports**:
- Add transformer export: `"./transformer": "./lib/transformer.mjs"`
- Consider adding tsconfig presets for transformer usage

**Create comprehensive documentation**:
- README.md section: "TypeScript Transformers"
- Explain when and why to use ts-patch (ESM extension resolution)
- Provide clear usage patterns:
  - Basic: use `tspc` binary instead of `tsc`
  - Advanced: configure custom transformers via tsconfig plugins
- Include migration guide from local transformers to @ojson/infra
- Document version alignment requirements

#### Step 5: Migration patterns and validation

**Define migration pattern for models/server**:
- Remove local `scripts/extensions.js` files
- Remove direct `ts-patch` devDependencies  
- Update package.json scripts to use `@ojson/infra`'s `tspc`
- Update tsconfig to reference shared transformer: `"./lib/transformer.mjs"`
- Verify build and test compatibility

**Validation approach**:
- Test transformer extraction in isolation
- Verify tspc wrapper works identically to direct ts-patch usage
- Ensure existing models/server builds work after migration
- Test that packages without transformers (http, services) remain unaffected

---

### File Structure After Implementation

```
devops/infra/
├── package.json                 # Updated with ts-patch dep and new exports/bin
├── lib/
│   └── transformer.mjs         # Shared extensions.js transformer
├── bin/
│   ├── tspc.cjs                # ts-patch wrapper (new)
│   └── tsc.cjs                 # Existing standard tsc wrapper
├── tsconfig/
│   ├── base.json              # Updated with transformer-friendly options
│   ├── build.json             # Unchanged
│   └── test.json              # Unchanged
└── README.md                  # Updated with transformer documentation
```

---

### Technical Considerations

**Path Resolution**: The transformer must work when called from any consuming package, resolving paths relative to the source file being transformed (not relative to @ojson/infra location).

**Version Alignment**: All packages using transformers should align on TypeScript version ^5.7.2 and ts-patch ^3.3.0 for consistency.

**Backward Compatibility**: Packages that don't need transformers (http, services, openapi) should not be affected by these changes.

**Build Performance**: ts-patch and transformers add build overhead but enable cleaner source code (bundler-style imports without extensions).

**Error Handling**: The tspc wrapper should provide helpful error messages if ts-patch installation fails or versions are misaligned.

---

### Out of Scope

- Automatic migration of existing packages (models/server) - will be separate tasks
- Modifications to packages that don't currently use transformers
- Changes to transformer logic itself (only extraction and sharing)
- Publishing updates to npm (workspace linking sufficient for validation)
<!-- SECTION:PLAN:END -->

## Implementation Summary

**✅ TASK COMPLETED SUCCESSFULLY**

All acceptance criteria have been implemented:

### ✅ #1: ts-patch added to @ojson/infra dependencies
- Added `"ts-patch": "^3.3.0"` to dependencies (version aligned with models/server)
- Ensures single-dependency model for transformer usage

### ✅ #2: Shared transformer export
- Created `./lib/transformer.mjs` with identical functionality to local extensions.js
- Added export `"./transformer": "./lib/transformer.mjs"` in package.json
- Full JSDoc documentation explaining transformer purpose and behavior
- Transformer resolves relative imports without extensions automatically

### ✅ #3: tspc binary wrapper
- Created `./bin/tspc.cjs` following existing `_tool-runner.cjs` pattern
- Added `"tspc": "./bin/tspc.cjs"` to package.json bin section
- Verified binary works: `tspc --version` returns correct version
- Forward compatibility with all tsc/tspc arguments

### ✅ #4: TypeScript base config updated
- Updated `tsconfig/base.json` with transformer-friendly options:
  - `"rewriteRelativeImportExtensions": true`
  - `"allowSyntheticDefaultImports": true`
  - `"esModuleInterop": true`
  - `"verbatimModuleSyntax": true`
- Added documentation comment with transformer usage example
- Maintains ESNext+NodeNext targets while supporting transformers

### ✅ #5: Comprehensive documentation
- Added "TypeScript Custom Transformers" section to README.md
- Clear explanation of when and why to use transformers
- Step-by-step setup instructions for packages
- Migration guide from local transformers to shared infrastructure
- Benefits and usage patterns documented

### Validation Results

- ✅ Package.json exports and bins properly configured
- ✅ Transformer loads and functions correctly
- ✅ tspc binary works in workspace context
- ✅ TypeScript config validates with transformer options
- ✅ All functionality verified through testing

### Ready for Package Migration

The infrastructure is now ready for packages/models and packages/server to migrate from local transformers to the shared @ojson/infra implementation. Each package can:
1. Remove local `scripts/extensions.js` files
2. Remove direct `ts-patch` devDependencies
3. Update tsconfig to use shared transformer
4. Change build scripts to use `tspc` (via @ojson/infra)

This reduces code duplication, ensures consistent behavior, and centralizes transformer management.
