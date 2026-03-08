# Claude Design Artifact — 2026-03-08-production-hardening-focused-sweep

## Problem statement
The repository had mixed production-readiness gaps across server verification orchestration, DB test enforcement, logging privacy controls, migration discipline, and PR process controls. We needed a single focused sweep to make merge/release operations predictable and safer.

## Constraints
- Keep changes within existing architecture and package boundaries.
- Respect one-migration-per-PR guidance.
- Preserve compatibility with existing service entrypoints while de-duplicating paths.
- Avoid introducing secrets/log PII leakage.
- Keep CI enforceable and reproducible.

## Proposed approach
1. Harden server verification orchestration with lease-style processing protection.
2. Add DB-level idempotency uniqueness constraints where reward distribution duplicates are high risk.
3. Enforce DB integration tests in CI and block hard-coded skip markers for DB-tagged test suites.
4. Standardize log redaction policy in shared core logging and propagate to app/server sinks.
5. Document and enforce PR/CI/release process via playbooks, runbooks, and PR template checks.

## Rejected alternatives
- **Leave verification concurrency to application-level timing only**: rejected due duplicate processing risk.
- **Only document DB-test expectations without CI enforcement**: rejected because drift had already happened.
- **Local package-only logging rules**: rejected because policy needed one shared source of truth.

## File-level change plan
- `verily_server/lib/src/services/verification/submission_verification_orchestrator.dart`
- `verily_server/lib/src/models/reward_distribution.spy.yaml`
- `verily_server/migrations/**`
- `verily_server/test/integration/test_tools/assert_no_db_skip.dart`
- `verily_server/test/services/*_test.dart`
- `verily_core/lib/src/logging/*`
- `verily_app/lib/src/logging/*`
- `.github/workflows/ci.yml`
- `docs/pr-ci-runbook.md`, `docs/pr-execution-playbook.md`, `docs/pre-pr-gate-matrix.md`
- `.github/pull_request_template.md`

## Risk checklist
- Migration apply risk on environments with pre-existing duplicates.
- Potential false positives in DB skip guard regex.
- Logging sink behavior differences between debug/release environments.
- PR process strictness creating contributor friction if docs are unclear.

## Definition of done
- Verification orchestration is lease-protected.
- Reward distribution uniqueness enforced in schema + migration.
- DB-tagged tests are CI-enforced and not hard-skipped.
- Shared redaction policy is wired for app/server logging.
- PR docs/template include explicit runbook and merge-readiness requirements.
