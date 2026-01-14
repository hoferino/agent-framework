---
name: frontend-ui-integration
description: Implement or extend a user-facing workflow in a web application, integrating with existing backend APIs with emphasis on strong typing, accessibility, and distinctive design. Use when the feature is primarily a UI/UX change backed by existing APIs, affects only the web frontend, requires following design system and testing conventions, and needs to avoid generic AI-generated aesthetics.
---

# Skill: Frontend UI integration

## Purpose

Implement or extend a user-facing workflow in our primary web application, integrating with **existing backend APIs** while delivering **distinctive, well-designed interfaces** that avoid generic AI aesthetics. Follow our **design system, routing, and testing conventions** and apply strong design principles to create delightful user experiences.

## When to use this skill

- The feature is primarily a **UI/UX change** backed by one or more existing APIs.
- The backend contracts, auth model, and core business rules **already exist**.
- The change affects **only** the web frontend (no schema or service ownership changes).
- You need to **avoid generic, "AI slop" aesthetics** and create distinctive, contextually appropriate interfaces.
- The feature requires **accessibility-first implementation** with strong typing and comprehensive state handling.

## Inputs

- **Feature description**: short narrative of the user flow and outcomes.
- **Relevant APIs**: endpoints, request/response types, and links to source definitions.
- **Target routes/components**: paths, component names, or feature modules.
- **Design references**: Figma links or existing screens to mirror.
- **Guardrails**: performance limits, accessibility requirements, and any security constraints.
- **Aesthetic direction**: specific design intent (e.g., "editorial feel," "technical dashboard," "playful interface").

## Design Principles

To avoid generic AI-generated aesthetics, apply these design principles:

### Typography

- **Choose distinctive fonts**: Avoid generic fonts like Inter, Roboto, Arial, Open Sans, Lato, and default system fonts.
- **Consider context-appropriate choices**:
  - Code aesthetic: JetBrains Mono, Fira Code, Space Grotesk
  - Editorial: Playfair Display, Crimson Pro
  - Technical: IBM Plex family, Source Sans 3
  - Distinctive: Bricolage Grotesque, Newsreader
- **Pairing principle**: High contrast creates interest. Combine:
  - Display + monospace
  - Serif + geometric sans
  - Variable font across weights
- **Use weight extremes**: 100/200 vs 800/900 weights, not 400 vs 600
- **Create size hierarchy**: 3x+ size jumps, not 1.5x
- **Pick one distinctive font**: Use it decisively, not timidly

### Color & Theme

- **Commit to a cohesive aesthetic**: Don't dilute with multiple themes
- **Use CSS variables** for consistency and maintainability
- **Dominant colors with sharp accents** outperform timid, evenly-distributed palettes
- **Draw inspiration from**:
  - IDE themes (GitHub Dark, Nord, Dracula, etc.)
  - Cultural aesthetics and art movements
  - Brand-specific color theory
- **Avoid clichéd schemes**: Especially purple gradients on white backgrounds
- **Vary between light and dark themes**: Don't default to the same pattern

### Motion

- **Use animations for effects and micro-interactions**: Don't create static interfaces
- **Prioritize CSS-only solutions** for HTML to minimize dependencies
- **Use motion libraries** for React when available (e.g., Framer Motion, Motion library)
- **Focus on high-impact moments**:
  - One well-orchestrated page load with staggered reveals (animation-delay)
  - Creates more delight than scattered micro-interactions
- **Animate with purpose**: Guide attention, provide feedback, create delight—not just for decoration

### Backgrounds

- **Create atmosphere and depth**: Don't default to flat solid colors
- **Layer CSS gradients**: Use multiple gradients with different opacities
- **Use geometric patterns**: Grids, dots, waves for visual interest
- **Add contextual effects**: Match the overall aesthetic (e.g., noise overlays, blur effects)
- **Consider patterns**: Subtle textures, SVG patterns, or procedural backgrounds

### Avoiding Generic Patterns

**Never default to these AI-generated clichés**:
- Overused font families (Inter, Roboto,Arial, system fonts)
- Predictable layouts and component patterns
- Cookie-cutter design that lacks context-specific character
- Evenly distributed, safe color choices
- Minimal visual distinction between sections

**Instead**: Make creative, unexpected choices that feel genuinely designed for the context. Think outside the box and vary your approach—don't converge on common choices like Space Grotesk across projects.

## Out of scope

- Creating new backend services or changing persistent data models.
- Modifying authentication/authorization flows.
- Introducing new frontend frameworks or design systems.

## Conventions

- **Framework**: React with TypeScript.
- **Routing**: use the existing router and route layout patterns.
- **Styling**: use the in-house design system components (Buttons, Inputs, Modals, Toasts, etc.).
- **State management**: prefer the existing state libraries (e.g., React Query, Redux, Zustand) and follow established patterns.

## Required behavior

1. **Implement the UI changes with strong typing**: All props, API responses, and state must have proper TypeScript types.
2. **Apply design principles**: Use distinctive typography, cohesive color schemes, purposeful motion, and atmospheric backgrounds. Avoid generic AI aesthetics.
3. **Handle comprehensive states**: Implement loading, empty, error, and success states using existing primitives.
4. **Ensure keyboard accessibility and screen-reader support**:
   - Use semantic HTML elements (`<button>`, `<nav>`, `<main>`, `<section>`, etc.)
   - Include ARIA attributes where needed (`aria-label`, `aria-describedby`, `aria-expanded`, etc.)
   - Ensure keyboard navigation works (Tab, Enter, Space key interactions)
   - Provide focus indicators that are visible and understandable
   - Test with screen reader output in mind
5. **Respect feature flags and rollout mechanisms** where applicable.
6. **Load external fonts properly**: Use Google Fonts or CDN links in `index.html` or appropriate imports.

## Required artifacts

- Updated components and hooks in the appropriate feature module.
- **Unit tests** for core presentation logic.
- **Integration or component tests** for the new flow (e.g., React Testing Library, Cypress, Playwright) where the repo already uses them.
- Minimal **CHANGELOG or PR description text** summarizing the behavior change (to be placed in the PR, not this file).

## Implementation checklist

1. **Analyze design requirements**: Review Figma links, existing screens, and aesthetic direction to understand the design intent.
2. **Locate the feature module**: Find the relevant feature directory and existing components to understand the current structure.
3. **Confirm backend APIs and types**: Verify API contracts, request/response types, and update shared TypeScript types if needed.
4. **Design the visual approach**:
   - Select distinctive typography that matches the context
   - Define a cohesive color palette with dominant colors and sharp accents
   - Plan motion and animations for key interactions
   - Design backgrounds with depth and atmosphere
5. **Implement the UI**:
   - Create components with strong TypeScript typing
   - Apply design system components or custom designs following principles
   - Wire in API calls via the existing data layer
6. **Implement accessibility**:
   - Add ARIA attributes
   - Ensure keyboard navigation works
   - Test with screen readers in mind
7. **Handle all states**: Implement loading, empty, error, and success states properly.
8. **Add comprehensive tests**:
   - Unit tests for core presentation logic
   - Integration or component tests for the new flow
   - Accessibility tests using axe-core or similar
9. **Run validation commands**: Execute lint, tests, and typecheck to ensure quality.

## Verification

Run the following (adjust commands to match the project):

- `pnpm lint`
- `pnpm test -- --runInBand --watch=false`
- `pnpm typecheck` (if configured separately)
- Accessibility audits (e.g., `pnpa a11y` or manual testing with keyboard and screen reader)

The skill is complete when:

- All tests, linters, and type checks pass.
- Accessibility requirements are met (semantic HTML, ARIA attributes, keyboard navigation).
- Design principles are applied (distinctive typography, cohesive colors, purposeful motion, atmospheric backgrounds).
- No generic AI aesthetics are present.
- The new UI behaves as specified across normal, error, and boundary cases.
- No unrelated files or modules are modified.

## Safety and escalation

- If the requested change requires **backend contract changes**, **stop** and request a backend-focused task instead.
- If design references conflict with **accessibility standards**, favor accessibility and highlight the discrepancy in the PR description.
- If aesthetic requirements conflict with existing **design system constraints**, work within the design system and document the trade-offs.
- If performance requirements conflict with design ambition (e.g., heavy animations), prioritize performance and explain design adjustments.
