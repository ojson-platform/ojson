---
id: TASK-1.10.9
title: devops/infra as git submodule
status: Done
assignee: []
created_date: '2026-02-17'
updated_date: '2026-02-18 17:12'
labels:
  - devops
  - metapackage
  - git
dependencies:
  - TASK-1.10.8
  - TASK-1.10.10
parent_task_id: TASK-1.10
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Make `devops/infra` a git submodule of the metapackage (like `packages/http`, `packages/models`, etc.): separate repository; in the metapackage — entry in `.gitmodules` and a commit pointer.

**Context**: Currently devops/infra is a plain directory inside the metapackage. To have infra in its own repo (independent development, own CI, npm publish), move it to a separate repository and add it as a submodule.

**Steps** (same pattern as TASK-1.4):
1. Create a GitHub repository (e.g. `ojson-platform/infra`).
2. Initialize git in the current `devops/infra/` (or move contents into a fresh clone of the repo) and push to remote.
3. In the metapackage: remove `devops/infra` from git tracking (`git rm -r --cached devops/infra` or remove the directory after backup).
4. Add submodule: `git submodule add <url> devops/infra`.
5. If needed, update `scripts/bootstrap.sh`, `scripts/check-submodules.sh` (or equivalent) so devops/infra is included in the submodule list.
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 Repository for @ojson/infra created (e.g. ojson-platform/infra on GitHub)
- [x] #2 In the metapackage, `devops/infra` is added as a git submodule; `git submodule status` shows devops/infra
- [x] #3 `.gitmodules` contains an entry for `devops/infra` with path and url
- [x] #4 `git submodule update --init` successfully initializes devops/infra; after that, `pnpm install` at root links the package
- [x] #5 Metapackage scripts (bootstrap/check-submodules), if any, account for devops/infra
<!-- AC:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
Implementation (2026-02-18): created GitHub repo `ojson-platform/infra`, initialized `devops/infra` as its own git repository, pushed `master`, and added `devops/infra` to the metapackage as a git submodule (`git@github.com:ojson-platform/infra.git`). `.gitmodules` updated accordingly; `git submodule status` shows `devops/infra` at commit `a9d0988...`. Verified `git submodule update --init devops/infra` works. Existing metapackage scripts use `git submodule update --init --recursive` and `git submodule status`, so they automatically include the new submodule (no extra script changes required).
<!-- SECTION:NOTES:END -->
