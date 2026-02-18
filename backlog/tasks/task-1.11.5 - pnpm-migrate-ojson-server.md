---
id: TASK-1.11.5
title: 'pnpm: migrate @ojson/server'
status: To Do
assignee: []
created_date: '2026-02-17 21:37'
labels:
  - pnpm
dependencies: []
parent_task_id: TASK-1.11
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
In addition to the standard migration, replace `"@ojson/models": "file:../models"` with `"@ojson/models": "^1.1.2"` (semver range instead of file reference). In the metapackage pnpm will resolve it to the local package. When installing standalone — it installs from the npm registry.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 `package-lock.json` removed, `pnpm-lock.yaml` committed
- [ ] #2 `"packageManager": "pnpm@10.30.0"` added to `package.json`
- [ ] #3 `"@ojson/models": "file:../models"` replaced with `"^1.1.2"` (semver)
- [ ] #4 CI updated: `npm ci` → `pnpm install --frozen-lockfile`
- [ ] #5 `pnpm build` and `pnpm test` pass
<!-- AC:END -->
