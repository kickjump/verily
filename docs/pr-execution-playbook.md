# PR Execution Playbook

Source synthesis for this playbook:

- `PLAN.md`
- `docs/pre-pr-gate-matrix.md`
- `docs/ui-screenshot-workflow.md`
- `docs/pulumi-guide.md`
- `docs/marketplace-screen-rollout-plan.md`
- `docs/api-plan.md`

Use this as the practical checklist from branch creation to merge-ready PR.

## 1) Branching & Scope Setup

1. Create a focused branch from `main`:
   - `feat/<short-scope>` for features
   - `fix/<short-scope>` for bug fixes
   - `chore/<short-scope>` for maintenance/docs/tooling
2. Keep scope aligned to one PLAN phase item (or one tightly-related vertical slice).
3. If DB schema changes are needed, plan for **max one Serverpod migration** in the branch.
4. If task is ~1-hour and production-impacting, trigger the mandatory LLM artifact chain before coding:
   - Claude design artifact: `docs/research/claude/<task-slug>.md`
   - Gemini research artifact: `docs/research/gemini/<task-slug>.md`
   - Codex implementation and verification evidence in PR

## 2) Implementation Guardrails

- Use localization for all user-facing text (`AppLocalizations` + ARB updates).
- Keep generated code committed when applicable, in a dedicated commit if possible.
- Keep commits conventional:
  - `<type>: <description>`
  - Allowed types: `feat`, `fix`, `chore`, `docs`, `ci`, `test`, `refactor`
- For release-impacting changes, use changeset workflow (not commit-message-driven versioning):
  - `knope document-change`

## 3) Validation Checklist (Before PR Open)

Run relevant checks for changed scope and collect outputs for PR evidence:

- Static checks / formatting / lint (repo-standard commands)
- Targeted tests + broader tests as needed by testing pyramid:
  - Unit/provider/util tests
  - Widget tests for changed screens/components
  - Integration tests for major changed flows
- If UI changed, validate screenshot policy requirements (see Section 4)
- If infra changed (`infra/**`, `Dockerfile`), run Pulumi preview flow (see Section 5)

Also verify:

- PLAN alignment is explicit in notes
- Migration count is `0` or `1`
- Changeset included when needed

## 4) UI Screenshot Workflow (Required for UI/Design PRs)

For any UI/design change, PR must include screenshots and pass screenshot policy CI.

Recommended high-fidelity capture path:

1. Ensure Xcode license accepted:
   - `sudo xcodebuild -license`
2. Run app in simulator (not flutter test rendering) using example routes/defines:
   - Login screen (logged out): `--dart-define=FORCE_LOGGED_OUT_FOR_TESTS=true --route /login`
   - Feed screen (authenticated): `--dart-define=BYPASS_AUTH_FOR_TESTS=true --route /feed`
   - Verify screen: `--dart-define=BYPASS_AUTH_FOR_TESTS=true --route /verify`
3. Capture screenshots with `xcrun simctl io <device-udid> screenshot <path>`
4. Attach images to PR and fill `Screenshots` section.

Optional integration capture runner:

- `devenv shell -- ./tools/run_patrol_integration_tests.sh`
- Useful env vars:
  - `PATROL_DEVICE_ID`
  - `PATROL_SCREENSHOT_DIR`
  - `CAPTURE_UI_SCREENSHOTS`

## 5) Infrastructure Change Flow (Pulumi)

If PR changes infra behavior (`infra/**`, deployment config, or `Dockerfile`):

1. Install deps / auth:
   - `install:all`
   - `pulumi login`
2. Ensure stack is initialized and ESC env configured (no secrets in stack YAML).
3. Preview:
   - `infra:preview <stack>` (typically `staging`)
4. Include preview summary/evidence in PR.
5. On merge-to-main, deployment path should follow repo CI/CD policy (preview on PR, deploy on push/main as configured).

Notes:

- Config/secrets must live in Pulumi ESC environments.
- Document any required operator steps (image push, service rollout) in PR notes.

## 6) Release Notes / Versioning

When change affects published packages or user-facing release surface:

1. Create changeset via Knope (`knope document-change`).
2. Include changeset path in PR body.
3. Do not rely on conventional commit messages to trigger version bumps.

If no release impact, explicitly mark `Changeset: N/A` with reason.

## 7) PR Description Template (Copy/Paste)

```md
## Summary

- What changed and why.

## Plan Alignment

- PLAN phase/item: <phase + bullet>
- Deviation (if any): <none or explain>

## Pre-PR Gate Evidence

- Claude artifact: docs/research/claude/<task-slug>.md
- Gemini artifact: docs/research/gemini/<task-slug>.md
- Changeset: <path or N/A + reason>
- Migration count: <0|1>
- Localization: <ARB + usage evidence>

## Validation

- Analyze/lint/format: <commands + result>
- Tests:
  - Unit/provider: <commands + result>
  - Widget: <commands + result>
  - Integration: <commands + result>

## UI Evidence (if applicable)

- Screenshots: <attached images or links>
- Patrol run (optional): <command + result>

## Infra Evidence (if applicable)

- Pulumi preview: <stack + summary/link>
- Deployment notes: <operator steps if any>
```

## 8) Merge Readiness Final Checklist

- [ ] Scope is focused and PLAN-aligned
- [ ] LLM artifact chain present when required
- [ ] Conventional commits valid
- [ ] Changeset added or N/A justified
- [ ] Migration count <= 1
- [ ] Localization complete for new UI strings
- [ ] Tests at required levels are passing
- [ ] UI screenshots attached for UI/design PRs
- [ ] Pulumi preview evidence included for infra-impacting PRs
- [ ] PR template sections fully populated

## 9) Runbook Command Set (single-command option)

If you want one command to run the local PR gate sequence:

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

For PR operations (`gh pr create`, `gh pr checks --watch`, branch-protection status checks), use the command set in `docs/pr-ci-runbook.md`.
