# Decision 004: Drift SQLite Native and Web Connection Strategy

- **Date:** 2026-11-02
- **Status:** accepted

## Context
GymTracker uses Drift as its type-safe SQLite database layer. Drift supports native SQLite on mobile (iOS, Android) and desktop (macOS) via `drift/native.dart`. For Web, Drift requires WebAssembly (`drift/wasm.dart`) or virtual storage.

## Decision
- For mobile and macOS desktop, use `NativeDatabase.createInBackground(file)` with `PRAGMA foreign_keys = ON;` and `PRAGMA journal_mode = WAL;` enabled in `beforeOpen`.
- For Web, decouple connection through conditional export (`lib/data/database/connection/connection.dart`).
- Prioritize native performance (iOS/Android) as the primary offline mobile target, deferring full WebAssembly worker database setup until web-specific deployment phase.

## Consequences
- **Pros:** Native mobile builds enjoy maximum SQLite read/write performance, WAL concurrency, and immediate offline persistence.
- **Cons:** Web builds without Wasm worker initialization will fall back to in-memory or unsupported connection until WebAssembly workers are configured.
- **Trade-off accepted:** Mobile is the primary fitness tracker platform where offline performance is critical.
