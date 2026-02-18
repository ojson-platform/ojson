---
id: TASK-1.10.8
title: '@ojson/infra: scaffolding (init/add CLI)'
status: Done
assignee: []
created_date: '2026-02-17'
updated_date: '2026-02-18 15:16'
labels:
  - devops
  - metapackage
dependencies:
  - TASK-1.10.6
parent_task_id: TASK-1.10
---

## Description

<!-- SECTION:DESCRIPTION:BEGIN -->
Add a CLI to @ojson/infra so that from a package directory the user can run (e.g.) `pnpm exec ojson-infra init` and get:

1. **Config files** created or updated: `eslint.config.js`, `prettier.config.js`, `vitest.config.mjs`, and optionally `tsconfig.json`, all using re-exports / extends from @ojson/infra.
2. **Base workflows**: e.g. `.github/workflows/ci.yml` (or similar) — lint, test, build — so every package gets a minimal CI without copy-paste.
3. **Common agents parts**:
   - **AGENTS.md**: do **not** fully overwrite. Add or update an **important** section that explains that additional AGENTS.md fragments can be read in the `.agents/` directory, with a short description of what each fragment is for.
   - **.agents/**: place fragments here. One fragment must describe that the package can run in **two modes** (metapackage and standalone), the **behavioral differences** between them, and **how to determine the current mode** (copyable skill or command for agents).

Behaviour: idempotent where possible; ask before overwriting or support `--force`. Expose the command via `bin` in package.json. Document in README (add a “Scaffolding” subsection).
<!-- SECTION:DESCRIPTION:END -->

## Acceptance Criteria
<!-- AC:BEGIN -->
- [x] #1 Package has a `bin` entry (e.g. `ojson-infra`) pointing to the CLI script
- [x] #2 Running the CLI in a package directory creates or updates eslint.config.js, prettier.config.js, vitest.config.mjs (and optionally tsconfig.json) with re-exports / extends from @ojson/infra
- [x] #3 Scaffolding adds **base workflows** (e.g. `.github/workflows/` with CI: lint, test, build) so packages get a minimal shared workflow
- [x] #4 Scaffolding adds **common agents parts**: (1) an **important** section in AGENTS.md (without overwriting the rest) that points to `.agents/` and describes each fragment; (2) `.agents/` fragments including one that describes **two modes** (metapackage vs standalone), their differences, and how to detect the current mode (copyable skill/command)
- [x] #5 Overwrite behaviour: either prompt or `--force`; no silent overwrite of user content by default
- [x] #6 README documents how to run the scaffold command and what files (configs, workflows, agents) it creates
<!-- AC:END -->

## Implementation Plan

<!-- SECTION:PLAN:BEGIN -->
### Findings

**Config file content to generate**
- **eslint.config.js**: `export { default } from '@ojson/infra/eslint';` (or .mjs; ESLint 9 loads ESM).
- **prettier.config.js**: `export { default } from '@ojson/infra/prettier';` (or .mjs).
- **vitest.config.mjs**: `export { default } from '@ojson/infra/vitest';` (Vitest often expects .mjs/.ts for ESM).
- **tsconfig.json** (optional): `{ "extends": "@ojson/infra/tsconfig/base", "include": ["src/**/*.ts"], "exclude": ["**/*.spec.ts", "**/*.test.ts"] }` — consumer can override include/exclude. Alternatively extend build for main and test for spec files; keep scaffold simple with one tsconfig extending base.

**Base workflow**
- Existing packages (e.g. http) have separate `.github/workflows/lint.yml` and `test.yml` using Node 20/22, `npm ci`, `npm run lint`, `npm run test:units:fast`, `npm run test:types`. For scaffolded **per-package** CI, emit a single `.github/workflows/ci.yml` that: checkout, setup Node (e.g. 20), enable pnpm (or use npm if preferred), install deps, run lint, run test, run build. Use **pnpm** for consistency with metapackage (`pnpm install --frozen-lockfile`, `pnpm run lint`, `pnpm run test`, `pnpm run build`) so packages that use pnpm get a ready workflow. If the package has only npm lockfile, workflow could use npm; simplest is to scaffold pnpm-based and document that packages can switch.

**Common agents parts**
- **Do not overwrite** the package’s root `AGENTS.md`. Packages may already have project-specific content there.
- **AGENTS.md**: Add an **important** section (append, or insert after existing content) that:
  - States that additional agent guidance is in the **`.agents/`** directory.
  - Lists each fragment in `.agents/` with a **one-line description** of what it covers (e.g. “`.agents/core.md` — core concepts and metapackage vs standalone mode”; “`.agents/dev-infrastructure.md` — lint, test, build tooling”).
- **`.agents/`** directory: Create fragment files. At least one fragment must cover:
  - **Two modes**: the package can be used in **metapackage mode** (developed inside the ojson metapackage workspace, with linked dependencies and shared infra) and **standalone mode** (repo cloned on its own, dependencies installed from npm).
  - **Behavioral differences**: e.g. in metapackage mode cross-package deps may be `workspace:*` and resolve to local clones; in standalone they are version ranges from npm; lockfile and CI may differ; bootstrap and submodule scripts don’t apply standalone.
  - **How to determine current mode**: a **copyable skill or command** (or clear instructions) so an agent can detect “am I in the metapackage root’s workspace or in a standalone clone?” (e.g. “check for `../.gitmodules` and `../pnpm-workspace.yaml` from package root” or “run script X” / “read .agents/detect-mode.md”).
- Optionally: `.cursor/rules/` with a short rule referencing @ojson/infra and .agents.

**CLI implementation**
- **bin**: Add `"bin": { "ojson-infra": "./bin/cli.mjs" }` (or `./bin/init.js`). Entry point must be executable or invoked via `node bin/cli.mjs`. Use ESM (infra is `"type": "module"`).
- **Command**: `init` (e.g. `ojson-infra init` or `node bin/cli.mjs init`). Parse `process.argv`: `init [--force]`. `--force` skips overwrite prompts and overwrites existing files.
- **Cwd**: Run from `process.cwd()`; all paths (eslint.config.js, .github/workflows/ci.yml, etc.) are relative to cwd. Ensure we’re in a package (optional: check for package.json).
- **Overwrite**: For each file, if it exists and not `--force`, prompt (readline) or skip. If no TTY, treat as non-interactive and skip overwrite unless `--force`. Simple approach: no prompt, just `--force` to overwrite; otherwise skip existing files and log “exists, use --force to overwrite”.
- **Templates**: Inline strings in the CLI file, or a `templates/` directory in the package with files (e.g. `templates/eslint.config.js`). Inline keeps a single file and no extra packaging; templates/ is easier to edit. Prefer inline for fewer moving parts; can refactor to templates later.
- **Dependencies**: No new deps required; use `fs`, `path`, `process`. For readline (prompt), use Node’s `readline`; if we skip prompts and only use `--force`, no readline needed.

**Package.json**
- Add `"bin": { "ojson-infra": "./bin/cli.mjs" }`. Include `bin/cli.mjs` in `files` so it’s published.

**README**
- Task 1.10.6 already adds README; 1.10.8 adds a **Scaffolding** subsection: how to run `pnpm exec ojson-infra init` (or `npx ojson-infra init`), what files it creates (configs, .github/workflows/ci.yml, AGENTS.md important section + .agents/ fragments, optionally .cursor/rules), and that `--force` overwrites existing files. Note that AGENTS.md is not fully overwritten — only an important section is added.

---

### Steps

1. **Create `devops/infra/bin/cli.mjs`** (executable or invoked with `node`):
   - Shebang `#!/usr/bin/env node` if we want direct execution.
   - Parse argv: command `init`, option `--force`.
   - For `init`: resolve cwd; optionally check package.json exists. For each target file, check existence; if exists and not --force, skip and log; else write content from inline template.
   - **Config files**: eslint.config.js, prettier.config.js, vitest.config.mjs, tsconfig.json (optional) — full content as above.
   - **Workflow**: .github/workflows/ci.yml — single job: setup-node (20), corepack enable pnpm, pnpm install --frozen-lockfile, pnpm run lint, pnpm run test, pnpm run build (or lint+test only if build optional).
   - **AGENTS.md**: Do **not** overwrite. If AGENTS.md exists, **append** an “Important” (or “Agent guidance”) section that says additional fragments are in `.agents/` and lists each fragment with a one-line description. If AGENTS.md does not exist, create it with that section only.
   - **.agents/**: Create directory and fragment files. Include at least:
     - **.agents/core.md** (or similar): core concepts; **two modes** (metapackage vs standalone); **differences in behavior**; **how to detect current mode** — copyable skill or command (e.g. “Check for presence of `../pnpm-workspace.yaml` and `../.gitmodules` from package root” or a small script path).
     - Optionally .agents/dev-infrastructure.md (lint/test/build), etc., with short descriptions reflected in the AGENTS.md section.
   - Optionally: .cursor/rules/ojson-infra.mdc.
   - Create directories as needed (`.github/workflows`, `.agents`, `.cursor/rules`).

2. **Update `devops/infra/package.json`**: add `"bin": { "ojson-infra": "./bin/cli.mjs" }`, add `"bin"` or `"bin/cli.mjs"` to `files`.

3. **Add Scaffolding subsection to README** (in 1.10.6 README or here): command, list of created files, `--force` behavior.

4. **Verify**: From a clean package directory (or a temp dir with package.json), run `pnpm exec ojson-infra init`; confirm files are created; run again and confirm skip (or prompt); run with `--force` and confirm overwrite. Then run lint/test in that package to ensure scaffolded configs work.

---

### Implementation notes (current progress)

Scaffolding is implemented as **forward-only migrations** tracked by a per-package state file `.infra.json`.

- **CLI**: `devops/infra/bin/cli.mjs` (published via `package.json` `bin: ojson-infra`)
  - Commands: `status`, `plan`, `migrate`, `init` (alias), `author-migration`
- **State**: `.infra.json` in the target package root
- **Engine/libs**:
  - `devops/infra/lib/state.mjs` — load/save state, mark applied
  - `devops/infra/lib/engine.mjs` — plan/run migrations
  - `devops/infra/lib/fileOps.mjs` — safe file writes, AGENTS.md marker upsert
  - `devops/infra/lib/mode.mjs` — detect metapackage vs standalone mode
  - `devops/infra/lib/authorMigration.mjs` — scaffolds a new migration + test stub + changelog entry
- **Migrations**:
  - `devops/infra/migrations/0001_add_infra_configs.mjs`
  - `devops/infra/migrations/0002_add_ci_workflow.mjs`
  - `devops/infra/migrations/0003_add_agents_fragments.mjs`
  - registry: `devops/infra/migrations/index.mjs`

Remaining items (to be completed in this task): vitest tests for engine/migrations, and infra authoring docs + CHANGELOG.
<!-- SECTION:PLAN:END -->

## Implementation Notes

<!-- SECTION:NOTES:BEGIN -->
Verification (local smoke test): created a temp package dir with only `package.json`, then ran `node devops/infra/bin/cli.mjs plan --dry-run` and `node devops/infra/bin/cli.mjs migrate --yes` from that dir. Result: files created: `eslint.config.js`, `prettier.config.js`, `vitest.config.mjs`, `tsconfig.json`, `.github/workflows/ci.yml`, `.agents/core.md`, `.agents/dev-infrastructure.md`, `AGENTS.md`, plus `.infra.json` state. Re-running after apply shows 0 pending migrations (idempotent). Default behavior is safe (skips existing files unless `--force`).

AC#6 still missing: no `devops/infra/README.md` found; only `devops/infra/migrations/README.md` exists. Need to add README “Scaffolding” subsection per task (how to run `pnpm exec ojson-infra init`, what files it creates, and `--force` behavior).

Extra finding: if a target file already exists and you run `migrate` *without* `--force`, migration 0001 will `skipped=1` (keeps user file) but the migration is still recorded as applied in `.infra.json`. That means you cannot later re-run the same migration with `--force` (engine plans only non-applied migrations). Workaround would be manual state edit/delete, or add a dedicated command/migration to “reapply/repair” if desired.

Research: AC#6 is blocked by TASK-1.10.6 — it explicitly requires creating `devops/infra/README.md`, and currently that file does not exist (only `devops/infra/migrations/README.md`). Repo convention: package-level docs live at `<package-root>/README.md` (see `packages/http/README.md`, `packages/models/README.md`, etc.), so for `@ojson/infra` the correct target is `devops/infra/README.md`. Once TASK-1.10.6 is implemented, add a `## Scaffolding` subsection there (command `pnpm exec ojson-infra init` aka `migrate`, list of created files, and overwrite rules: default skip vs `--force`, state `.infra.json`).

Research: current engine marks a migration applied even when it skips due to existing files (safe-by-default). That makes a later `--force` re-run of the same migration impossible without manual `.infra.json` edit or a new “repair/reapply” mechanism. Options if you want to improve UX later: (a) do not mark migration applied if any op is `skipped`; (b) track per-migration partial state; (c) add `ojson-infra repair/reapply` that ignores applied list.

Research conclusion: AC#6 should be completed as part of README work in TASK-1.10.6 (which creates `devops/infra/README.md`). Once that task is done, this task can simply check off AC#6 by ensuring the README contains a `## Scaffolding` section with `ojson-infra init` usage and file list. If you want strict dependency ordering, consider moving AC#6 to TASK-1.10.6 or marking TASK-1.10.8 as blocked until 1.10.6 is Done.

Validation (2026-02-18): `devops/infra/README.md` now contains a `## Scaffolding (optional)` section documenting `pnpm exec ojson-infra init`, the files created (configs, `.github/workflows/ci.yml`, `.agents/*` + managed `AGENTS.md` block, `.infra.json`), and overwrite flags (`--force`, `--dry-run`). This satisfies AC#6.

Validation (smoke test): created a temp package with only `@ojson/infra` as devDependency and ran `pnpm exec ojson-infra init --yes` from the package root. Confirmed created: `eslint.config.js`, `prettier.config.js`, `vitest.config.mjs`, `tsconfig.json`, `.github/workflows/ci.yml`, `.agents/*`, `AGENTS.md`, and `.infra.json`.
<!-- SECTION:NOTES:END -->
