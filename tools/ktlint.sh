#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -eq 0 ]; then
	exit 0
fi

# If ktlint is not installed, pass through unchanged.
if ! command -v ktlint >/dev/null 2>&1; then
	cat "$1"
	exit 0
fi

# Format a copy in the same directory so ktlint finds .editorconfig,
# then output the result to stdout for dprint exec.
FILE="$1"
DIR="$(dirname "$FILE")"
TMP="$DIR/.ktlint-tmp-$(basename "$FILE")"
cp "$FILE" "$TMP"
ktlint --format "$TMP" >/dev/null 2>&1 || true
cat "$TMP"
rm -f "$TMP"
