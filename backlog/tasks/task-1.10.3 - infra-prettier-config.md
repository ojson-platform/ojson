---
id: TASK-1.10.3
title: '@ojson/infra: Prettier config'
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
Add Prettier base config exported as default from `@ojson/infra/prettier`. Match options used in packages (e.g. http): semi, trailingComma, singleQuote, printWidth 100, tabWidth 2, useTabs false, arrowParens, bracketSpacing. ESM export (e.g. `prettier.config.mjs`).
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 File implementing `@ojson/infra/prettier` exists and exports default config object
- [x] #2 Options match shared style (semi, trailingComma: 'all', singleQuote, printWidth 100, etc.)
- [x] #3 A consuming package can do `export { default } from '@ojson/infra/prettier'` and run Prettier successfully
<!-- AC:END -->

## Implementation Plan

<!-- SECTION:PLAN:BEGIN -->
### Findings

**Reference configs**
- **packages/http**, **packages/models**, **packages/services**, **packages/server**: All use `.prettierrc.json` with the same options (identical content).
- Options: `semi: true`, `trailingComma: "all"`, `singleQuote: true`, `printWidth: 100`, `tabWidth: 2`, `useTabs: false`, `arrowParens: "avoid"`, `bracketSpacing: false`.

**Export**
- `devops/infra/package.json` already has `"./prettier": "./prettier.config.mjs"`. The file exists as a placeholder (`export default {}`). Replace with the real config object.
- No extra dependencies: Prettier is already a dependency of @ojson/infra (TASK-1.10.1). The config is a plain object; no imports needed in the config file itself.
- Prettier resolves config from the consuming package’s config file; when that file does `export { default } from '@ojson/infra/prettier'`, Node loads the infra module and uses its default export. Works with ESM (infra has `"type": "module"`).

**Consumer usage**
- Consumer creates `prettier.config.js` (or `.mjs`) with `export { default } from '@ojson/infra/prettier'`. Prettier 3 supports ESM config when package is type module or file is .mjs. Consumer must have Prettier installed (or rely on infra’s dependency when running from a context that resolves infra’s node_modules).

---

### Steps

1. **Replace** `devops/infra/prettier.config.mjs` content with:
   - `export default { semi: true, trailingComma: 'all', singleQuote: true, printWidth: 100, tabWidth: 2, useTabs: false, arrowParens: 'avoid', bracketSpacing: false };`
   - Optionally add a short comment that this is the shared ojson style.

2. **Verify**: In a package that has `@ojson/infra` as devDependency and a `prettier.config.js` re-exporting from `@ojson/infra/prettier`, run `pnpm exec prettier --check "src/**/*.ts"` (or `--write`). No resolution errors; Prettier uses the config.
<!-- SECTION:PLAN:END -->
