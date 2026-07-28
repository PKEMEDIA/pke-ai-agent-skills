---
name: grok-build-ios
description: >
  Optimize and validate Grok Build apps for the iOS Grok app and web client: mobile viewports,
  touch targets, safe areas, live preview contract, HMR continuity, production build render
  checks, and skill technique coverage. Triggers on ios, iphone, mobile, grok build optimize.
metadata:
  short-description: "iOS + web Grok Build optimizer"
  optimized-for: [ios, web, grok-build]
---

# Grok Build iOS / Web Optimize

Make Build outputs actually work on phone and desktop previews.

## When to Use
- Shipping any Grok Build app
- User mentions iOS app Build access
- QA / validation / optimize passes

## Instructions
1. Mobile-first ~390×844; no horizontal overflow
2. Touch targets ≥44px; fixed chrome uses safe-area insets
3. Verify visible content in real browser + clean console
4. Run production build and confirm built output renders
5. Keep startup revive script correct and idempotent
6. For games: verify controls + touch per building-games
7. Apply design-ui anti-slop on all chrome

## Checklist
- [ ] Dev render OK
- [ ] Prod build render OK
- [ ] Mobile layout OK
- [ ] Skills inventory validated
- [ ] Spicy/Beast profiles applied if requested
