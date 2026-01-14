# Testing Rules

## Test Structure
- Use AAA pattern: Arrange, Act, Assert
- Keep tests focused on a single behavior
- Use descriptive test names that explain what is being tested

## Test Files
- Place test files alongside source files with `.test.ts` or `.spec.ts` extension
- Or in a `__tests__` directory adjacent to source files

## Coverage
- Write tests for new features
- Aim for high coverage of critical paths
- Test edge cases and error conditions

## Tooling
- Use `npm test` to run all tests
- Keep tests fast and reliable
- Avoid external dependencies in tests when possible
