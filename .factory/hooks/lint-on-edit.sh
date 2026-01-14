#!/bin/bash

# Shared lint-on-edit hook for Claude Code and Factory Droid
# Runs linting after file edits - INFORMATIONAL ONLY (never blocks)
#
# Exit codes:
#   0 = always (lint issues reported but never block edits)
#
# Supported linters:
#   - ESLint (JS/TS)
#   - ruff (Python)
#   - golangci-lint (Go)

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

# Skip non-source files
[[ "$FILE_PATH" == *.md ]] && exit 0
[[ "$FILE_PATH" == *.json ]] && exit 0
[[ "$FILE_PATH" == *.yaml ]] && exit 0
[[ "$FILE_PATH" == *.yml ]] && exit 0
[[ "$FILE_PATH" == *.lock ]] && exit 0

cd "$PROJECT_DIR" 2>/dev/null || exit 0

# Get relative path and extension
REL_PATH="${FILE_PATH#$PROJECT_DIR/}"
EXT="${FILE_PATH##*.}"

# Timeout for linting (15 seconds - should be fast)
TIMEOUT_SEC=15

run_with_timeout() {
    if command -v timeout >/dev/null 2>&1; then
        timeout "$TIMEOUT_SEC" "$@"
    elif command -v gtimeout >/dev/null 2>&1; then
        gtimeout "$TIMEOUT_SEC" "$@"
    else
        "$@"
    fi
}

LINT_OUTPUT=""
LINT_RAN=false

# JavaScript/TypeScript: ESLint
case "$EXT" in
    js|jsx|ts|tsx|mjs|cjs)
        if [ -f "package.json" ]; then
            # Check for ESLint config
            if [ -f ".eslintrc" ] || [ -f ".eslintrc.js" ] || [ -f ".eslintrc.json" ] || [ -f ".eslintrc.yaml" ] || [ -f "eslint.config.js" ] || [ -f "eslint.config.mjs" ] || grep -q '"eslintConfig"' package.json 2>/dev/null; then
                LINT_RAN=true

                # Detect package manager
                if [ -f "pnpm-lock.yaml" ]; then
                    PM="pnpm"
                elif [ -f "yarn.lock" ]; then
                    PM="yarn"
                else
                    PM="npx"
                fi

                LINT_OUTPUT=$(run_with_timeout $PM eslint "$FILE_PATH" --format compact 2>&1) || true
            fi
        fi
        ;;
esac

# Python: ruff or pylint
case "$EXT" in
    py)
        LINT_RAN=true

        if command -v ruff >/dev/null 2>&1; then
            LINT_OUTPUT=$(run_with_timeout ruff check "$FILE_PATH" 2>&1) || true
        elif command -v pylint >/dev/null 2>&1; then
            LINT_OUTPUT=$(run_with_timeout pylint "$FILE_PATH" --output-format=text --score=no 2>&1) || true
        elif command -v flake8 >/dev/null 2>&1; then
            LINT_OUTPUT=$(run_with_timeout flake8 "$FILE_PATH" 2>&1) || true
        fi
        ;;
esac

# Go: golangci-lint or go vet
case "$EXT" in
    go)
        if [ -f "go.mod" ]; then
            LINT_RAN=true

            if command -v golangci-lint >/dev/null 2>&1; then
                PKG_DIR=$(dirname "$FILE_PATH")
                LINT_OUTPUT=$(run_with_timeout golangci-lint run "$PKG_DIR" 2>&1) || true
            elif command -v go >/dev/null 2>&1; then
                LINT_OUTPUT=$(run_with_timeout go vet "$FILE_PATH" 2>&1) || true
            fi
        fi
        ;;
esac

# Report lint issues (informational only)
if [ "$LINT_RAN" = true ] && [ -n "$LINT_OUTPUT" ]; then
    # Check if there are actual issues (not just info messages)
    if echo "$LINT_OUTPUT" | grep -qiE "(error|warning|:.*:)"; then
        echo "⚠️  Lint issues in $REL_PATH (non-blocking):"
        echo "$LINT_OUTPUT" | head -15
    fi
fi

# Always exit 0 - this hook is informational, not blocking
exit 0
