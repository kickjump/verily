# UI Screenshot Workflow

Use this workflow to avoid low-fidelity screenshots and keep UI PRs mergeable.

## Why Some Screenshots Look Bad

Low-fidelity screenshots usually come from `flutter test` rendering:

- test font fallback (Ahem-like blocks)
- no real platform text/layout rendering
- missing native plugin paths in test contexts

For production-looking screenshots, capture from a running iOS simulator app (`flutter run`) or from Patrol on a real simulator target.

Prerequisite: accept Xcode license once on the machine:

```bash
sudo xcodebuild -license
```

## High-Fidelity Manual Capture (Recommended)

### 1. Login screen (logged out preview)

```bash
devenv shell -- zsh -lc 'cd verily_app && unset LD CC CXX; flutter run -d DAD46780-818B-4E6E-A404-49364DF55325 --dart-define=FORCE_LOGGED_OUT_FOR_TESTS=true --route /login'
xcrun simctl io DAD46780-818B-4E6E-A404-49364DF55325 screenshot artifacts/screenshots/manual_run/login_live.png
```

### 2. Home feed (authenticated preview)

```bash
devenv shell -- zsh -lc 'cd verily_app && unset LD CC CXX; flutter run -d DAD46780-818B-4E6E-A404-49364DF55325 --dart-define=BYPASS_AUTH_FOR_TESTS=true --route /feed'
xcrun simctl io DAD46780-818B-4E6E-A404-49364DF55325 screenshot artifacts/screenshots/manual_run/feed_live.png
```

### 3. Verification capture

```bash
devenv shell -- zsh -lc 'cd verily_app && unset LD CC CXX; flutter run -d DAD46780-818B-4E6E-A404-49364DF55325 --dart-define=BYPASS_AUTH_FOR_TESTS=true --route /verify'
xcrun simctl io DAD46780-818B-4E6E-A404-49364DF55325 screenshot artifacts/screenshots/manual_run/verify_live.png
```

## Patrol Integration Runner

Use the helper script:

```bash
devenv shell -- ./tools/run_patrol_integration_tests.sh
```

It:

- boots a compatible simulator (`iPhone 17` first, then `iPhone 16`)
- unsets `LD/CC/CXX` to avoid Nix clang issues with `xcodebuild`
- runs:
  - `integration_test/auth_patrol_test.dart`
  - `integration_test/home_verification_patrol_test.dart`

Optional env vars:

- `PATROL_DEVICE_ID=<sim-udid>`
- `PATROL_SCREENSHOT_DIR=<abs-path>`
- `CAPTURE_UI_SCREENSHOTS=true|false`

## PR Requirement

For any UI/design change:

- include screenshots in PR description (image attachments or public links)
- keep a `Screenshots` section in the PR template populated

CI enforces this via `.github/workflows/ui-screenshot-policy.yml`.
