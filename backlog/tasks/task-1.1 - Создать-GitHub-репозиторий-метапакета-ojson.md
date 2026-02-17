---
id: TASK-1.1
title: Создать GitHub-репозиторий метапакета ojson
status: In Progress
assignee: []
created_date: '2026-02-17 20:24'
updated_date: '2026-02-17 21:20'
labels:
  - metapackage
  - setup
dependencies: []
parent_task_id: TASK-1
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Метапакет ojson должен иметь собственный remote-репозиторий на GitHub в организации `ojson-platform`.

**Контекст**: `/Users/3y3k0/doctools/ojson` — свежий git-репо без коммитов и без remote. Уже существующие репозитории модулей: `ojson-platform/http`, `ojson-platform/models`, `ojson-platform/services`.

**Что сделать:**
1. Создать репозиторий на GitHub (например, `ojson-platform/ojson` или `ojson-platform/platform`)
2. Добавить remote к локальному репо: `git remote add origin git@github.com:ojson-platform/ojson.git`
3. Добавить `.gitignore` (минимальный: `node_modules/`)
4. Сделать первый пустой коммит (или коммит с `.gitignore`) и запушить `master`
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 Репозиторий создан на GitHub в организации ojson-platform
- [ ] #2 Локальный git-репо `/Users/3y3k0/doctools/ojson` имеет настроенный remote origin
- [ ] #3 Ветка master запушена в remote
- [ ] #4 `.gitignore` включает `node_modules/`
<!-- AC:END -->

## Implementation Plan

<!-- SECTION:PLAN:BEGIN -->
## Findings

- `gh` CLI авторизован как `3y3`, SSH-протокол, токен имеет scope `repo`
- Организация `ojson-platform` существует, пользователь является её членом
- Существующие репо: `ojson-platform/http`, `ojson-platform/models`, `ojson-platform/services` — все публичные
- Репо `ojson-platform/ojson` ещё не существует
- Локальный `/Users/3y3k0/doctools/ojson` — git-репо на ветке `master`, нет коммитов, нет remote
- В текущем рабочем дереве есть untracked файлы: `.cursor/`, `AGENTS.md`, `backlog/`, и папки модулей (`http/`, `models/`, etc.) — их **не** включаем в первый коммит (модули станут submodules в TASK-1.4)

## Implementation Plan

### Шаг 1. Создать репозиторий на GitHub

```bash
gh repo create ojson-platform/ojson \
  --public \
  --description "Meta-package for ojson platform development"
```

### Шаг 2. Создать `.gitignore`

Создать `/Users/3y3k0/doctools/ojson/.gitignore`:

```
node_modules/
.nx/
build/
dist/
coverage/
*.tsbuildinfo
```

(По аналогии с Diplodoc, который игнорирует `.nx/`, `node_modules/` и `experiments`.)

### Шаг 3. Добавить remote

```bash
git -C /Users/3y3k0/doctools/ojson \
  remote add origin git@github.com:ojson-platform/ojson.git
```

### Шаг 4. Сделать первый коммит с `.gitignore` и `AGENTS.md`

В первый коммит включаем только то, что уже принадлежит метапакету как таковому (не модули):
- `.gitignore`
- `AGENTS.md`
- `backlog/` (задачи)

Модули (`http/`, `models/`, `openapi/`, `server/`, `services/`) в этот коммит **не включаем** — они войдут как submodules в TASK-1.4, а до этого будут в `.gitignore` или просто untracked.

```bash
cd /Users/3y3k0/doctools/ojson
git add .gitignore AGENTS.md backlog/
git commit -m "chore: initial metapackage scaffold"
git push -u origin master
```

### Итог

После выполнения:
- `github.com/ojson-platform/ojson` существует
- `git remote -v` показывает `origin git@github.com:ojson-platform/ojson.git`
- Ветка `master` с одним коммитом запушена
<!-- SECTION:PLAN:END -->
