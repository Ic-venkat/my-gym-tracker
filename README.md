# GymTracker 🏋️

A voice-powered fitness tracking app built with Flutter. Track your workouts hands-free across Android, iOS, and Web.

## Features

- 🎤 **Voice Control** — Log exercises hands-free using on-device speech recognition
- 📊 **Progress Tracking** — Charts and personal records
- ⏱️ **Rest Timer** — Configurable timer with alerts
- 📱 **Cross-Platform** — Android, iOS, Web, and macOS
- 🔒 **Privacy First** — All data stored locally on device
- 💰 **Zero API Costs** — No cloud AI, everything runs on-device

## Getting Started

### Prerequisites
- Flutter 3.47+ ([Install Flutter](https://docs.flutter.dev/get-started/install))
- Dart 3.13+
- Android Studio (for Android builds)
- Xcode 27+ (for iOS builds)

### Installation
```bash
# Clone the repo
git clone <repo-url>
cd my-gym-tracker

# Install dependencies
flutter pub get

# Generate code (drift, freezed)
dart run build_runner build --delete-conflicting-outputs

# Run on Chrome
flutter run -d chrome

# Run on Android
flutter run

# Run on iOS
flutter run -d ios
```

### Development
```bash
# Format code
dart format .

# Analyze
flutter analyze

# Run tests
flutter test
```

## Architecture

Feature-first Clean Architecture with BLoC pattern. See [AGENTS.md](AGENTS.md) for full coding standards.

```
lib/
├── core/          # Shared utilities, theme, router
├── data/          # Database, models, repositories
├── features/      # Feature modules (workout, exercises, stats...)
├── voice/         # Speech-to-text, TTS, command parser
└── di/            # Dependency injection
```

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines. Key rules:
- MRs must be under 300 lines changed
- Run `flutter analyze` and `flutter test` before submitting
- Follow the conventions in `AGENTS.md`

## Tech Stack

| Component | Technology |
|---|---|
| Framework | Flutter 3.47 |
| Language | Dart 3.13 |
| State Management | flutter_bloc |
| Database | drift (SQLite) |
| Voice Input | speech_to_text (on-device) |
| Voice Output | flutter_tts (on-device) |
| Charts | fl_chart |
| Navigation | go_router |

## License

This project is private. All rights reserved.
