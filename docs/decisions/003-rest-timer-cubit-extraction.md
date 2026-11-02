# Decision 003: Extraction of RestTimerCubit from WorkoutBloc

- **Date:** 2026-11-02
- **Status:** accepted

## Context
Initially, the rest timer ticker and remaining seconds were managed inside `WorkoutBloc`. As workout session management, set logging, and natural language voice commands were added, `WorkoutBloc` grew beyond 270 lines, violating the 250-line rule in `AGENTS.md` and violating Single Responsibility Principle (God-BLoC smell).

## Decision
- Extract rest timer countdown state management into a dedicated `RestTimerCubit` with `RestTimerState(remainingSeconds, isActive)`.
- `RestTimerCubit` manages `Timer.periodic`, handles skip/cancel logic, and triggers TTS voice notification (`"Rest time is up! Ready for next set."`) upon completion.
- `WorkoutBloc` coordinates with `RestTimerCubit` to trigger timers upon set logging or voice commands.

## Consequences
- **Pros:** Reduces `WorkoutBloc` to under 180 lines; allows independent UI rebuilds of the rest timer banner without triggering full workout tree reconciliations; simplifies testing.
- **Cons:** Introduces a second BLoC provider at root for rest timer.
- **Trade-off accepted:** Significantly higher modularity, clean testability, and strict adherence to file size rules.

