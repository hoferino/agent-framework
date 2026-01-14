#!/bin/bash

# Shared test-on-edit hook for Claude Code and Factory Droid
# Runs related tests after file edits - INFORMATIONAL ONLY (never blocks)
#
# Exit codes:
#   0 = success (tests passed or no tests found)
#   0 = tests failed (we report but don't block - this is intentional)
#
# For existing codebases: This hook will warn about test failures but won't
# prevent edits. Fix failing tests when ready, not when forced.

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

# Skip test files themselves to avoid infinite loops
[[ "$FILE_PATH" == *.test.* ]] && exit 0
[[ "$FILE_PATH" == *.spec.* ]] && exit 0
[[ "$FILE_PATH" == *__tests__/* ]] && exit 0
[[ "$FILE_PATH" == *_test.go ]] && exit 0
[[ "$FILE_PATH" == *_test.py ]] && exit 0

cd "$PROJECT_DIR" 2>/dev/null || exit 0

# Get relative path for cleaner output
REL_PATH="${FILE_PATH#$PROJECT_DIR/}"

# Timeout for tests (30 seconds - fast feedback loop)
TIMEOUT_SEC=30

run_with_timeout() {
    if command -v timeout >/dev/null 2>&1; then
        timeout "$TIMEOUT_SEC" "$@"
    elif command -v gtimeout >/dev/null 2>&1; then
        gtimeout "$TIMEOUT_SEC" "$@"
    else
        "$@"
    fi
}

# Track if we ran any tests
TESTS_RAN=false
TEST_OUTPUT=""

# JavaScript/TypeScript: npm/yarn/pnpm with Jest/Vitest
if [ -f "package.json" ]; then
    # Detect package manager
    if [ -f "pnpm-lock.yaml" ]; then
        PM="pnpm"
    elif [ -f "yarn.lock" ]; then
        PM="yarn"
    else
        PM="npm"
    fi

    # Check for test script
    if grep -q '"test"' package.json 2>/dev/null; then
        TESTS_RAN=true

        # Try to find related tests only (faster)
        if grep -q "jest\|vitest" package.json 2>/dev/null; then
            TEST_OUTPUT=$(run_with_timeout $PM test -- --findRelatedTests "$FILE_PATH" --passWithNoTests 2>&1) || true
        else
            # Fallback: run all tests with bail
            TEST_OUTPUT=$(run_with_timeout $PM test -- --bail 2>&1) || true
        fi
    fi
fi

# Python: pytest
if [ -f "pyproject.toml" ] || [ -f "setup.py" ] || [ -f "pytest.ini" ] || [ -f "setup.cfg" ]; then
    if command -v pytest >/dev/null 2>&1; then
        TESTS_RAN=true

        # Find related test file
        TEST_FILE=""
        BASE_NAME=$(basename "$FILE_PATH" .py)
        DIR_NAME=$(dirname "$FILE_PATH")

        # Common test file patterns
        for pattern in "${DIR_NAME}/test_${BASE_NAME}.py" "${DIR_NAME}/${BASE_NAME}_test.py" "${DIR_NAME}/tests/test_${BASE_NAME}.py"; do
            if [ -f "$pattern" ]; then
                TEST_FILE="$pattern"
                break
            fi
        done

        if [ -n "$TEST_FILE" ]; then
            TEST_OUTPUT=$(run_with_timeout pytest "$TEST_FILE" -x 2>&1) || true
        fi
    fi
fi

# Go: go test
if [[ "$FILE_PATH" == *.go ]] && [ -f "go.mod" ]; then
    if command -v go >/dev/null 2>&1; then
        TESTS_RAN=true
        PKG_DIR=$(dirname "$FILE_PATH")
        TEST_OUTPUT=$(run_with_timeout go test -v "$PKG_DIR" 2>&1) || true
    fi
fi

# Report results (informational only)
if [ "$TESTS_RAN" = true ]; then
    if echo "$TEST_OUTPUT" | grep -qiE "(fail|error|panic)"; then
        echo "⚠️  Tests related to $REL_PATH may have issues (non-blocking)"
        echo "$TEST_OUTPUT" | tail -20
    fi
fi

# Always exit 0 - this hook is informational, not blocking
exit 0
