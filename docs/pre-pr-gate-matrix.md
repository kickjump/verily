# Pre-PR Gate Matrix

Source documents: `AGENTS.md`, `CLAUDE.md`, `PLAN.md`, `docs/llm-provider-strategy.md`, `docs/pr-execution-playbook.md`

Use this matrix before opening or marking any PR as review-ready.

For an end-to-end execution flow (branching, implementation guardrails, validation sequence, PR template), see `docs/pr-execution-playbook.md`.

## Gate Matrix

| Gate     | Requirement                                                                                                                                                                                  | Source of truth                                                                                                                     | Evidence required in PR                                                                                                                                        | Pass criteria                                                                                       |
| -------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------- |
| LLM-1    | For ~1-hour production-impacting tasks, complete mandatory artifact chain in sequence: Claude design → Gemini research → Codex implementation evidence.                                      | `AGENTS.md` (LLM Provider Strategy / Mandatory Workflow), `CLAUDE.md` (same), `PLAN.md` (LLM gate), `docs/llm-provider-strategy.md` | Links to `docs/research/claude/<task-slug>.md` and `docs/research/gemini/<task-slug>.md`; implementation summary and verification output in PR body/checklist. | All 3 artifacts exist, sequence respected, and checklist items are complete.                        |
| LLM-2    | Claude artifact must include: problem, constraints, approach, alternatives, file plan, risks, definition of done.                                                                            | `AGENTS.md`, `CLAUDE.md`, `docs/llm-provider-strategy.md`                                                                           | Direct link to Claude artifact with required headings/content.                                                                                                 | No required section missing.                                                                        |
| LLM-3    | Gemini artifact must include: model recommendation, prompting/output contract, grounding/tool-use notes (if applicable), safety/reliability, latency/cost, deprecations/migration watchouts. | `AGENTS.md`, `CLAUDE.md`, `docs/llm-provider-strategy.md`                                                                           | Direct link to Gemini artifact with required sections.                                                                                                         | No required section missing; recommendations are task-relevant.                                     |
| REL-1    | Version bumps are changeset-only via Knope. Conventional commits do not trigger release versions.                                                                                            | `AGENTS.md`, `CLAUDE.md` (Changeset Workflow)                                                                                       | Link/path to new changeset file and/or explicit rationale if no release-impacting change.                                                                      | `knope document-change` used when version-impacting; no PR relies on commit message for versioning. |
| COMMIT-1 | Commit message format is mandatory conventional commits: `<type>: <description>` with allowed types (`feat`, `fix`, `chore`, `docs`, `ci`, `test`, `refactor`).                              | `AGENTS.md`, `CLAUDE.md`                                                                                                            | Commit history in PR.                                                                                                                                          | All commits match required format and allowed types.                                                |
| COMMIT-2 | Generated code must be committed in dedicated commits when applicable; warnings treated as CI-breaking.                                                                                      | `AGENTS.md`, `CLAUDE.md`                                                                                                            | Commit separation visible; CI results attached/passing.                                                                                                        | Generated artifacts present and isolated; no warnings ignored.                                      |
| DB-1     | Database migrations must be minimized: at most one Serverpod migration per PR/feature branch.                                                                                                | `AGENTS.md`, `CLAUDE.md`                                                                                                            | Migration file diff and count in PR description.                                                                                                               | Migration count ≤ 1 for the PR scope.                                                               |
| I18N-1   | All user-visible strings must come from `AppLocalizations`; no hardcoded UI strings.                                                                                                         | `AGENTS.md`, `CLAUDE.md` (Localization)                                                                                             | Diff references to ARB and generated localization usage where relevant.                                                                                        | New/changed UI text is localized.                                                                   |
| TEST-1   | Apply testing pyramid for changed behavior: unit/provider/util tests, widget tests for screens, integration tests for major flows.                                                           | `AGENTS.md`, `CLAUDE.md` (Testing Discipline)                                                                                       | Commands + output for relevant scope (`test:all`, targeted tests, etc.).                                                                                       | Required test levels for changed scope are present and passing.                                     |
| CI-1     | Run required verification commands appropriate to scope before review.                                                                                                                       | `AGENTS.md`, `CLAUDE.md`, `docs/llm-provider-strategy.md`                                                                           | PR includes executed commands and pass/fail output (e.g., `melos run analyze`, `test:all`, formatting/lint).                                                   | Relevant checks reported and passing (or explicitly justified exceptions).                          |
| PLAN-1   | Work should align with current MVP phase priorities and gate in `PLAN.md`.                                                                                                                   | `PLAN.md`                                                                                                                           | PR notes reference targeted phase/task and any deviations.                                                                                                     | Scope matches plan or deviation is explicitly documented.                                           |

## Quick Pre-PR Checklist

- [ ] In-scope task confirmed as ~1-hour production-impacting (if yes, LLM artifact chain is mandatory).
- [ ] Claude artifact created and linked.
- [ ] Gemini artifact created and linked.
- [ ] Codex implementation summary maps plan → changed files.
- [ ] Verification evidence included (analyze/test/lint/format as relevant).
- [ ] Changeset added when release-impacting.
- [ ] Commit messages follow required conventional format.
- [ ] Migration count validated (0 or 1).
- [ ] Localization verified for all new UI strings.
- [ ] Tests added/updated at required pyramid levels.
- [ ] PLAN phase alignment documented.

## Suggested PR Description Snippet

```md
## Pre-PR Gate Matrix Evidence

- LLM artifacts:
  - Claude: docs/research/claude/<task-slug>.md
  - Gemini: docs/research/gemini/<task-slug>.md
- Plan alignment: <PLAN phase + item>
- Changeset: <path or N/A + reason>
- Migration count: <0|1>
- Localization: <ARB/usage evidence>
- Verification:
  - melos run analyze: <pass/fail>
  - test:all (or scoped tests): <pass/fail>
  - lint/format: <pass/fail>
```
