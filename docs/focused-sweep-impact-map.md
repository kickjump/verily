# Focused Sweep Impact Map

This document captures workspace ownership, dependency edges, and PR inclusion rules for making **focused-sweep** changes with minimal blast radius.

## Workspace Modules

Workspace members are defined in the root `pubspec.yaml`:

- `verily_app`
- `verily_client`
- `verily_server`
- `verily_core`
- `verily_ui`
- tooling packages (including test/lint helpers)

## Module Ownership (What Lives Where)

- **`verily_core`**: shared domain models/constants/logging used across app, client, server, and UI.
- **`verily_client`**: Serverpod protocol client and client-side service wrappers used by app features.
- **`verily_server`**: API endpoints, business services, and generated server/protocol bindings.
- **`verily_ui`**: shared design system (theme, widgets, reusable UI primitives).
- **`verily_app`**: product features, routing, state/providers, and end-user flows.
- **`verily_test_utils`**: shared testing utilities used by package tests.

## Dependency Graph (Direct Edges)

From package manifests:

- `verily_app` → `verily_client`, `verily_core`, `verily_ui`
- `verily_server` → `verily_core`
- `verily_ui` → `verily_core`
- `verily_test_utils` → `verily_core`, `verily_ui`

In practical terms:

- `verily_core` is the shared foundation.
- `verily_app` is the top-level consumer of client/UI/core.
- Server and UI each depend on core, but not on each other directly.

## Focused-Sweep PR Inclusion Rules

When deciding what to include in a PR, start with edited package(s), then include dependents when public surface/contract changes.

1. **Core model/constant/logging changes**\
   Include: `verily_core` + downstream consumers as needed (`verily_client`, `verily_server`, `verily_ui`, `verily_app`).

2. **Protocol/API contract changes**\
   Include: `verily_server` + `verily_client` (+ `verily_app` if app features/providers consume changed contracts).

3. **UI widget/theme changes**\
   Include: `verily_ui` + `verily_app` screens/tests that use changed components.

4. **Feature-only app flow changes**\
   Usually `verily_app` only, unless change touches shared types (`verily_core`) or client interfaces (`verily_client`).

5. **Server business logic change (no protocol change)**\
   Usually `verily_server` only (plus server tests).

## Test Coverage Expectations by Included Module

If a package is in scope, include/adjust tests in that package:

- `verily_app`: feature/widget/integration tests (`verily_app/test/**`, `verily_app/integration_test/**`)
- `verily_ui`: widget/theme tests (`verily_ui/test/**`)
- `verily_core`: unit tests (`verily_core/test/**`)
- `verily_server`: service/endpoint tests (`verily_server/test/**`)

## CI/PR Guardrails to Remember

- **UI changes require screenshot links in PR body** or the workflow fails.
- **Integration workflow expects discoverable tests** in `verily_app/integration_test`.
- **Releases are changeset-driven** (`knope`), not conventional-commit-driven.
- **Secret scanning (gitleaks)** runs in local/pre-push hooks.
