---
id: TASK-1.11.4
title: 'pnpm: миграция @ojson/openapi'
status: To Do
assignee: []
created_date: '2026-02-17 21:37'
labels:
  - pnpm
dependencies: []
parent_task_id: TASK-1.11
---

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 `package-lock.json` удалён, `pnpm-lock.yaml` закоммичен
- [ ] #2 `"packageManager": "pnpm@10.30.0"` добавлен в `package.json`
- [ ] #3 CI обновлён (если есть): `npm ci` → `pnpm install --frozen-lockfile`
- [ ] #4 `pnpm build` проходит успешно
<!-- AC:END -->
