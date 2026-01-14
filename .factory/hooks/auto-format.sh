#!/bin/bash

# Shared auto-format hook that works with both Factory and Claude Code
# This script automatically formats files after they are edited/created

# Detect which project directory variable is available
if [ -n "$CLAUDE_PROJECT_DIR" ]; then
    PROJECT_DIR="$CLAUDE_PROJECT_DIR"
elif [ -n "$FACTORY_PROJECT_DIR" ]; then
    PROJECT_DIR="$FACTORY_PROJECT_DIR"
else
    exit 0  # No project directory, exit gracefully
fi

# Read JSON from stdin
INPUT=$(cat)

# Extract file path
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path' 2>/dev/null || echo "")

# If no file path, exit
if [ -z "$FILE_PATH" ]; then
    exit 0
fi

# Check if the file exists and is within the project directory
if [[ "$FILE_PATH" != "$PROJECT_DIR"* ]]; then
    exit 0
fi

# Get file extension
EXT="${FILE_PATH##*.}"

# Format based on file type
case "$EXT" in
    ts|tsx|js|jsx|json|css|scss|md)
        # For Node.js projects with prettier
        cd "$PROJECT_DIR" 2>/dev/null || exit 0
        if [ -f "package.json" ] && command -v npx >/dev/null 2>&1; then
            npx prettier --write "$FILE_PATH" 2>/dev/null || true
        fi
        ;;
    py)
        # For Python projects with ruff or black
        cd "$PROJECT_DIR" 2>/dev/null || exit 0

        # Use ruff if available
        if command -v ruff >/dev/null 2>&1; then
            ruff format "$FILE_PATH" 2>/dev/null || true
        # Fall back to black if available
        elif command -v black >/dev/null 2>&1; then
            black "$FILE_PATH" 2>/dev/null || true
        fi
        ;;
    go)
        # For Go projects
        if command -v gofmt >/dev/null 2>&1; then
            gofmt -w "$FILE_PATH" 2>/dev/null || true
        fi
        ;;
esac

exit 0
