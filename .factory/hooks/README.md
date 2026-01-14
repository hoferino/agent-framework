# Shared Hooks

This directory contains hook scripts that work with both Factory Droid and Claude Code.

## Design Philosophy

All hooks are **informational, not blocking**. They report issues but never prevent edits. This makes the framework safe to drop into existing codebases with failing tests or lint errors.

## Available Hooks

### 1. `auto-format.sh`
Automatically formats files after they are edited/created.

**Supported formatters:**
- TypeScript/JavaScript/CSS/Markdown: Prettier
- Python: ruff or black
- Go: gofmt

### 2. `lint-on-edit.sh`
Runs linting after files are edited. Reports issues but doesn't block.

**Supported linters:**
- JavaScript/TypeScript: ESLint
- Python: ruff, pylint, or flake8
- Go: golangci-lint or go vet

### 3. `typecheck-on-edit.sh`
Runs type checking after files are edited. Reports errors but doesn't block.

**Supported type checkers:**
- TypeScript: tsc --noEmit
- Python: mypy or pyright (if configured in pyproject.toml)

### 4. `test-on-edit.sh`
Runs related tests after files are edited. Reports failures but doesn't block.

**Supported test runners:**
- JavaScript/TypeScript: npm/yarn/pnpm test with Jest/Vitest
- Python: pytest
- Go: go test

### 5. `notification.sh`
Sends desktop notifications when waiting for user input.

**Supported platforms:**
- macOS: osascript
- Linux: notify-send

## Compatibility

These hooks detect which environment they're running in:
- `$CLAUDE_PROJECT_DIR` for Claude Code
- `$FACTORY_PROJECT_DIR` for Factory Droid

## Usage

### Claude Code (`.claude/settings.json`)
```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          { "type": "command", "command": "\"$CLAUDE_PROJECT_DIR\"/.factory/hooks/auto-format.sh" }
        ]
      },
      {
        "matcher": "Edit|Write",
        "hooks": [
          { "type": "command", "command": "\"$CLAUDE_PROJECT_DIR\"/.factory/hooks/lint-on-edit.sh" }
        ]
      },
      {
        "matcher": "Edit|Write",
        "hooks": [
          { "type": "command", "command": "\"$CLAUDE_PROJECT_DIR\"/.factory/hooks/typecheck-on-edit.sh" }
        ]
      },
      {
        "matcher": "Edit",
        "hooks": [
          { "type": "command", "command": "\"$CLAUDE_PROJECT_DIR\"/.factory/hooks/test-on-edit.sh" }
        ]
      }
    ],
    "Notification": [
      {
        "matcher": "",
        "hooks": [
          { "type": "command", "command": "\"$CLAUDE_PROJECT_DIR\"/.factory/hooks/notification.sh" }
        ]
      }
    ]
  }
}
```

### Factory Droid
Same structure but with `$FACTORY_PROJECT_DIR` instead.

## Hook Execution Order

When you edit a file, hooks run in this order:
1. `auto-format.sh` - Formats the file
2. `lint-on-edit.sh` - Checks for lint issues
3. `typecheck-on-edit.sh` - Checks for type errors
4. `test-on-edit.sh` - Runs related tests

All hooks run to completion regardless of previous results.

## Timeout Protection

All hooks have built-in timeouts to prevent blocking:
- Lint: 15 seconds
- Type check: 20 seconds
- Tests: 30 seconds

If a tool exceeds its timeout, the hook exits gracefully.

## Adding New Hooks

To add a new shared hook:

1. Create a script that:
   - Uses `#!/bin/bash` shebang
   - Reads JSON input from stdin
   - Detects `$CLAUDE_PROJECT_DIR` or `$FACTORY_PROJECT_DIR`
   - **Always exits 0** (informational only)

2. Make it executable:
   ```bash
   chmod +x /path/to/hook.sh
   ```

3. Add to `.claude/settings.json`
