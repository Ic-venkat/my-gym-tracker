# AGENTS.md — AI Coding Agent Rules

## Project Overview
- **Name:** GymTracker
- **Stack:** Flutter 3.47.9, Dart 3.13.7, drift (SQLite), flutter_bloc, speech_to_text, fl_chart
- **Architecture:** Feature-first Clean Architecture with BLoC pattern
- **Package Manager:** Flutter pub (pubspec.yaml)
- **Min Dart SDK:** 3.13.0

## Build & Development Commands
```bash
# Install dependencies
flutter pub get

# Run dev (Chrome)
flutter run -d chrome

# Run dev (Android)
flutter run

# Run dev (iOS)
flutter run -d ios

# Analyze code
flutter analyze

# Format code
dart format .

# Run tests
flutter test

# Run specific test
flutter test test/path/to/test.dart

# Generate code (drift, freezed, etc.)
dart run build_runner build --delete-conflicting-outputs
```

## Architecture Rules

### Feature-First Structure
```
lib/features/<feature_name>/
├── bloc/          # BLoC (events, states, bloc)
├── screens/       # Full page widgets
├── widgets/       # Feature-specific widgets
└── models/        # Feature-specific models (if any)
```

### Layer Rules
- **UI Layer** (`screens/`, `widgets/`) → depends on BLoC only. NEVER import repositories or database directly.
- **BLoC Layer** (`bloc/`) → depends on repositories only. NEVER import database or UI code.
- **Data Layer** (`data/`) → contains database, models, and repositories. NEVER import UI or BLoC code.
- **Voice Layer** (`voice/`) → self-contained. Exposes a clean service API. NEVER import UI code.

### Dependency Direction (strict)
```
UI → BLoC → Repository → Database
             ↑
         Voice Service
```

## Dart/Flutter Coding Standards

### Type Safety
- ❌ NEVER use `dynamic` unless absolutely required for JSON deserialization
- ❌ NEVER use `as` casting without a null check or type check first
- ✅ Always use `final` for variables that won't be reassigned
- ✅ Always specify return types on functions and methods
- ✅ Use `required` for named parameters that must be provided

### Naming Conventions
| Type | Convention | Example |
|---|---|---|
| Files | `snake_case.dart` | `workout_bloc.dart` |
| Classes | `PascalCase` | `WorkoutBloc` |
| Variables/Functions | `camelCase` | `currentWorkout` |
| Constants | `camelCase` | `defaultRestTime` |
| Enums | `PascalCase` (values: `camelCase`) | `ExerciseType.compound` |
| BLoC Events | `PascalCase` ending in verb/noun | `WorkoutStarted` |
| BLoC States | `PascalCase` ending in status | `WorkoutInProgress` |
| Widgets | `PascalCase` matching filename | `RestTimerWidget` |

### File Organization
- One public class per file (private helpers are fine in the same file)
- Max file length: **250 lines**. If longer, split into smaller files.
- Import order: dart → package → relative (separated by blank lines)
- Use `part` files only for freezed/drift generated code

### Widget Rules
- Prefer `const` constructors wherever possible
- Extract widgets into separate files when they exceed **80 lines**
- Use `Key` parameters for list items
- Prefer `StatelessWidget` unless local state is truly needed

### Error Handling
- ❌ NEVER use empty catch blocks: `catch (e) {}`
- ❌ NEVER swallow errors silently
- ✅ Always log or handle errors explicitly
- ✅ Use `Either` pattern or sealed classes for Result types in repositories
- ✅ Show user-friendly error messages in the UI

### Testing
- Every new BLoC must have corresponding unit tests
- Every repository must have corresponding unit tests
- Test file naming: `<source_file>_test.dart`
- Follow AAA pattern: Arrange → Act → Assert
- Use `blocTest` for BLoC testing

## Guardrails — NEVER Do This
- ❌ NEVER modify generated files (`*.g.dart`, `*.freezed.dart`) manually
- ❌ NEVER commit API keys, secrets, or `.env` files
- ❌ NEVER add a new package to `pubspec.yaml` without checking if an existing package already solves the problem
- ❌ NEVER use `print()` for logging — use a proper logger
- ❌ NEVER hardcode strings that should be localized
- ❌ NEVER use `setState` in a screen that has a BLoC — use `BlocBuilder`/`BlocListener`
- ❌ NEVER create God-classes or God-BLoCs. Split by feature.
- ❌ NEVER store business logic in widgets

## Task Completion Checklist
Before marking any task as complete, you MUST:
1. Run `dart format .` and ensure all files are formatted
2. Run `flutter analyze` and ensure **zero** warnings or errors
3. Run `flutter test` and ensure all tests pass
4. Verify no new `dynamic` types were introduced
5. Ensure all new public APIs have dartdoc comments
6. Verify the feature works on at least one platform (Chrome for speed)

## Decision Log
When making an architectural or technical decision, document it in `docs/decisions/NNN-title.md` using this format:
```markdown
# Decision NNN: Title
- **Date:** YYYY-MM-DD
- **Status:** accepted | superseded | deprecated
- **Context:** Why was this decision needed?
- **Decision:** What was decided?
- **Consequences:** What are the trade-offs?
```
