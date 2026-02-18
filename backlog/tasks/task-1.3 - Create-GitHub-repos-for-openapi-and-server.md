---
id: TASK-1.3
title: Create GitHub repositories for openapi and server
status: Done
assignee: []
created_date: '2026-02-17 20:25'
updated_date: '2026-02-17 22:04'
labels:
  - metapackage
  - setup
dependencies: []
parent_task_id: TASK-1
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Modules `openapi` and `server` live in `/Users/3y3k0/doctools/ojson/` as plain directories without git remotes. To turn them into git submodules, create separate GitHub repositories for them first.

**Context**:
- `openapi` (`@ojson/openapi`) — private tool: HTTP client generator from OpenAPI specs
- `server` (`@ojson/server`) — server application using `@ojson/models`
- Existing repos: `ojson-platform/http`, `ojson-platform/models`, `ojson-platform/services`

**To do**:
1. Create `ojson-platform/openapi` on GitHub
2. Create `ojson-platform/server` on GitHub
3. Add remote to local directories and do initial push (init git and push current code)

Note: decide whether `openapi` should be public or private.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [ ] #1 `ojson-platform/openapi` created on GitHub
- [ ] #2 `ojson-platform/server` created on GitHub
- [ ] #3 Current code pushed to remote (branch master/main exists on remote)
<!-- AC:END -->

## Implementation Plan

<!-- SECTION:PLAN:BEGIN -->
## Findings

**`openapi`** (`/Users/3y3k0/doctools/ojson/openapi`):
- git repo on `master`, no commits (fresh init)
- Untracked: `.gitignore`, `README.md`, `fixtures/`, `package-lock.json`, `package.json`, `src/`, `tsconfig.json`
- `generated/` and `node_modules/` — in `.gitignore`, do not commit
- `"private": true` — prevents npm publish; remove later (TASK-1.11.4)
- Development followed plan `services/docs/PROJECTS/openapi-client.md`

**`server`** (`/Users/3y3k0/doctools/ojson/server`):
- git repo on `master`, 1 commit (`feat(server): add base server infrastructure`)
- Working tree clean
- No remote

**`openapi` implementation status** (from `openapi-client.md`):
- ✅ Stage 1: OpenAPI → route/options mapping (in `mapOperations.ts`)
- ✅ Stage 2: integration with @ojson/http (`generateClient.ts`)
- ✅ Stage 3: typing (`generateTypes.ts`)
- ✅ Stage 4: code structure (`index.ts` + `types.ts`)
- ⚠️ Stage 5: CLI exists but no proper argument parsing
- ❌ Stage 6: no tests
- ⚠️ Stage 7: minimal documentation

## Implementation Plan

### Step 1. Create repositories on GitHub

```bash
gh repo create ojson-platform/openapi \
  --public \
  --description "OpenAPI to typed HTTP client generator (transport: @ojson/http)"

gh repo create ojson-platform/server \
  --public \
  --description "Server application using @ojson/models"
```

### Step 2. `openapi` — meaningful first commit

Commit everything except `node_modules/` and `generated/` (already in `.gitignore`).

```bash
cd /Users/3y3k0/doctools/ojson/openapi
git remote add origin git@github.com:ojson-platform/openapi.git
git add .
git commit -m "feat(openapi): initial OpenAPI to typed HTTP client generator

Implemented core generation pipeline:
- Load and parse OpenAPI 3.x specs (YAML/JSON, $ref bundling)
- Map operations to @ojson/http routes and RequestOptions
- Generate TypeScript types from OpenAPI schemas
- Generate typed client factory with @ojson/http integration
- Security schemes, x-retries extension support
- Basic CLI entry point

Pending: proper CLI args, tests, advanced schema features (allOf, oneOf)"
git push -u origin master
```

### Step 3. `server` — add remote and push

```bash
cd /Users/3y3k0/doctools/ojson/server
git remote add origin git@github.com:ojson-platform/server.git
git push -u origin master
```

### Step 4. Transform `openapi-client.md` into backlog

Create backlog tasks for plan stages 5–7 (stages 1–4 largely done). Remove file `services/docs/PROJECTS/openapi-client.md` and commit in `services`.

## Result

- `github.com/ojson-platform/openapi` exists with a meaningful first commit
- `github.com/ojson-platform/server` exists
- `openapi-client.md` removed, work moved to backlog
<!-- SECTION:PLAN:END -->
