# TypeScript Rules

## Strict Mode
- Always use `strict: true` in `tsconfig.json`
- Enable `noUnusedLocals`, `noUnusedParameters`, `noImplicitReturns`, `noFallthroughCasesInSwitch`

## Type Safety
- Avoid `any` type - use `unknown` if type is truly unknown
- Use proper TypeScript interfaces and types for all function parameters and return values
- Prefer explicit return types for exported functions

## Code Patterns
- Use `type` for simple type aliases and unions
- Use `interface` for object shapes that can be extended
- Use `enum` for fixed sets of named constants

## Imports
- Use named imports where possible: `import { Component } from 'react'`
- Use default imports only when necessary: `import React from 'react'`

# TypeScript Conventions

## General
- Use `interface` for object types, `type` for unions/intersections
- Avoid `any` - use `unknown` with type guards instead
- Export types alongside their implementations

## React Components
- Use functional components with TypeScript FC type
- Props interfaces should be named `{ComponentName}Props`
- Use `React.ReactNode` for children, not `React.ReactChild`

## Imports
- Group imports: React, external libs, internal modules, types
- Use absolute imports from `@/` prefix
- Avoid barrel files (index.ts re-exports) for performance
