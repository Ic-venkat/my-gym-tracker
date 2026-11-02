# Decision 002: On-Device Voice with Rule-Based NLP

- **Date:** 2026-11-02
- **Status:** accepted

## Context
The app needs voice-based workout logging. Cloud AI APIs (OpenAI, Google Cloud Speech) cost money per request. The user wants zero/minimal recurring costs. Gym commands are fairly structured and predictable.

## Decision
- **Speech-to-Text:** `speech_to_text` Flutter package — uses native OS recognition (Apple Speech on iOS, Google STT on Android). Completely free.
- **Command Understanding:** Custom rule-based NLP parser using regex and keyword matching. No AI API needed.
- **Text-to-Speech:** `flutter_tts` — native OS TTS for voice feedback. Free.

## Consequences
- **Pros:** Zero API costs, works offline, fast response time, no privacy concerns (audio never leaves device)
- **Cons:** Rule-based parser can't handle very ambiguous or creative phrasing. Limited to patterns we explicitly code.
- **Mitigation:** If smarter parsing is needed later, we can add on-device Gemma (flutter_gemma) — still free, no API calls.
- **Trade-off accepted:** 95% of gym commands follow predictable patterns. Rule-based parsing is sufficient and costs nothing.
