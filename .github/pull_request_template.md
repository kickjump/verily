## Summary

-

## Plan Alignment

- PLAN phase/item:
- Scope notes / deviations:

## LLM Handoff Evidence (required for ~1-hour production-impacting tasks)

- Claude design artifact: `docs/research/claude/<task-slug>.md` or `N/A`
- Gemini research artifact: `docs/research/gemini/<task-slug>.md` or `N/A`
- Codex implementation summary: plan → changed files

## Validation

- Analyze/lint/format:
- Tests:
  - Unit/provider:
  - Widget:
  - Integration:
  - Server (non-DB):
  - Server (DB-tagged):

## Screenshots

- Required for any UI/design change.
- Add image attachments (or public image links) for each changed screen/state.
- Capture guide: `docs/ui-screenshot-workflow.md`.

## Release & Data Gates

- Changeset: `<path>` or `N/A` (with reason)
- Migration count in PR: `0` or `1`
- Localization updates (ARB + usage): yes/no + notes

## Risk / Rollback

-

## Merge Readiness Checklist

- [ ] PR scope is focused and PLAN-aligned
- [ ] LLM artifacts linked (or explicitly N/A)
- [ ] `lint:all` passed
- [ ] `test:all` passed
- [ ] Server DB skip guard passed (`assert_no_db_skip.dart`)
- [ ] Screenshot evidence provided for UI/design changes
- [ ] Changeset added when release-impacting (or N/A justified)
- [ ] Migration count is `0` or `1`
- [ ] No secrets added
