---
id: TASK-1.5
title: Создать submodules.conf и скрипты управления submodules
status: To Do
assignee: []
created_date: '2026-02-17 20:26'
labels:
  - metapackage
  - scripts
dependencies:
  - TASK-1.4
references:
  - /Users/3y3k0/doctools/diplodoc/submodules.conf
  - /Users/3y3k0/doctools/diplodoc/scripts/
parent_task_id: TASK-1
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Diplodoc использует `submodules.conf` — список всех submodules для скрипта `add-submodules.sh`, который добавляет/удаляет submodules согласно конфигу. Нужно добавить аналогичный механизм в ojson.

**Контекст**: Пример из Diplodoc: `submodules.conf` перечисляет `url|path` пар. Скрипт `add-submodules.sh` читает конфиг, добавляет новые и удаляет устаревшие. Скрипт `check-submodules.sh` проверяет статус.

**Что создать** (в `/Users/3y3k0/doctools/ojson/`):
- `submodules.conf` — список всех submodules
- `scripts/add-submodules.sh` — добавляет/удаляет submodules
- `scripts/check-submodules.sh` — проверает статус submodules
- `scripts/bootstrap.sh` — инициализация (`git submodule update --init --recursive && npm install`)
- npm-скрипты в root `package.json`: `bootstrap`, `check-submodules`, `add-submodules`

Ссылка на Diplodoc для структуры: `/Users/3y3k0/doctools/diplodoc/submodules.conf`, `/Users/3y3k0/doctools/diplodoc/scripts/`
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 `submodules.conf` перечисляет все 5 модулей с их URL и путями
- [ ] #2 `npm run bootstrap` инициализирует все submodules и устанавливает зависимости
- [ ] #3 `npm run add-submodules` синхронизирует submodules согласно `submodules.conf`
- [ ] #4 `npm run check-submodules` выводит статус всех submodules
<!-- AC:END -->
