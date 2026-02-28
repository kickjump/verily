#!/usr/bin/env bash
set -euo pipefail

# Wrapper for swift-format that works with dprint exec.
# Reads from stdin, writes formatted Swift to stdout.
# If swift-format is not installed, pass through unchanged.
if command -v swift-format >/dev/null 2>&1; then
	swift-format format 2>/dev/null
else
	cat
fi
