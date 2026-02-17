---
id: TASK-1.4
title: Конвертировать модули в git submodules метапакета
status: To Do
assignee: []
created_date: '2026-02-17 20:26'
labels:
  - metapackage
  - git
dependencies:
  - TASK-1.1
  - TASK-1.2
  - TASK-1.3
parent_task_id: TASK-1
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Сейчас все модули (`http`, `models`, `services`, `openapi`, `server`) — обычные поддиректории в корне метапакета. Нужно конвертировать их в git submodules, чтобы каждый оставался независимым git-репозиторием.

**Контекст**: В метапакете (по аналогии с Diplodoc) каждый пакет — отдельный git submodule (собственный репозиторий). Это позволяет клонировать пакет отдельно и работать с ним независимо.

**Предварительные условия**:
- TASK-1.1: GitHub-репо метапакета создан
- TASK-1.2: Определена структура директорий (куда перемещать пакеты: `packages/`, `tools/` и т.д.)
- TASK-1.3: GitHub-репо для `openapi` и `server` созданы

**Шаги**:
1. Удалить директории модулей из git-трекинга метапакета (`git rm -r --cached http models services openapi server`)
2. При необходимости — переместить директории в нужные поддиректории (например, `packages/http`)
3. Добавить каждый как submodule:
   - `git submodule add git@github.com:ojson-platform/http.git packages/http`
   - аналогично для models, services, openapi, server
4. Зафиксировать `.gitmodules` и submodule-коммиты
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 Все 5 модулей добавлены как git submodules (`git submodule status` показывает все)
- [ ] #2 `.gitmodules` содержит все submodule-записи
- [ ] #3 `git submodule update --init` успешно инициализирует все модули
- [ ] #4 Существующий код модулей не потерян (история сохранена в отдельных репозиториях)
<!-- AC:END -->
