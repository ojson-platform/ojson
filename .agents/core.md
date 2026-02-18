# Agent Guide – Core Concepts

## Platform overview

ojson is an ecosystem of TypeScript/Node packages:

- **@ojson/http** — HTTP client with composable middleware (bind, compose, withAuth, withRetry)
- **@ojson/models** — Shared data models
- **@ojson/services** — Services layer
- **@ojson/openapi** — Build-time generator of typed HTTP clients from OpenAPI specs (uses @ojson/http as transport)
- **@ojson/server** — Server application (depends on @ojson/models)

Each package is published on npm under the `@ojson` scope and can be used independently.

## Metapackage vs monorepo

This is a **metapackage**, not a monorepo:

- **Monorepo**: Shared infrastructure that all packages depend on; packages are often tied to the repo.
- **Metapackage**: Adds infrastructure for **collaborative development** of multiple packages; each package is a **standalone unit** that can be cloned separately and developed without the metapackage.

**Implications:**

- Each package can be developed and published on its own
- Packages do not depend on metapackage-specific tooling for runtime
- Cross-package dependencies use **semver ranges** (e.g. `^1.1.2`), not `workspace:*`, so packages remain installable from npm when used standalone
- The metapackage is optional

## Project structure

- **`packages/`** — All current submodules (http, models, services, openapi, server). Each is a separate Git repository.
- **`devops/`** — Reserved for shared infra (e.g. `@ojson/infra` — ESLint, Prettier, TypeScript config, Vitest).
- **`scripts/`** — `check-submodules.sh` (verify submodules initialized), `bootstrap.sh` (init submodules + pnpm install).
- **Root** — `package.json`, `pnpm-workspace.yaml`, `.gitmodules`. No `apps/` submodules in use; server lives in `packages/server`.

## Workspace

The metapackage uses **pnpm workspaces** (`pnpm-workspace.yaml`):

```yaml
packages:
  - 'packages/*'
  - 'devops/*'
```

- Submodules are linked so that `pnpm install` at root installs and links all `@ojson/*` packages
- Cross-package dependencies use semver; pnpm resolves them to the local workspace when present
- Lockfile: `shared-workspace-lockfile=false` — each submodule keeps its own `pnpm-lock.yaml` (see ADR-001)

## Submodules

All packages under `packages/` are **git submodules** (separate repos in [ojson-platform](https://github.com/ojson-platform)). The metapackage records a specific commit per submodule.

- **Sync/update**: GitHub Action runs on schedule and on push to master to update submodule pointers; or run manually: `git submodule update --init --recursive --remote`
- **Check status**: `pnpm run check-submodules`
- **Add a new repo**: use the `/submodule` Cursor command (or `git submodule add` manually)

## Key principle

**Each package is standalone; the metapackage is optional.** Dependencies between packages use normal semver ranges. For architecture details see `docs/adr/` (ADR-001: pnpm and lockfile, ADR-002: metapackage architecture) when those documents exist.
