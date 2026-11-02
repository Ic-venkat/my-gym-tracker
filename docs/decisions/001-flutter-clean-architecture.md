# Decision 001: Flutter with Feature-First Clean Architecture

- **Date:** 2026-11-02
- **Status:** accepted

## Context
We need to build a cross-platform gym tracker app that runs on Android, iOS, and Web. The app needs voice control with minimal/zero API costs. We need an architecture that AI coding agents can follow consistently.

## Decision
- **Framework:** Flutter 3.47 (Dart 3.13) — single codebase for all platforms
- **Architecture:** Feature-first Clean Architecture with BLoC pattern
- **State Management:** flutter_bloc — predictable, testable, well-documented
- **Database:** drift (SQLite) — type-safe, reactive, local-first
- **Voice:** On-device speech_to_text + rule-based command parser — zero API costs

## Consequences
- **Pros:** Single codebase, zero recurring costs, strong type safety, AI agents can follow the clear architecture boundaries
- **Cons:** Flutter web performance is decent but not as fast as native web frameworks; Dart is less mainstream than JavaScript/TypeScript
- **Trade-off accepted:** Dart learning curve is offset by Flutter's excellent cross-platform support and the fact that AI agents handle most of the Dart code generation
