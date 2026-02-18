---
id: TASK-1.11.2
title: 'pnpm: migrate @ojson/models'
status: To Do
assignee: []
created_date: '2026-02-17 21:36'
labels:
  - pnpm
dependencies: []
parent_task_id: TASK-1.11
---

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 `package-lock.json` removed, `pnpm-lock.yaml` committed
- [ ] #2 `"packageManager": "pnpm@10.30.0"` added to `package.json`
- [ ] #3 CI updated: `npm ci` → `pnpm install --frozen-lockfile`
- [ ] #4 `pnpm build` and `pnpm test` pass
<!-- AC:END -->
