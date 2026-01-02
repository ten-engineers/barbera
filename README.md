# Barbera - Language Learning App

A Flutter-based language learning app focused on effective memorization through flashcards and spaced repetition.

## Features

- ✅ Manual word creation with optional examples
- ✅ Active recall flashcards (tap to reveal)
- ✅ Intuitive swipe gestures:
  - Swipe RIGHT → Mark as "Known" (spaced repetition)
  - Swipe LEFT → Archive word
  - TAP → Flip card to see translation
- ✅ Spaced repetition algorithm (SM-2 inspired)
- ✅ Streaks and daily statistics
- ✅ Offline-first local storage (Hive)
- ✅ Clean, minimal UI

## Getting Started

### Prerequisites
- Flutter SDK (latest stable)
- Android Studio / Xcode for mobile development

### Setup

1. Install Flutter dependencies:
```bash
flutter pub get
```

2. Generate Hive adapters (required for data models):
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

3. Run the app:
```bash
flutter run
```

## Architecture

The app follows clean architecture principles with clear separation of concerns:

### Domain Layer (`lib/domain/`)
- **Entities**: Core business objects (`Flashcard`, `UserStats`)
- **Repositories**: Abstract interfaces for data access
- **Services**: Business logic (spaced repetition algorithm)

### Data Layer (`lib/data/`)
- **Models**: Hive-annotated data models
- **Repositories**: Concrete implementations using Hive storage
- **Database**: Hive initialization and setup

### Presentation Layer (`lib/presentation/`)
- **Screens**: Main UI screens (Practice, Add Word, Stats)
- **Widgets**: Reusable components (FlashcardWidget, SwipeableFlashcardStack)
- **Providers**: Riverpod state management
- **Navigation**: GoRouter configuration

## Key Components

### Flashcard Interactions
- **Swipe Gestures**: Smooth pan gestures with visual feedback
- **Card Flip**: 3D flip animation on tap
- **Threshold-based**: Prevents accidental swipes

### Spaced Repetition Algorithm
Based on SM-2 algorithm with adjustments:
- Initial ease factor: 2.5
- Correct answer: Increases ease factor, extends interval
- Incorrect answer: Decreases ease factor, resets to 1 day
- Intervals: 1 day → 6 days → exponential growth

### Data Storage
- **Hive**: Fast, lightweight NoSQL database
- **Offline-first**: All data stored locally
- **Type-safe**: Generated adapters for models

## Project Structure

```
lib/
├── data/
│   ├── database/
│   ├── models/
│   └── repositories/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── services/
├── presentation/
│   ├── navigation/
│   ├── providers/
│   ├── screens/
│   └── widgets/
└── main.dart
```

## State Management

Using **Riverpod** for state management:
- `flashcardNotifierProvider`: Manages flashcard list and operations
- `userStatsProvider`: Tracks user statistics
- `allFlashcardsProvider`: Provides all flashcards for stats

## Future Enhancements (Post-MVP)

- Multiple language support
- Import/export flashcards
- Audio pronunciation
- Dark mode
- Cloud sync
- Advanced statistics and analytics

