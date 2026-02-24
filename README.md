# Verily

Real-world action verification platform. Users post actions with rewards, performers complete them and submit video proof, and Gemini 2.0 Flash AI verifies the video matches requirements.

## Architecture

Monorepo built with Flutter + Serverpod, following a Hooks-first composition pattern with Riverpod for state management and Freezed for immutable models.

```
verily_app/         Flutter application (iOS, Android, Web, macOS, Windows, Linux)
verily_server/      Serverpod backend (PostgreSQL + PostGIS + Redis)
verily_client/      Generated Serverpod client protocol
verily_core/        Shared Dart-only models and utilities
verily_ui/          Shared Flutter widgets and Material 3 theme
verily_lints/       Custom lint rules (no StatefulWidget, pinned deps)
verily_test_utils/  Shared test helpers (pumpApp)
```

### Dependency Graph

```
verily_app → verily_ui → verily_core
           → verily_client
           → verily_server (via Serverpod protocol)

verily_test_utils → verily_ui → verily_core

All packages → verily_lints (dev dependency)
```

## Tech Stack

| Layer    | Technology                                                              |
| -------- | ----------------------------------------------------------------------- |
| Frontend | Flutter (latest stable), Riverpod + Flutter Hooks, GoRouter, Material 3 |
| Backend  | Serverpod 3.3.1, PostgreSQL 16 + PostGIS, Redis                         |
| AI       | Gemini 2.0 Flash for video verification                                 |
| Code Gen | Freezed, Riverpod Generator, Serverpod Generate                         |
| CI/CD    | GitHub Actions, devenv (Nix), dprint, Knope                             |
| Testing  | Patrol (E2E), Flutter Test (widget), Dart Test (unit)                   |

## Prerequisites

- [devenv](https://devenv.sh/) (installs Nix, FVM, Flutter, Postgres, Redis automatically)
- [FVM](https://fvm.app/) (managed by devenv)
- macOS, Linux, or WSL2

## Getting Started

```bash
# Clone the repository
git clone git@github.com:kickjump/verily.git
cd verily

# Start the development environment (installs everything)
direnv allow   # or: eval "$(devenv direnvrc)" && use devenv

# Install dependencies
install:all

# Start database and Redis
devenv up

# Run Serverpod code generation (in a separate terminal)
runner:serverpod

# Run build_runner for Freezed/Riverpod
runner:build

# Start the server
server:start

# Run the Flutter app
flutter:app run -d chrome
```

## Key Commands

### Development

```bash
devenv up              # Start Postgres (PostGIS) + Redis
server:start           # Start Serverpod dev server on port 8080
flutter:app run        # Run the Flutter app
```

### Code Generation

```bash
runner:serverpod       # Serverpod protocol + endpoint generation
runner:build           # build_runner (Freezed, Riverpod, JSON)
runner:watch           # build_runner in watch mode
```

### Code Quality

```bash
lint:all               # Run format check + dart analyze
lint:format            # Check formatting (dprint)
lint:analyze           # Run dart analyze --fatal-infos
fix:format             # Auto-fix formatting
```

### Testing

```bash
test:all               # Run all tests (Flutter + Dart)
test:flutter           # Run Flutter widget tests
test:integration       # Run Patrol E2E tests
```

### Package Management

```bash
install:all            # Install eget binaries + dart dependencies
install:dart           # flutter pub get (workspace)
install:eget           # Install knope via eget
update:deps            # Update devenv + flutter pub upgrade
clean:all              # Clean all Flutter packages
```

### Versioning & Releases

```bash
knope document-change  # Create a changeset file
knope release          # Prepare release (bump versions, changelog, tag)
```

## Project Features

### Core Verification Flow

1. **Create Action** — Define what needs to be done, verification criteria, optional location
2. **Record Video** — Capture video proof with GPS and device metadata
3. **AI Verification** — Gemini 2.0 Flash analyzes video against criteria
4. **Earn Rewards** — Receive badges and points for verified actions

### Action Types

- **One-Off** — Single action completed in one step
- **Sequential** — Multi-step action completed over time (e.g., 7-day challenge)

### Built-in Seed Actions

1. Do 10 Press-ups (one-off, 100 pts)
2. 7-Day Press-up Challenge (sequential, 7 steps, 500 pts)
3. Star Jump Champion (one-off, 100 pts)
4. Say Hello to 3 Strangers (one-off, 150 pts)

### Authentication

- Email/password (Serverpod Auth IDP)
- Google Sign-In
- Apple Sign-In
- X (Twitter) and Facebook — coming soon

### Anti-Spoofing (MVP)

- Device metadata capture (live camera confirmation)
- GPS verification against action location
- Gemini forensic analysis (screen recording artifacts, editing detection, perspective consistency)

## Configuration

### Serverpod Passwords

Create `verily_server/config/passwords.yaml` (gitignored):

```yaml
development:
  database: "changeme"
  redis: "changeme"
  serviceSecret: "your-secret"
  emailSecretHashPepper: "your-pepper"
  jwtHmacSha512PrivateKey: "your-jwt-key-at-least-32-chars"
  jwtRefreshTokenHashPepper: "your-refresh-pepper"
  # Optional: geminiApiKey: 'your-gemini-api-key'
```

### Gemini API (Optional)

See [docs/gemini-setup.md](docs/gemini-setup.md) for setup instructions. The app works without a Gemini API key — verification will return "service unavailable".

### Docker Compose (Alternative to devenv)

```bash
docker compose up -d        # Start Postgres (PostGIS) + Redis
docker compose down          # Stop services
```

## Coding Conventions

- **No StatefulWidget or StatelessWidget** — Use `HookConsumerWidget` (with Riverpod) or `HookWidget`
- **Riverpod annotations** — All providers use `@riverpod` / `@Riverpod(keepAlive: true)`
- **Freezed models** — All state objects and DTOs use `@freezed`
- **Pinned dependencies** — `verily_app/pubspec.yaml` uses exact versions (no `^`)
- **Localization** — All user-visible strings in ARB files
- **Conventional commits** — `feat:`, `fix:`, `chore:`, `docs:`, `ci:`, `test:`, `refactor:`
- **One migration per PR** — Run `serverpod create-migration` once after all model changes

## Documentation

- [Gemini API Setup](docs/gemini-setup.md)
- [X/Facebook Auth Setup](docs/auth-x-facebook-setup.md)
- [Anti-Spoofing Roadmap](docs/anti-spoofing-roadmap.md)

## License

All rights reserved.
