# Verily — AI Assistant Context

## Project Overview

Verily is a two-sided marketplace for real-world action verification. Users post actions with rewards; performers complete them and submit video proof; Gemini 2.0 Flash AI verifies the video matches requirements. Built with Flutter and Serverpod, targeting iOS, Android, Web, macOS, Windows, and Linux.

## Repository Structure

| Package             | Type             | Description                                                 |
| ------------------- | ---------------- | ----------------------------------------------------------- |
| `verily_app`        | Flutter app      | Main application entry point                                |
| `verily_server`     | Serverpod server | Backend API and business logic                              |
| `verily_client`     | Dart package     | Generated Serverpod client protocol                         |
| `verily_core`       | Dart package     | Shared models, constants, utilities (no Flutter dependency) |
| `verily_ui`         | Flutter package  | Shared widgets, theme, design tokens                        |
| `verily_lints`      | Dart package     | Centralized lint rules (all packages depend on this)        |
| `verily_test_utils` | Flutter package  | Shared test helpers (`pumpApp`, etc.)                       |

## Dependency Graph

```
verily_app → verily_ui → verily_core
           → verily_client
           → verily_server (via Serverpod protocol)

verily_test_utils → verily_ui → verily_core

All packages → verily_lints (dev dependency)
```

## Key Commands

```bash
# Development environment (requires devenv)
devenv up                    # Start postgres (PostGIS) + redis

# Package management
dart pub get                 # Resolve workspace dependencies
melos run analyze            # Run dart analyze across all packages

# Code quality
lint:all                     # Run all lints (format + analyze)
lint:format                  # Check formatting with dprint
lint:analyze                 # Run dart analyze
dprint fmt                   # Fix non-Dart formatting

# Code generation
melos run generate           # Run build_runner in all packages
melos run generate:watch     # Run build_runner in watch mode
melos run serverpod:generate # Run Serverpod code generation

# Server
server:start                 # Start Serverpod dev server (devenv script)

# Testing
test:all                     # Run all tests
test:flutter                 # Run Flutter tests only
test:integration             # Run Patrol integration tests

# Versioning
knope document-change        # Create a changeset file
```

## Architecture Decisions

- **State management**: Riverpod + Flutter Hooks. No `setState` outside trivial leaf widgets.
- **Provider pattern**: repository → service → provider → UI
- **Immutability**: State is immutable; mutations produce new state objects via Freezed.
- **Code generation**: Serverpod, Riverpod, Freezed. Generated code (`*.g.dart`, `*.freezed.dart`) MUST be committed.
- **Cloud-first**: All data lives on Serverpod backend. No offline-first layer.
- **Video verification**: Gemini 2.0 Flash AI analyzes submitted video proof.

## Coding Conventions

### Hooks-First Composition — No StatefulWidget, No StatelessWidget

**Absolutely no `StatefulWidget` or `StatelessWidget` anywhere in the codebase.** This rule has zero exceptions.

- Widgets that need Riverpod: use `HookConsumerWidget`
- Widgets that don't need Riverpod: use `HookWidget`
- All reusable stateful logic MUST be extracted into custom hooks (`use*` functions)
- Use `useTextEditingController`, `useState`, `useEffect`, `useAnimationController`, `useMemoized`, etc.
- CI enforces this via a custom lint rule that fails on any `extends StatefulWidget` or `extends StatelessWidget`

### Provider Pattern

All providers MUST use `riverpod_annotation` (`@riverpod`). No manual `StateNotifierProvider` or `ChangeNotifierProvider`. The generated provider name follows the pattern: class `FooNotifier` → `fooProvider`, function `bar` → `barProvider`.

### Freezed Models

All state objects and DTOs MUST use `@freezed`. Use sealed class union types for states (e.g., `AuthState.authenticated`, `AuthState.unauthenticated`, `AuthState.loading`).

### Localization (i18n)

All user-visible strings MUST come from `AppLocalizations`. No hardcoded strings in widgets. ARB files live in `verily_app/lib/l10n/`. Generated code outputs to `verily_app/lib/l10n/generated/`.

### Testing Discipline

The project follows a full testing pyramid:

- **Unit tests**: Every provider and utility function. Located in `test/` mirroring `lib/` structure.
- **Widget tests**: Every screen. Located in `test/`, uses `pumpApp` from `verily_test_utils`.
- **E2E / Integration tests**: Every major feature flow. Located in `integration_test/`, uses Patrol.

### Navigation

Use `GoRouter` for all navigation. Routes are defined in `app_router.dart` with `@riverpod`. Route constants live in `route_names.dart`. Auth redirects are handled in the router's `redirect` callback.

## Version Management & Releases

### Changeset Workflow (Knope)

The project uses [knope](https://knope.tech) for **changeset-only** version management. Conventional commits do **not** trigger version bumps — only explicit changeset files do.

### Pinned App Dependencies

`verily_app/pubspec.yaml` must use **exact versions** for all external dependencies (no `^`, `>=`, or `~` ranges). Exceptions: `intl: any` (Flutter SDK peer), path deps, and SDK deps. CI enforces this via a custom lint rule.

## Commit Conventions

### Conventional Commits (Mandatory)

- Format: `<type>: <description>`
- Types: `feat`, `fix`, `chore`, `docs`, `ci`, `test`, `refactor`
- Code/file references wrapped in backticks
- Generated code changes go in dedicated commits
- All warnings treated as errors in CI

### No Secrets (Hard Rule)

- `**/config/passwords.yaml` gitignored for Serverpod secrets
- `.env` gitignored for Docker Compose credentials
- CI runs Gitleaks secrets scan on every push and PR
- If a secret is accidentally committed, rotate immediately

### Database Migrations (Minimize)

- Each PR/feature MUST produce at most **one** Serverpod migration.
- Never create incremental migrations for iterative tweaks within the same branch.

## Tech Stack

- **Flutter** (latest stable) — all platforms
- **Serverpod** 3.3.1 — backend with PostgreSQL + PostGIS
- **Riverpod** + **Flutter Hooks** — state management
- **Freezed** — immutable models
- **Gemini 2.0 Flash** — video verification AI
- **Devenv** — reproducible dev environment
- **GoRouter** — declarative routing with auth redirects
- **Melos** 7.x — monorepo tooling (config in root `pubspec.yaml`)
- **Patrol** — E2E integration testing
- **dprint** — non-Dart formatting
- **Knope** — changeset-based version management
- **PostGIS** — spatial queries for location-based actions

## Expanded Marketplace Features

### Solana Integration

- Reward pools can be funded with SOL, SPL tokens, or NFTs
- Users can create custodial wallets or link external Solana wallets
- `SolanaService` handles wallet management and reward distribution
- `SolanaEndpoint` exposes wallet CRUD and balance queries
- Uses `solana_kit` Dart SDK from `github.com/openbudgetfun/solana_kit`
- Server stores only public keys; private key management via KMS in production

### AI Action Creation

- `AiActionService` uses Gemini to generate structured actions from natural language
- Text input → title, description, type, verification criteria, category, location
- Also generates step breakdowns for sequential actions
- `AiActionEndpoint` exposes generate, generateCriteria, generateSteps

### Reward Pools

- `RewardPool` model tracks funded reward pools on actions
- Supports SOL, SPL token, NFT, and points reward types
- Per-person distribution with 5% platform fee
- Time-limited pools with automatic expiration
- `RewardPoolService` manages lifecycle (create, distribute, cancel, expire)
- `RewardPoolEndpoint` exposes CRUD and distribution queries

### Device Attestation

- `AttestationChallenge` generates visual nonces for video recording
- Nonces displayed as overlay, verified by Gemini in video
- Play Integrity (Android) and App Attest (iOS) verification stubs
- `AttestationService` handles challenge creation and consumption
- `AttestationEndpoint` exposes createChallenge and submitAttestation

### New Server Models

- `SolanaWallet` — user wallet (custodial or external)
- `RewardPool` — funded reward pool on an action
- `RewardDistribution` — individual distribution record
- `AttestationChallenge` — video recording nonce
- `DeviceAttestation` — platform attestation record

### New App Screens

- `WalletScreen` — view balances, tokens, NFTs, activity
- `WalletSetupScreen` — onboarding wallet creation
- `CreateRewardPoolScreen` — fund an action with rewards
- `RewardPoolDetailScreen` — view pool status and distributions
