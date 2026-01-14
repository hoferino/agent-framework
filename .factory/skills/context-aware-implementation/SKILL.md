---
name: context-aware-implementation
description: Implement features using project memory and conventions.
---

# Context-Aware Implementation

This skill ensures all implementations consider project memory, preferences, and rules before writing code.

## Implementation Process

### Step 1: Check Project Memory
Read `.factory/memories.md` to understand:

#### Decisions (Project)
- What architecture decisions apply to this feature?
- What technology choices were made?
- What trade-offs should I respect?
- Where are similar implementations located?

#### Context (Project)
- What domain knowledge applies?
- What entities and relationships exist?
- What external integrations are affected?
- What are the performance requirements?

#### Team Conventions
- What git workflow should I follow?
- What PR standards apply?
- What deployment considerations exist?

#### Known Technical Debt
- Are there related technical debt items?
- Should this implement a planned improvement?

### Step 2: Check Personal Preferences
Read `~/.factory/memories.md` to understand:

#### User Preferences
- What code style does the user prefer?
- What tools should I use or avoid?
- What approaches work well for this user?

#### User Patterns
- What file organization does the user like?
- What naming conventions does the user follow?
- What testing paradigms does the user prefer?

#### Past Issues
- What problems have occurred before?
- What solutions have worked?

### Step 3: Check Rules
Read rules from `.factory/rules/`:

#### File-Specific Rules
- TypeScript rules for `.ts`/`.tsx` files (`.factory/rules/typescript.md`)
- Testing rules for test files (`.factory/rules/testing.md`)
- Security rules for sensitive code (`.factory/rules/security.md`)

#### Code Style
- What strict mode settings apply?
- What patterns should I follow?
- What imports are preferred?
- What formatting is required?

#### Testing Requirements
- What test coverage is needed?
- What testing frameworks are used?
- When are tests mandatory?

### Step 4: Synthesize Context

Before writing code, summarize:

```markdown
## Implementation Context

### Architecture Decisions
[Decisions that apply]

### Constraints & Requirements
[Requirements and constraints]

### Patterns to Follow
[Specific patterns to use]

### Files to Reference
[Similar implementations]

### Testing Requirements
[Required tests]
```

### Step 5: Implement

Write code following all discovered context:

1. **Use established patterns** - Follow existing implementations
2. **Apply conventions** - Use the right imports, naming, structure
3. **Include tests** - Write tests matching project standards
4. **Document** - Add appropriate comments and documentation
5. **Format** - Ensure code follows style guidelines

### Step 6: Validate

Post-implementation checklist:

- [ ] Respects all architecture decisions
- [ ] Follows all established patterns
- [ ] Meets all code style rules
- [ ] Has appropriate test coverage
- [ ] Is properly formatted
- [ ] References similar implementations

## Context Detection

This skill automatically detects the environment to find correct paths:

- **Factory Droid**: Uses project root for rules and memories
- **Claude Code**: Uses `$CLAUDE_PROJECT_DIR` for project rules

## Example Usage

When asked to implement a feature:

```
User: Add a user authentication system

Response:
[Checks project memory]
[Checks personal preferences]
[Checks rules]

## Implementation Context

### Architecture Decisions
- Using NextAuth.js with custom credentials provider (2024-02-01)
- Integration with existing enterprise LDAP

### Constraints & Requirements
- Must support multi-tenant organizations
- Session timeout: 30 minutes

### Patterns to Follow
- Auth code in `src/lib/auth/`
- Components in `src/components/auth/`

### Files to Reference
- `src/lib/auth/ldap.ts` for LDAP integration
- `src/lib/auth/session.ts` for session management

### Testing Requirements
- Write unit tests for auth utilities
- Integration tests for login flow

[Proceeds with implementation following all context]
```

## Tips

1. **Always check context** - Don't skip the context gathering phase
2. **Ask if unclear** - If context is missing, ask the user
3. **Reference existing code** - Use similar implementations as templates
4. **Document decisions** - If deviating from patterns, explain why
5. **Update memory** - After implementing, consider updating `.factory/memories.md`
