---
id: TASK-1.11.2
title: 'pnpm: миграция @ojson/models'
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
- [ ] #1 `package-lock.json` удалён, `pnpm-lock.yaml` закоммичен
- [ ] #2 `"packageManager": "pnpm@10.30.0"` добавлен в `package.json`
- [ ] #3 CI обновлён: `npm ci` → `pnpm install --frozen-lockfile`
- [ ] #4 `pnpm build` и `pnpm test` проходят успешно
<!-- AC:END -->
