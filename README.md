# DIDIT

A Flutter web application for creating and running personalized High-Intensity Interval Training (HIIT) workouts with a sleek, atmospheric dark theme.

## Features

### Current Features

- **Custom Workout Creation**
  - Create workouts with warmup, work/rest intervals, and cooldown
  - **Edit exercise details** (name, duration, reps) by tapping on them
  - Time-based intervals (up to 5 minutes)
  - Reps-based intervals for exercises like push-ups
  - **Reorderable intervals** in all sections (Warmup, Work/Rest, Cooldown)
  - Configurable number of rounds

- **Workout Management**
  - Save and load workouts locally with Hive
  - Edit existing workouts
  - Duplicate workouts for quick variations
  - Delete workouts

- **Workout Execution**
  - Phase-based execution: Warmup → [Work/Rest] × Rounds → Cooldown
  - Visual circular progress indicator with color coding
  - Pause/resume functionality
  - Skip to next interval
  - Manual advance for reps-based intervals
  - Celebration animation on completion

- **Design**
  - Mobile-first responsive design
  - Dark theme with neon cyan/pink accents
  - Smooth animations and transitions
  - Color-coded interval types:
    - 🟦 Cyan: Work intervals
    - 🟪 Pink: Rest intervals
    - 🟧 Orange: Warmup
    - 🟩 Green: Cooldown

### Testing

- **18 unit tests** covering models and business logic
- Run tests: `flutter test`

## Getting Started

### Prerequisites

- Flutter SDK (latest stable version)
- Chrome or any modern web browser

### Installation

1. Clone the repository:

```bash
git clone <repository-url>
cd hiit
```

2. Install dependencies:

```bash
flutter pub get
```

3. Run the app:

```bash
flutter run -d chrome
```

### Building

Build for web:

```bash
flutter build web
```

The built files will be in `build/web/` directory.

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/
│   └── workout_model.dart    # Data models (Workout, Interval, Exercise)
├── providers/
│   └── workout_provider.dart # State management
├── screens/
│   ├── home_screen.dart      # Workout list
│   ├── create_workout_screen.dart  # Create/edit workouts
│   └── run_workout_screen.dart     # Execute workouts
└── theme/
    └── app_theme.dart        # App styling

test/
├── models/                   # Model unit tests
└── providers/                # Provider unit tests

web/                          # Web-specific files
```

## Tech Stack

- **Framework**: Flutter (Dart)
- **State Management**: Provider
- **Local Storage**: Hive (NoSQL database)
- **Typography**: Google Fonts (Outfit)
- **Animations**: flutter_animate

## Usage

### Creating a Workout

1. Tap the **+** button on the home screen
2. Enter a workout name
3. Add intervals:
   - **Warmup**: Executed once at the start
   - **Work/Rest**: Repeated for the specified rounds
   - **Cooldown**: Executed once at the end
4. For each interval:
   - Choose the type (Warmup, Work, Rest, Cooldown)
   - Set a custom name (optional)
   - Choose Time or Reps mode
   - Set duration (1-300 seconds) or reps (1-100)
5. Set the number of rounds
6. Tap the checkmark to save

### Running a Workout

1. Tap on a workout card from the home screen
2. The workout executes in phases:
   - Warmup intervals (once)
   - Work/Rest intervals (repeated for rounds)
   - Cooldown intervals (once)
3. Use controls:
   - **Pause/Play**: Pause or resume the timer
   - **Skip**: Advance to the next interval
   - **Done**: (Reps mode) Mark interval as complete

### Editing a Workout

1. Tap the **⋮** menu on a workout card
2. Select **Edit**
3. Make changes
4. Tap the checkmark to save

## TODO

- [ ] Add menu tabs (Workouts, Logbook, Settings)
- [ ] Add sound cues for interval transitions
- [ ] Voice announcements during workouts
- [ ] Add workout history tracking
- [ ] Add notepad feature for creating or editing workouts
- [ ] Export/import workouts (JSON)
- [ ] Add preset workout templates
- [ ] Custom color themes

## Contributing

Contributions are welcome! Please ensure:

- All unit tests pass (`flutter test`)
- New features include appropriate tests
- Code follows Flutter best practices

## License

This project is licensed under the GNU General Public License v3.0 - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

Built with Flutter and inspired by the need for flexible, customizable HIIT workouts.
