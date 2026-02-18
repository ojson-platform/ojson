---
id: TASK-1.1
title: Create GitHub repository for ojson metapackage
status: Done
assignee: []
created_date: '2026-02-17 20:24'
updated_date: '2026-02-17 21:21'
labels:
  - metapackage
  - setup
dependencies: []
parent_task_id: TASK-1
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
The ojson metapackage must have its own remote repository on GitHub in the `ojson-platform` organization.

**Context**: `/Users/3y3k0/doctools/ojson` is a fresh git repo with no commits and no remote. Existing module repos: `ojson-platform/http`, `ojson-platform/models`, `ojson-platform/services`.

**To do:**
1. Create a repository on GitHub (e.g. `ojson-platform/ojson` or `ojson-platform/platform`)
2. Add remote to local repo: `git remote add origin git@github.com:ojson-platform/ojson.git`
3. Add `.gitignore` (minimal: `node_modules/`)
4. Make the first empty commit (or a commit with `.gitignore`) and push `master`
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 Repository created on GitHub in the ojson-platform organization
- [x] #2 Local git repo `/Users/3y3k0/doctools/ojson` has remote origin configured
- [x] #3 Branch master pushed to remote
- [x] #4 `.gitignore` includes `node_modules/`
<!-- AC:END -->

## Implementation Plan

<!-- SECTION:PLAN:BEGIN -->
## Findings

- `gh` CLI is authorized as `3y3`, SSH protocol, token has `repo` scope
- Organization `ojson-platform` exists, user is a member
- Existing repos: `ojson-platform/http`, `ojson-platform/models`, `ojson-platform/services` — all public
- Repo `ojson-platform/ojson` does not exist yet
- Local `/Users/3y3k0/doctools/ojson` — git repo on branch `master`, no commits, no remote
- Working tree has untracked files: `.cursor/`, `AGENTS.md`, `backlog/`, and module dirs (`http/`, `models/`, etc.) — **do not** include them in the first commit (modules will become submodules in TASK-1.4)

## Implementation Plan

### Step 1. Create repository on GitHub

```bash
gh repo create ojson-platform/ojson \
  --public \
  --description "Meta-package for ojson platform development"
```

### Step 2. Create `.gitignore`

Create `/Users/3y3k0/doctools/ojson/.gitignore`:

```
node_modules/
.nx/
build/
dist/
coverage/
*.tsbuildinfo
```

(Similar to Diplodoc, which ignores `.nx/`, `node_modules/` and `experiments`.)

### Step 3. Add remote

```bash
git -C /Users/3y3k0/doctools/ojson \
  remote add origin git@github.com:ojson-platform/ojson.git
```

### Step 4. Make first commit with `.gitignore` and `AGENTS.md`

Include in the first commit only what belongs to the metapackage itself (not modules):
- `.gitignore`
- `AGENTS.md`
- `backlog/` (tasks)

Do **not** include modules (`http/`, `models/`, `openapi/`, `server/`, `services/`) — they will be added as submodules in TASK-1.4; until then they stay in `.gitignore` or untracked.

```bash
cd /Users/3y3k0/doctools/ojson
git add .gitignore AGENTS.md backlog/
git commit -m "chore: initial metapackage scaffold"
git push -u origin master
```

### Result

After completion:
- `github.com/ojson-platform/ojson` exists
- `git remote -v` shows `origin git@github.com:ojson-platform/ojson.git`
- Branch `master` with one commit is pushed
<!-- SECTION:PLAN:END -->
