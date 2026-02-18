---
id: TASK-1.14.7
title: Implement cascading ESLint configuration system in @ojson/infra
status: Done
assignee: []
created_date: '2026-02-18 19:32'
updated_date: '2026-02-18 20:04'
labels:
  - infrastructure
  - eslint
  - devops
dependencies: []
parent_task_id: TASK-1.14
priority: high
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Implement cascading ESLint configuration system in @ojson/infra. This allows standard base rules for all packages with optional architectural restriction rules for packages that have with-* module patterns (like http, services, models).
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 #1 Cascading ESLint system implemented in @ojson/infra exports
- [x] #2 #2 Base ESLint config export for all packages
- [x] #3 #3 with-restrictions ESLint config for packages with with-* modules
- [x] #4 #4 Auto-detection logic in scaffolding for with-* modules
- [x] #5 #5 Documentation and migration guide for cascading approach
<!-- AC:END -->

## Implementation Plan

<!-- SECTION:PLAN:BEGIN -->
## Implementation Plan - Cascading ESLint Configuration

### Research Findings

**Current ESLint Configuration Status:**
- @ojson/infra provides base ESLint config with 95% common rules across packages
- Only packages/models has `no-restricted-imports` rule implemented
- packages/http and services DON'T have restrictions but have with-* modules
- packages/openapi has no ESLint config at all
- packages/server missing ESLint config check needed

**with-* Module Analysis:**
- ✅ packages/http: 5 modules (with-auth, with-tracing, with-logger, with-retry, with-timeout)
- ✅ packages/services: 1 module (with-services) 
- ✅ packages/models: 7 modules (already has restrictions)
- ❌ packages/server: 0 with-* modules
- ❌ packages/openapi: 0 with-* modules

**Import Pattern Verification:**
All current imports follow correct pattern: `import { Component } from '../with-module'` (module root), NOT `from '../with-module/file'`. So the restriction rule will not cause breaking changes.

**Current no-restricted-imports Rule:**
```javascript
'no-restricted-imports': [
  'error',
  {
    patterns: [
      {
        group: ['../with-*/**/*', '!../with-*'],
        message: 'Import from module root instead of internal module files',
      },
    ],
  },
]
```

### Implementation Strategy

**Approach:** Create modular ESLint configuration system where packages can compose base rules + optional restrictions based on their needs.

### Step 1: Create Modular ESLint Configurations

**File Structure:**
```
devops/infra/
├── eslint/
│   ├── base.config.mjs           # Standard ESLint rules
│   ├── with-restrictions.config.mjs  # Architectural restrictions
│   └── index.mjs                 # Composed exporter
└── package.json                  # Updated exports
```

**base.config.mjs:** Extract current ESLint config from eslint.config.mjs (base rules only)

**with-restrictions.config.mjs:** Additional configuration object with `no-restricted-imports` rule

**index.mjs:** Function to compose configurations based on options

### Step 2: Update Package.json Exports

```json
{
  "exports": {
    "./eslint": "./eslint/index.mjs",
    "./eslint/base": "./eslint/base.config.mjs", 
    "./eslint/with-restrictions": "./eslint/with-restrictions.config.mjs"
  }
}
```

### Step 3: Update Scaffolding CLI

Enhance `ojson-infra init` to:
1. Detect with-* modules via glob (`src/with-*`)
2. Generate appropriate ESLint configuration:
   - Basic: `export { default } from '@ojson/infra/eslint/base'`
   - With restrictions: `export restrictions from '@ojson/infra/eslint/with-restrictions'`

### Step 4: Alternative Approach: Cascading Config

Instead of separate files, implement cascading within single config:

```javascript
// @ojson/infra/eslint
export default [
  baseConfig,
  // Auto-detected restrictions applied only to src/**
  ...(hasWithModules ? [{
    files: ['src/**/*.ts'],
    rules: {
      'no-restricted-imports': [/* restrictions */]
    }
  }] : [])
];
```

**Decision:** Go with cascading approach - simpler for packages, auto-detection built-in.

### Step 5: Implementation Details

**Enhanced eslint.config.mjs:**
1. Add with-* module detection logic
2. Apply restrictions only when modules detected
3. Keep backward compatibility

**Detection Logic:**
```javascript
import { existsSync } from 'fs';
import { readdirSync } from 'fs';
import { join } from 'path';

function hasWithModules(baseDir = process.cwd()) {
  try {
    const srcDir = join(baseDir, 'src');
    if (!existsSync(srcDir)) return false;
    return readdirSync(srcDir, { withFileTypes: true })
      .filter(dirent => dirent.isDirectory())
      .some(dirent => dirent.name.startsWith('with-'));
  } catch {
    return false;
  }
}
```

### Step 6: Testing and Validation

**Test Cases:**
1. Package without with-* modules (should use base config only)
2. Package with with-* modules (should auto-apply restrictions)
3. Package with custom eslint.config.js (should maintain custom behavior)
4. Verify existing packages don't break

**Validation:**
1. Test ESLint runs successfully on all package types
2. Restrictions work correctly on new packages
3. Backward compatibility maintained

### Step 7: Documentation Updates

**README.md Changes:**
- Update ESLint usage section
- Explain automatic restriction detection
- Provide manual override options

**Examples:**
```javascript
// Basic usage - auto-detects and applies appropriate config
export { default } from '@ojson/infra/eslint';

// Explicit basic config (no restrictions)
export { default as base } from '@ojson/infra/eslint/base';

// Explicit restrictions
export { restrictions } from '@ojson/infra/eslint/with-restrictions';
```

### Expected Outcomes

- **Single import** for most packages: `export { default } from '@ojson/infra/eslint'`
- **Auto-detection** of with-* modules and automatic restriction application
- **Backward compatibility** - no breaking changes to existing packages
- **Flexibility** - packages can opt-in/opt-out of restrictions as needed
- **Simplified migration** - packages move from local configs to shared infra

### Migration Path for Existing Packages

1. **packages/models** - Already has restrictions, should auto-detect and maintain behavior
2. **packages/http** - Should auto-detect with-* modules and gain restrictions
3. **packages/services** - Should auto-detect with-* modules and gain restrictions  
4. **packages/server** - Will get base config only
5. **packages/openapi** - Will get base config only after initial eslint setup
<!-- SECTION:PLAN:END -->
