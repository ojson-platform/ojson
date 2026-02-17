---
id: TASK-1.11.5
title: 'pnpm: миграция @ojson/server'
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
Помимо обычной миграции, нужно заменить `"@ojson/models": "file:../models"` на `"@ojson/models": "^1.1.2"` (semver-диапазон вместо file-ссылки). В метапакете pnpm автоматически заменит её локальным пакетом. При автономной установке — ставится из npm-реестра.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 `package-lock.json` удалён, `pnpm-lock.yaml` закоммичен
- [ ] #2 `"packageManager": "pnpm@10.30.0"` добавлен в `package.json`
- [ ] #3 `"@ojson/models": "file:../models"` заменён на `"^1.1.2"` (semver)
- [ ] #4 CI обновлён: `npm ci` → `pnpm install --frozen-lockfile`
- [ ] #5 `pnpm build` и `pnpm test` проходят успешно
<!-- AC:END -->
