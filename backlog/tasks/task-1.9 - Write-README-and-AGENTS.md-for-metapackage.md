---
id: TASK-1.9
title: Write README and AGENTS.md for the metapackage
status: Done
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
Document the structure and principles of the ojson metapackage.

**Context**: Like Diplodoc, ojson should have:
- `README.md` — for humans: what ojson is, which packages it includes, how to get started
- `AGENTS.md` — for AI agents: overview of structure, metapackage vs monorepo specifics
- `.agents/core.md` (or similar) — detailed description: packages, dependencies, submodules

**Current state**: `/Users/3y3k0/doctools/ojson/AGENTS.md` exists but only describes the backlog workflow. Needs to be extended.

Reference: `/Users/3y3k0/doctools/diplodoc/AGENTS.md`, `/Users/3y3k0/doctools/diplodoc/.agents/core.md`
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 `README.md` describes: what the ojson platform is, list of packages, steps for `pnpm run bootstrap`
- [x] #2 `AGENTS.md` explains metapackage structure for AI agents: packages, dependencies, metapackage vs monorepo
- [x] #3 Documentation states the metapackage principle: each package is standalone, metapackage is optional
<!-- AC:END -->

## Implementation Plan

<!-- SECTION:PLAN:BEGIN -->
### Findings

**ojson current state**
- **README.md**: does not exist; must be created from scratch.
- **AGENTS.md**: exists, contains only Backlog.md MCP instructions and the "task language: English" note. No metapackage overview.
- **.agents/**: directory does not exist. Diplodoc has `.agents/core.md`, `.agents/monorepo.md`, etc. Task asks for "`.agents/core.md` (or similar)" — we can start with a single `.agents/core.md` for ojson and keep AGENTS.md as a short index that points to it.
- **package.json**: name `@ojson/ojson`, scripts reference `scripts/bootstrap.sh` and `scripts/add-submodules.sh` but only `scripts/check-submodules.sh` exists (TASK-1.5 rejected). So "bootstrap" steps in README should describe either (a) manual equivalent: `git submodule update --init --recursive && pnpm install`, or (b) note that `pnpm run bootstrap` will run once `scripts/bootstrap.sh` is added; until then use the manual commands.
- **Submodules** (from `.gitmodules`): `packages/http`, `packages/models`, `packages/services`, `packages/openapi`, `packages/server` — all under `packages/`. No `devops/` or `apps/` submodules yet (devops/infra is TASK-1.10).
- **pnpm**: root uses `pnpm@10.30.0`; README/AGENTS should say `pnpm` (not npm) for install and scripts.

**Diplodoc reference**
- **README.md**: short platform pitch, "Getting Started" (link to docs/codespace), "Contribution" (link to DEVELOPMENT.md), "Adding/removing subrepositories" (check-submodules, add-submodules). No long prose; clear sections.
- **AGENTS.md**: short index listing `.agents/*` files and what each covers (core, monorepo, style-and-testing, dev-infrastructure). No inline content.
- **.agents/core.md**: platform overview, "Metapackage vs Monorepo" (key distinction), project structure (packages/, extensions/, devops/, scripts/), package hierarchy, workspace config, submodules, Nx, key concepts. Ojson is smaller; we need a shorter core.md focused on ojson.

**AC#1** says "steps for `npm run bootstrap`" — treat as "steps to bootstrap the metapackage"; use `pnpm run bootstrap` in text when referring to the script, and document the manual alternative until bootstrap.sh exists.

---

### Step 1. Create `README.md`

**Sections to include (English):**

1. **Title and one-line description**  
   e.g. "ojson — Meta-package for ojson platform development."

2. **What is ojson**  
   Short paragraph: platform/ecosystem of packages for … (derive from package names: http client, models, services, openapi generator, server). Link to GitHub org or main repos if desired.

3. **Packages**  
   List the five packages with paths and npm names:
   - `packages/http` → `@ojson/http`
   - `packages/models` → `@ojson/models`
   - `packages/services` → `@ojson/services`
   - `packages/openapi` → `@ojson/openapi`
   - `packages/server` → `@ojson/server`

4. **Getting started / Bootstrap**  
   - Clone: `git clone --recurse-submodules https://github.com/ojson-platform/ojson.git` (or SSH).
   - Install: `pnpm install` (from root).
   - If submodules were not cloned: `git submodule update --init --recursive` then `pnpm install`.
   - Mention that `pnpm run bootstrap` is the intended one-liner once `scripts/bootstrap.sh` exists; until then use the commands above.
   - Optional: `pnpm run build`, `pnpm run test` from root.

5. **Metapackage vs standalone**  
   One sentence: each package is a separate Git repository and can be developed and published on its own; the metapackage is optional and used for coordinated development.

6. **Contributing / docs**  
   Point to AGENTS.md for AI agents and, if present, to any contribution or development doc.

Keep README concise (similar to Diplodoc’s README length).

---

### Step 2. Extend `AGENTS.md`

**Keep existing block** (Backlog.md MCP + task language).

**Add a short "Metapackage" block** (before or after the BACKLOG block):

- This repo is a **metapackage**: each package under `packages/` is a separate Git repository (git submodule) and can be cloned and developed standalone.
- For detailed structure, packages, dependencies, and metapackage vs monorepo, see **`.agents/core.md`**.
- Optional: one line on pnpm (root uses pnpm; run `pnpm install`, `pnpm run check-submodules`, etc.).

So AGENTS.md = index + metapackage pointer + link to .agents/core.md.

---

### Step 3. Create `.agents/core.md`

**Contents (adapted from Diplodoc, trimmed for ojson):**

1. **Platform / ecosystem overview**  
   What the ojson packages are for (HTTP client, data models, services, OpenAPI client generator, server app).

2. **Metapackage vs monorepo**  
   Same idea as Diplodoc: metapackage adds infrastructure for multi-package development; each package is a standalone unit; no obligation to use the metapackage.

3. **Project structure**  
   - `packages/` — all current submodules (http, models, services, openapi, server).
   - `devops/` — reserved for infra (e.g. `@ojson/infra` from TASK-1.10).
   - `scripts/` — check-submodules.sh; bootstrap.sh and add-submodules not present (TASK-1.5 rejected).
   - Root: pnpm workspace (`pnpm-workspace.yaml`), `package.json`, `.gitmodules`.

4. **Workspace**  
   pnpm workspaces; `packages/*` and `devops/*`; each package is a submodule; cross-package deps use semver (not `workspace:*`) so packages stay publishable and standalone.

5. **Submodules**  
   List from `.gitmodules`; note that submodules are independent repos; sync/update via GitHub Actions (see .github/workflows) or manually `git submodule update --init --recursive`.

6. **Key principle**  
   Each package is standalone; metapackage is optional; dependencies between packages use normal semver ranges (see ADR-001/002 if they exist).

No need to duplicate full dependency graphs yet; keep core.md a few dozen lines.

---

### Step 4. Optional: minimal `scripts/bootstrap.sh`

If we want `pnpm run bootstrap` to work without TASK-1.5:

- Script: `git submodule update --init --recursive && pnpm install`.
- Makes README’s "run bootstrap" instruction accurate.

Decision: either add this in TASK-1.9 so AC#1 is fully satisfied, or document only the manual steps and leave bootstrap.sh for a later task. **Recommendation**: add a minimal `scripts/bootstrap.sh` in this task so README can say "run `pnpm run bootstrap`" and it works.

---

### File list after implementation

| Path | Purpose |
|------|--------|
| `README.md` | Human-facing: what ojson is, packages, bootstrap steps, metapackage note. |
| `AGENTS.md` | Existing Backlog block + metapackage paragraph + link to .agents/core.md. |
| `.agents/core.md` | Agent-focused: metapackage vs monorepo, structure, workspace, submodules. |
| `scripts/bootstrap.sh` | (Optional) `git submodule update --init --recursive && pnpm install`. |

---

### Out of scope

- Full `.agents/monorepo.md` or style/dev-infrastructure (can be added later).
- Translating or changing existing Backlog.md MCP block in AGENTS.md.
<!-- SECTION:PLAN:END -->
