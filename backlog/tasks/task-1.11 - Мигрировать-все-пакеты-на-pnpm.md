---
id: TASK-1.11
title: Мигрировать все пакеты на pnpm
status: To Do
assignee: []
created_date: '2026-02-17 21:36'
labels:
  - metapackage
  - pnpm
dependencies: []
parent_task_id: TASK-1
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Каждый пакет ojson сейчас использует npm (есть `package-lock.json`). Необходимо перевести все пакеты на pnpm, чтобы стандартизировать инструментарий во всем экосистеме и обеспечить корректную работу в метапакете.

**Контекст**: Метапакет `ojson-platform/ojson` использует pnpm workspaces (TASK-1.2). Индивидуальные пакеты должны тоже использовать pnpm для автономной разработки (чтобы lockfile и CI были согласованы).

**Что делается для каждого пакета**:
1. Удалить `package-lock.json`, добавить в `.gitignore`
2. Запустить `pnpm install` — сгенерирует `pnpm-lock.yaml`
3. Добавить `"packageManager": "pnpm@10.30.0"` в `package.json`
4. Обновить CI-скрипты: `npm ci` → `pnpm install --frozen-lockfile`
5. Проверить, что `pnpm test` и `pnpm build` работают
<!-- SECTION:DESCRIPTION:END -->
