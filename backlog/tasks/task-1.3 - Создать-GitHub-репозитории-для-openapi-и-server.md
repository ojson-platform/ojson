---
id: TASK-1.3
title: Создать GitHub-репозитории для openapi и server
status: To Do
assignee: []
created_date: '2026-02-17 20:25'
labels:
  - metapackage
  - setup
dependencies: []
parent_task_id: TASK-1
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Модули `openapi` и `server` находятся в `/Users/3y3k0/doctools/ojson/` как обычные директории без git-ремота. Чтобы превратить их в git submodules, нужно сначала создать для них отдельные GitHub-репозитории.

**Контекст**:
- `openapi` (`@ojson/openapi`) — приватный инструмент: генератор HTTP-клиентов из OpenAPI-спецификаций
- `server` (`@ojson/server`) — серверное приложение на `@ojson/models`
- Существующие репо: `ojson-platform/http`, `ojson-platform/models`, `ojson-platform/services`

**Что сделать**:
1. Создать `ojson-platform/openapi` на GitHub
2. Создать `ojson-platform/server` на GitHub
3. Добавить remote к локальным директориям, сделать первый пуш (инициализировать git и пушнуть текущий код)

Примечание: разумно решить, делать ли `openapi` публичным или приватным репозиторием.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 `ojson-platform/openapi` создан на GitHub
- [ ] #2 `ojson-platform/server` создан на GitHub
- [ ] #3 Текущий код пушнут в remote (ветка master/main существует в remote)
<!-- AC:END -->
