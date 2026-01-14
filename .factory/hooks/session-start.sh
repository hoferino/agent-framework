#!/bin/bash
# Session Start Hook - Runs when a new session begins
# Compatible with Claude Code ($CLAUDE_PROJECT_DIR) and Factory Droid ($FACTORY_PROJECT_DIR)
# Design: Informational only, always exits 0

set -e

input=$(cat)
cwd=$(echo "$input" | jq -r '.cwd // empty')

# Determine project directory
PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$FACTORY_PROJECT_DIR}"
if [ -z "$PROJECT_DIR" ] && [ -n "$cwd" ]; then
  PROJECT_DIR="$cwd"
fi

if [ -z "$PROJECT_DIR" ]; then
  exit 0
fi

cd "$PROJECT_DIR"

# Git status
if [ -d ".git" ]; then
  branch=$(git branch --show-current 2>/dev/null || echo "detached")
  last_commit=$(git log -1 --format='%s' 2>/dev/null | head -c 50 || echo "no commits")
  echo "📍 $branch | $last_commit"

  changes=$(git status --short 2>/dev/null | wc -l | tr -d ' ')
  [ "$changes" -gt 0 ] && echo "   $changes uncommitted files"
fi

# Node.js dependency check
if [ -f "package.json" ] && [ ! -d "node_modules" ]; then
  echo "⚠️  node_modules missing: run 'npm install'"
fi

# Check for stale node_modules
if [ -f "package.json" ] && [ -d "node_modules" ] && [ "package.json" -nt "node_modules" ]; then
  echo "⚠️  package.json newer than node_modules: run 'npm install'"
fi

# Python venv check
if [ -f "requirements.txt" ] || [ -f "pyproject.toml" ]; then
  if [ ! -d "venv" ] && [ ! -d ".venv" ]; then
    echo "⚠️  Python venv missing: run 'python -m venv .venv'"
  fi
fi

# Go modules check
if [ -f "go.mod" ] && [ ! -d "vendor" ] && [ ! -f "go.sum" ]; then
  echo "⚠️  Go dependencies: run 'go mod download'"
fi

# Multi-service detection (monorepo-style)
for dir in */ ; do
  if [ -f "${dir}package.json" ] && [ ! -d "${dir}node_modules" ]; then
    echo "⚠️  ${dir%/}: run 'npm install'"
  fi
  if [ -f "${dir}requirements.txt" ] || [ -f "${dir}pyproject.toml" ]; then
    if [ ! -d "${dir}venv" ] && [ ! -d "${dir}.venv" ]; then
      echo "⚠️  ${dir%/}: missing Python venv"
    fi
  fi
done

exit 0
