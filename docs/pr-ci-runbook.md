# PR & Release Runbook

This is the canonical contributor runbook for opening PRs, passing CI, and shipping releases in this repository.

## 1) Before You Open a PR

Run local quality gates first so CI failures are rare.

```bash
# Install dependencies/tools (if needed)
install:all

# Required quality checks
lint:all
test:all
```

Also ensure generated code is up to date if your change affects codegen:

```bash
runner:serverpod
runner:build
```

## 2) Open the PR Correctly

Create a PR targeting `main` and complete all sections of `.github/pull_request_template.md`:

- **Summary** — what changed and why
- **Screenshots** — required for UI/design changes
- **Validation** — exactly what you ran/tested

### UI Screenshot Policy (automated)

PRs are automatically checked by `.github/workflows/ui-screenshot-policy.yml`.

If your PR changes any of these paths, you must include screenshot links in the PR body:

- `verily_app/lib/`
- `verily_ui/lib/`
- `verily_app/assets/`
- `verily_ui/assets/`

Accepted screenshot evidence in PR description includes markdown image links or direct image URLs.

See also: [UI Screenshot Workflow](./ui-screenshot-workflow.md).

## 3) Required Checks & Evidence (Merge-Readiness Matrix)

Main CI is in `.github/workflows/ci.yml` and runs on PRs to `main`.

| Check / Workflow             | Required for merge?                     | What it validates                                                            | Contributor evidence needed                                                                   |
| ---------------------------- | --------------------------------------- | ---------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------- |
| `lint`                       | Yes                                     | Repo lint/format/analyze gates (`lint:all`)                                  | Ensure lint is clean locally before push                                                      |
| `test`                       | Yes                                     | Flutter + `verily_core` automated tests                                      | Include relevant test run notes in PR Validation                                              |
| `server-test`                | Yes                                     | Server tests excluding DB-tagged integration cases                           | Include server test results in Validation                                                     |
| `server-db-integration-test` | Yes                                     | DB-tagged server integration tests                                           | Confirm DB integration tests pass in CI                                                       |
| `integration-test`           | Yes                                     | Patrol/E2E integration tests under `verily_app/integration_test/*_test.dart` | Keep at least one discoverable integration test when job is expected to run                   |
| `ui-screenshot-policy`       | Conditionally required (UI changes)     | Enforces screenshot evidence in PR body for UI-affecting changes             | Add markdown image links or direct image URLs to PR description                               |
| `native-change-check`        | Informational warning (not a hard fail) | Detects native project/dependency file changes and posts guidance            | If triggered, verify native dependency implications and include rationale/testing notes in PR |

### Screenshot requirement triggers

`ui-screenshot-policy` is evaluated on PRs to `main` and requires screenshot links when files change in:

- `verily_app/lib/`
- `verily_ui/lib/`
- `verily_app/assets/`
- `verily_ui/assets/`

Accepted evidence is markdown image syntax or direct image URLs in the PR description.

### Important CI gotchas

- **Integration tests are required if the integration job runs**: the workflow fails when no tests are discovered in `verily_app/integration_test`.
- **UI file changes without PR screenshots fail policy checks**.
- **`native-change-check` warnings should be treated as review-required**: the job is advisory, but reviewers expect explicit confirmation of impact/testing when native files are touched.

## 4) Local Git Hooks You Should Expect

Pre-commit / pre-push hooks are configured in `.pre-commit-config.yaml`.

- Pre-commit runs formatting, analysis, and staged secret scanning.
- Pre-push runs repository secret scanning.

If hooks fail, fix locally before pushing.

## 5) Versioning: Changeset Required

Versioning is managed by Knope (`knope.toml`) and is **changeset-only** (`ignore_conventional_commits = true`).

That means commit message style does **not** determine release bumps.
You must explicitly document the change:

```bash
knope document-change
```

This creates/updates a file under `.changeset/` that drives version/changelog updates.

## 6) Release Flow

### Standard release

```bash
knope release
```

This runs the configured release workflow (prepare + format + release automation).

### Forced release (maintainers)

```bash
knope forced-release
```

Use only when intentionally bypassing the normal prepare flow.

## 7) Quick PR Checklist

- [ ] Ran `lint:all`
- [ ] Ran `test:all`
- [ ] Ran required codegen (`runner:serverpod`, `runner:build`) when applicable
- [ ] Filled PR template sections: Summary, Screenshots, Validation
- [ ] Added screenshot links for UI/design changes
- [ ] Added changeset via `knope document-change` for releasable changes
- [ ] Confirmed no secrets in diff/push

## 8) Single-Command Runbook (copy/paste)

### A) One-command local quality gate

```bash
devenv shell -- bash -lc '
  set -euo pipefail
  install:all
  runner:serverpod
  runner:build
  lint:all
  test:all
  cd verily_server
  dart run test/integration/test_tools/assert_no_db_skip.dart
  dart test --exclude-tags=db
  dart test --tags=db
'
```

### B) PR operations command set

```bash
# 1) Branch + implement
git checkout -b feat/<scope>

# 2) Record release intent (if releasable change)
knope document-change

# 3) Commit + push
git add -A
git commit -m "feat: <summary>"
git push -u origin HEAD

# 4) Open PR (fills template in browser)
gh pr create --base main --fill

# 5) Watch required checks
gh pr checks --watch

# 6) Show branch protection required statuses for main
REPO=$(gh repo view --json nameWithOwner --jq '.nameWithOwner')
gh api repos/$REPO/branches/main/protection --jq '.required_status_checks.contexts[]'
```
