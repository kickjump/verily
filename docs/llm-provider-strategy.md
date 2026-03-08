# LLM Provider Strategy for 1-Hour Production Tasks

This document defines the required multi-LLM workflow for production tasks that are scoped to **~1 hour**.

It is **mandatory** for tasks that involve architecture/design decisions, implementation changes, or model/provider guidance.

## Objective

Enforce a clear division of labor:

- **Claude**: design artifacts and execution decomposition
- **Codex**: implementation and verification
- **Gemini**: research notes focused on Google model best practices

This strategy reduces context drift, improves quality, and creates auditable PR evidence.

## Scope

Use this workflow when all of the following are true:

1. Estimated implementation time is about 1 hour.
2. The task can affect production behavior (app, server, shared packages, infra, CI, or docs with operational impact).
3. The task has any non-trivial uncertainty (design choices, API/SDK usage, AI/provider considerations, rollout risk).

If the task is <15 minutes and purely mechanical (e.g., typo fix), this workflow is optional.

## Required Artifacts (per task)

Every qualifying task must produce all three artifacts:

1. `docs/research/claude/<task-slug>.md`
   - Design brief, constraints, alternatives, and acceptance criteria
   - Explicitly names files expected to change
2. `docs/research/gemini/<task-slug>.md`
   - Google-model best-practice notes relevant to the task
   - Must include model/version guidance, prompting/grounding strategy, safety/reliability considerations, and cost/latency tradeoffs
3. PR implementation evidence by Codex
   - Completed code/docs changes
   - Verification output (`analyze`, `test`, format/lint as appropriate)

> Task slug format: `YYYY-MM-DD-short-kebab-name`

## Workflow (Mandatory Sequence)

### Step 1 — Claude (Design First)

Claude produces a design artifact before implementation starts.

Required sections in Claude artifact:

- Problem statement
- Constraints (product, architecture, security, timeline)
- Proposed approach
- Rejected alternatives
- File-level change plan
- Risk checklist
- Definition of done

### Step 2 — Gemini (Google Models Research)

Gemini produces focused research notes specifically for Google model usage in this task.

Required sections in Gemini artifact:

- Recommended model(s) and why (e.g., latest Gemini tier appropriate for workload)
- Prompt structure and output contract recommendations
- Grounding/tool-use recommendations (if applicable)
- Safety policy notes (prompt injection/data handling/content safety)
- Reliability/evaluation notes (hallucination controls, schema validation, retry patterns)
- Cost and latency guidance
- Migration/deprecation watchouts

### Step 3 — Codex (Implementation)

Codex executes implementation according to Claude design and Gemini research.

Required Codex responsibilities:

- Implement only scoped changes
- Keep a traceable mapping from design plan to changed files
- Run verification commands relevant to changed scope
- Capture outcomes in PR checklist

## PR Checklist Integration (Enforcement)

All PRs for in-scope tasks must include the checklist below and satisfy every item.

- [ ] **Claude Design Artifact Linked**: `docs/research/claude/<task-slug>.md`
- [ ] **Gemini Research Artifact Linked**: `docs/research/gemini/<task-slug>.md`
- [ ] **Codex Implementation Summary Added**: concise mapping of plan → changes
- [ ] **Verification Evidence Included**: commands + pass/fail output
- [ ] **Google Model Best Practices Applied**: explicit note referencing Gemini artifact
- [ ] **Risk/rollback notes included** (if production-impacting)

PRs missing any required item should be considered **not ready for review**.

## Minimum 1-Hour Task Template

Use this copy/paste template when opening work:

```md
Task slug: YYYY-MM-DD-short-kebab-name

## Claude Design

- artifact: docs/research/claude/<task-slug>.md
- status: pending|done

## Gemini Research (Google models)

- artifact: docs/research/gemini/<task-slug>.md
- status: pending|done

## Codex Implementation

- planned files:
- verification commands:
- status: pending|done
```

## Directory Conventions

- Claude outputs: `docs/research/claude/`
- Gemini outputs: `docs/research/gemini/`

Create directories if they do not exist.

## Review Policy

Reviewers should block PR approval if:

1. Artifacts are missing or low-quality boilerplate.
2. Gemini notes do not mention Google model best practices.
3. Implementation diverges from design without explanation.
4. Verification evidence is missing.

## Notes

- This process does **not** require each provider to write code.
- It enforces provider specialization and traceable handoffs.
- For larger efforts, apply this pattern per milestone slice rather than one giant artifact.
