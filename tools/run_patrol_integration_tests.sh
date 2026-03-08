#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
APP_DIR="$ROOT_DIR/verily_app"
PATROL_BIN="${PATROL_BIN:-$HOME/.pub-cache/bin/patrol}"

CAPTURE_UI_SCREENSHOTS="${CAPTURE_UI_SCREENSHOTS:-true}"
TIMESTAMP="$(date +%Y%m%d_%H%M%S)"
DEFAULT_SCREENSHOT_DIR="$ROOT_DIR/artifacts/screenshots/patrol_${TIMESTAMP}"
PATROL_SCREENSHOT_DIR="${PATROL_SCREENSHOT_DIR:-$DEFAULT_SCREENSHOT_DIR}"

pick_simulator_id() {
	local simulator_name="$1"
	printf '%s\n' "$SIMULATOR_LIST_OUTPUT" |
		rg "${simulator_name} \\(" -m1 |
		sed -E 's/.*\(([A-F0-9-]{36})\).*/\1/'
}

SIMULATOR_LIST_OUTPUT="$(xcrun simctl list devices available 2>&1 || true)"
if printf '%s\n' "$SIMULATOR_LIST_OUTPUT" | rg -q "Xcode license agreements"; then
	echo "Xcode license is not accepted for this environment." >&2
	echo "Run 'sudo xcodebuild -license' once on the machine, then re-run." >&2
	exit 1
fi

DEVICE_ID="${PATROL_DEVICE_ID:-}"
if [[ -z "$DEVICE_ID" ]]; then
	DEVICE_ID="$(pick_simulator_id "iPhone 17" || true)"
fi
if [[ -z "$DEVICE_ID" ]]; then
	DEVICE_ID="$(pick_simulator_id "iPhone 16" || true)"
fi
if [[ -z "$DEVICE_ID" ]]; then
	echo "No iPhone simulator found. Please boot/install a simulator runtime first." >&2
	exit 1
fi

if [[ ! -x "$PATROL_BIN" ]]; then
	echo "Patrol CLI not found at $PATROL_BIN" >&2
	echo "Install with: dart pub global activate patrol_cli 3.11.0" >&2
	exit 1
fi

echo "Using simulator: $DEVICE_ID"
echo "Screenshots dir: $PATROL_SCREENSHOT_DIR"
mkdir -p "$PATROL_SCREENSHOT_DIR"

xcrun simctl boot "$DEVICE_ID" >/dev/null 2>&1 || true
xcrun simctl bootstatus "$DEVICE_ID" -b >/dev/null 2>&1 || true

pushd "$APP_DIR" >/dev/null
unset LD CC CXX

targets=(
	"integration_test/auth_patrol_test.dart"
	"integration_test/home_verification_patrol_test.dart"
)

for target in "${targets[@]}"; do
	echo "RUN $target"
	PATROL_SCREENSHOT_DIR="$PATROL_SCREENSHOT_DIR" \
		"$PATROL_BIN" test \
		-t "$target" \
		-d "$DEVICE_ID" \
		--dart-define="CAPTURE_UI_SCREENSHOTS=${CAPTURE_UI_SCREENSHOTS}"
done

popd >/dev/null

echo "Patrol run completed."
echo "If screenshots were captured by platform plugins, files are in:"
echo "  $PATROL_SCREENSHOT_DIR"
