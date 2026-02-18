# GitHub Actions

- **sync-submodules.yml** — runs on schedule (daily), on push to `master`, and manually; updates all submodules to latest and pushes a commit. Uses `GITHUB_TOKEN` for checkout and push. If the repo has "Restrict GITHUB_TOKEN" or branch protection that blocks bot pushes, add a PAT or deploy key to secrets and pass it as `token` in the checkout step.
- **ci.yml** — runs on pull requests; verifies all submodules are initialized via `pnpm run check-submodules`.
