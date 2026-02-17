---
id: TASK-1.9
title: Написать README и AGENTS.md метапакета
status: To Do
assignee: []
created_date: '2026-02-17 20:28'
labels:
  - metapackage
  - docs
dependencies:
  - TASK-1.2
references:
  - /Users/3y3k0/doctools/diplodoc/AGENTS.md
  - /Users/3y3k0/doctools/diplodoc/.agents/core.md
  - /Users/3y3k0/doctools/ojson/AGENTS.md
parent_task_id: TASK-1
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Документировать структуру и принципы метапакета ojson.

**Контекст**: Аналогично Diplodoc, у ojson должны быть:
- `README.md` — для человека: что такое ojson, какие пакеты входят, как начать
- `AGENTS.md` — для AI-агентов: обзор структуры, особенностям метапакета vs монорепы
- `.agents/core.md` (или аналогичный файл) — детальное описание: пакеты, зависимости, submodules

**Текущее состояние**: `/Users/3y3k0/doctools/ojson/AGENTS.md` уже существует, но описывает только backlog-воркфлоу. Нужно расширить.

Ссылка на Diplodoc: `/Users/3y3k0/doctools/diplodoc/AGENTS.md`, `/Users/3y3k0/doctools/diplodoc/.agents/core.md`
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 `README.md` описывает: что такое ojson-платформа, список пакетов, шаги `npm run bootstrap`
- [ ] #2 `AGENTS.md` объясняет структуру метапакета для AI-агентов: пакеты, зависимости, отличие метапакета от монорепы
- [ ] #3 Документация содержит информацию о принципе метапакета: каждый пакет — самостоятельный, метапакет не обязателен
<!-- AC:END -->
