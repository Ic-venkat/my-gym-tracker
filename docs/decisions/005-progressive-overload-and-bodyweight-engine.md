# Decision 005: Progressive Overload & Bodyweight Skill Architecture

- **Date:** 2026-11-02
- **Status:** accepted

## Context
Lifters require intelligent load progression beyond simple tracking. However, standard barbell double progression does not directly apply to calisthenics skills (which progress through leverage changes rather than plate loading) or yoga/mobility (which requires timed isometric holds and breath pacing rather than weight/reps).

## Decision
1. **Mathematical 1RM Engine:** Implement validated formulas (Epley, Brzycki, Wathan, Lander) with a consensus average in a pure domain service (`OneRepMaxCalculator`).
2. **Double Progression Model:** Trigger weight increases (+1.25 to +2.5 kg) and reset reps to the bottom of the range once all working sets hit the target ceiling (e.g. 3x12). Detect stalls over 3 consecutive sessions and trigger a 10% deload recommendation.
3. **Calisthenics Skill Ladders:** Model bodyweight skills through structured progression ladders (e.g. Australian Rows $\rightarrow$ Scapular Pulls $\rightarrow$ Negatives $\rightarrow$ Pull-ups $\rightarrow$ L-Sits $\rightarrow$ Muscle-Up). Evaluate graduation thresholds (e.g. 3 sets of 20 reps or 30s holds) to recommend tier advancement.
4. **Yoga & Mobility Recovery:** Model routines around targeted post-workout muscle groups (e.g., spinal decompression after heavy squats/deadlifts, shoulder prehab after pressing) with paced hold timers and breath cadence.

## Consequences
- **Pros:** Unified, scientifically sound progression engine supporting loaded weightlifting, gymnastic calisthenics, and active recovery flows without external API dependencies.
- **Cons:** Requires exercise catalog metadata (rep ranges, min increments, ladder bindings) to be maintained accurately.

