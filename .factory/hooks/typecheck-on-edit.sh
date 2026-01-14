#!/bin/bash

# Shared typecheck-on-edit hook for Claude Code and Factory Droid
# Runs type checking after file edits - INFORMATIONAL ONLY (never blocks)
#
# Exit codes:
#   0 = always (type errors reported but never block edits)
#
# Supported type checkers:
#   - TypeScript (tsc)
#   - Python (mypy, pyright)

set -o pipefail

# Detect project directory
if [ -n "$CLAUDE_PROJECT_DIR" ]; then
    PROJECT_DIR="$CLAUDE_PROJECT_DIR"
elif [ -n "$FACTORY_PROJECT_DIR" ]; then
    PROJECT_DIR="$FACTORY_PROJECT_DIR"
else
    exit 0
fi

# Read JSON input from stdin
INPUT=$(cat)

# Extract file path from tool input
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty' 2>/dev/null)

# Exit if no file path or file is outside project
[ -z "$FILE_PATH" ] && exit 0
[[ "$FILE_PATH" != "$PROJECT_DIR"* ]] && exit 0

cd "$PROJECT_DIR" 2>/dev/null || exit 0

# Get relative path and extension
REL_PATH="${FILE_PATH#$PROJECT_DIR/}"
EXT="${FILE_PATH##*.}"

# Timeout for type checking (20 seconds)
TIMEOUT_SEC=20

run_with_timeout() {
    if command -v timeout >/dev/null 2>&1; then
        timeout "$TIMEOUT_SEC" "$@"
    elif command -v gtimeout >/dev/null 2>&1; then
        gtimeout "$TIMEOUT_SEC" "$@"
    else
        "$@"
    fi
}

TYPE_OUTPUT=""
TYPE_RAN=false

# TypeScript: tsc --noEmit
case "$EXT" in
    ts|tsx)
        if [ -f "tsconfig.json" ]; then
            TYPE_RAN=true

            # Check for tsc
            if [ -f "package.json" ] && command -v npx >/dev/null 2>&1; then
                # Run tsc on the specific file if possible, or whole project
                TYPE_OUTPUT=$(run_with_timeout npx tsc --noEmit 2>&1) || true
            fi
        fi
        ;;
esac

# Python: mypy or pyright
case "$EXT" in
    py)
        # Only run if type checking is configured
        if [ -f "pyproject.toml" ] && grep -q "mypy\|pyright" pyproject.toml 2>/dev/null; then
            TYPE_RAN=true

            if command -v mypy >/dev/null 2>&1; then
                TYPE_OUTPUT=$(run_with_timeout mypy "$FILE_PATH" 2>&1) || true
            elif command -v pyright >/dev/null 2>&1; then
                TYPE_OUTPUT=$(run_with_timeout pyright "$FILE_PATH" 2>&1) || true
            fi
        fi
        ;;
esac

# Report type errors (informational only)
if [ "$TYPE_RAN" = true ] && [ -n "$TYPE_OUTPUT" ]; then
    # Check if there are actual errors
    if echo "$TYPE_OUTPUT" | grep -qiE "(error|TS[0-9]+)"; then
        echo "⚠️  Type errors detected (non-blocking):"
        echo "$TYPE_OUTPUT" | grep -E "(error|TS[0-9]+)" | head -10
    fi
fi

# Always exit 0 - this hook is informational, not blocking
exit 0
