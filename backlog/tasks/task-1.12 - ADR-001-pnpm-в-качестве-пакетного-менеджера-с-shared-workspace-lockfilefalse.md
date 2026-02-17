---
id: TASK-1.12
title: 'ADR-001: pnpm в качестве пакетного менеджера с shared-workspace-lockfile=false'
status: To Do
assignee: []
created_date: '2026-02-17 21:44'
labels:
  - adr
  - docs
dependencies:
  - TASK-1.2
parent_task_id: TASK-1
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Зафиксировать в ADR решение о выборе pnpm и параметра `shared-workspace-lockfile=false`.

**Создать файл** `docs/adr/001-pnpm-shared-workspace-lockfile.md`.

**Контекст решения** (проработан в ходе TASK-1.2):

- **Почему pnpm**, а не npm: hard links, строгая изоляция (phantom deps невозможны), быстрая установка, catalogs

- **Почему `shared-workspace-lockfile=false`**: пакеты являются git submodules. При `true` lockfile живёт только в корне метапакета — standalone-репо пакета его не видит, рассинхронизация неизбежна. При `false` lockfile живёт внутри submodule — это один файл для обоих контекстов.

- **Почему не `workspace:*`**: разрушает автономную установку пакета. Используем semver-диапазоны — pnpm автоматически резолвит в локальный пакет в workspace, из реестра в standalone.

- **Трейдофф**: при `false` pnpm не дедуплицирует sub-зависимости между пакетами через общий lockfile. Приемлемо — набор пакетов небольшой.
<!-- SECTION:DESCRIPTION:END -->
