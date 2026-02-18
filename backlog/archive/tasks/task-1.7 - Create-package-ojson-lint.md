---
id: TASK-1.7
title: Create package @ojson/lint
status: To Do
assignee: []
created_date: '2026-02-17 20:27'
labels:
  - metapackage
  - devops
dependencies: []
references:
  - /Users/3y3k0/doctools/diplodoc/devops/lint
parent_task_id: TASK-1
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Create a shared lint package (ESLint + Prettier) for all ojson packages.

**Context**: Currently each package duplicates ESLint and Prettier configs. Analogous to `@diplodoc/lint` (`/Users/3y3k0/doctools/diplodoc/devops/lint`), which replaced the legacy `@diplodoc/eslint-config` and `@diplodoc/prettier-config`.

**Principle**: the package must remain autonomous and be published on npm.

**To create** (in `devops/lint/` or similar):
- `package.json` with `name: "@ojson/lint"`
- `eslint.config.js` (or `index.js`) — base ESLint flat config for TypeScript
- `prettier.config.js` — shared Prettier config
- `README.md` with usage examples

**Reference**: See `/Users/3y3k0/doctools/diplodoc/devops/lint` as a template.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 `@ojson/lint` available as npm package
- [ ] #2 Any package can use `@ojson/lint` in its `eslint.config.js`
- [ ] #3 Prettier config available via `require('@ojson/lint/prettier')`
- [ ] #4 Package has README with examples
<!-- AC:END -->
