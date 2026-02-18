---
id: TASK-1.6
title: Create package @ojson/tsconfig
status: To Do
assignee: []
created_date: '2026-02-17 20:27'
labels:
  - metapackage
  - devops
dependencies: []
references:
  - /Users/3y3k0/doctools/diplodoc/devops/tsconfig
parent_task_id: TASK-1
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Create a shared TypeScript config for all ojson packages.

**Context**: Currently each package has its own `tsconfig.json` with duplicated settings. A shared `@ojson/tsconfig` unifies configuration. Analogous to `@diplodoc/tsconfig` (`/Users/3y3k0/doctools/diplodoc/devops/tsconfig`).

**Principle**: the package must remain autonomous: if developed standalone, the dependency on `@ojson/tsconfig` should be a devDependency, not part of metapackage infrastructure.

**To create** (in `devops/tsconfig/` or similar):
- `package.json` with `name: "@ojson/tsconfig"`
- `tsconfig.base.json` — base settings: `strict`, `target: ESNext`, `module: NodeNext`
- optionally: `tsconfig.types.json`, `tsconfig.test.json`
- `README.md` with usage examples
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 `@ojson/tsconfig` available as npm package (possibly via workspace linking in metapackage)
- [ ] #2 Any package can use `extends: "@ojson/tsconfig/tsconfig.base.json"` in its `tsconfig.json`
- [ ] #3 Settings: `strict: true`, `target: ESNext`, `moduleResolution: NodeNext`
- [ ] #4 Package has README
<!-- AC:END -->
