---
id: TASK-1.8
title: 'Настроить GitHub Actions: синхронизация submodules и CI'
status: To Do
assignee: []
created_date: '2026-02-17 20:28'
labels:
  - metapackage
  - ci-cd
dependencies:
  - TASK-1.4
  - TASK-1.5
references:
  - /Users/3y3k0/doctools/diplodoc/.github/workflows/
parent_task_id: TASK-1
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Добавить GitHub Actions воркфлоужеры для автоматизации работы с метапакетом.

**Контекст**: Diplodoc использует GitHub Actions для:
1. Автоматической обновки submodules (по hourly расписанию): каждый submodule обновляет master-ветку в метапакете
2. CI: проверка целостности submodules и lint root-конфига

**Что создать** (`.github/workflows/`):
- `sync-submodules.yml` — запускается по расписанию (например, ежечасово), обновляет все submodules до последнего master-коммита
- `ci.yml` — запускается по pull request, проверяет `npm run check-submodules`

Ссылка: `/Users/3y3k0/doctools/diplodoc/.github/workflows/` — смотрите как образец.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 `sync-submodules.yml` автоматически обновляет submodule-коммиты по расписанию
- [ ] #2 `ci.yml` запускается на pull request и проверяет целостность метапакета
- [ ] #3 GitHub Actions имеет права на запись в репозиторий (PAT или deploy key настроен)
<!-- AC:END -->
