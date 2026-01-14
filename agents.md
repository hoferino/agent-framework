# Project Guidelines

## Commands

### Build & Test
- Build: `npm run build`
- Test all: `npm test`
- **Test single file: `npm test -- path/to/file.test.ts`** (use this!)
- Test pattern: `npm test -- --testPathPattern=auth`
- Lint: `npm run lint`
- Lint fix: `npm run lint:fix`
- Type check: `npm run typecheck`

### Validation (run before commit)
```bash
npm run validate   # lint + typecheck + test
```

## Code Style
- Use TypeScript strict mode
- Prefer functional components in React
- Write tests for new features

## Coding Standards
Follow the conventions documented in:
- `.factory/rules/typescript.md` - TypeScript and React patterns
- `.factory/rules/testing.md` - Test patterns
- `.factory/rules/security.md` - Security guidelines

## Project Memory
Architecture decisions, domain knowledge, and project history are documented in `.factory/memories.md`.
Always check this file before making significant architectural or design decisions.

## Token Efficiency Tips
- Use single-file test command to verify changes quickly
- Reference this file for commands instead of exploring
- Check `.factory/memories.md` for architecture decisions
