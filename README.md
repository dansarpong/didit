# DIDIT

A Flutter web application for creating and running personalized High-Intensity Interval Training (HIIT) workouts with a sleek, atmospheric dark theme.

## Features

### Current Features

- **Custom Workout Creation**
  - Create workouts with warmup, work/rest intervals, and cooldown
  - Edit exercise details (name, duration, reps) by tapping on them
  - Time-based intervals (up to 5 minutes)
  - Reps-based intervals for exercises like push-ups
  - Reorderable intervals in all sections (Warmup, Work/Rest, Cooldown) with drag handles
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
  - Automatic history tracking upon completion

- **Navigation & History**
  - Bottom navigation bar with three tabs: Workouts, Logbook, and Settings
  - Logbook displays workout history with completion timestamps and durations
  - Edit mode for deleting individual workout logs
  - Clear all history option

- **Design**
  - Web-first, mobile-first responsive design
  - Dark theme with neon cyan/pink accents
  - Smooth animations and transitions throughout the app
  - Premium UI with gradient backgrounds
  - Consistent header design across all pages
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
│   └── workout_model.dart    # Data models (Workout, Interval, WorkoutHistory)
├── providers/
│   └── workout_provider.dart # State management
├── screens/
│   ├── main_screen.dart      # Bottom navigation shell
│   ├── workouts_screen.dart  # Workout list
│   ├── logbook_screen.dart   # Workout history
│   ├── settings_screen.dart  # App settings
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
- **Date Formatting**: intl

## Usage

### Navigation

The app features three main tabs accessible via the bottom navigation bar:

- **Workouts**: Create, view, edit, and manage your workout library
- **Logbook**: View your workout history with completion dates and durations
- **Settings**: App information and preferences

### Creating a Workout

1. Navigate to the **Workouts** tab
2. Tap the **+** button
3. Enter a workout name
4. Add intervals:
   - **Warmup**: Executed once at the start
   - **Work/Rest**: Repeated for the specified rounds
   - **Cooldown**: Executed once at the end
5. For each interval:
   - Choose the type (Warmup, Work, Rest, Cooldown)
   - Set a custom name (optional)
   - Choose Time or Reps mode
   - Set duration (1-300 seconds) or reps (1-100)
6. Reorder intervals by dragging the handle icon
7. Tap any interval to edit its details
8. Set the number of rounds
9. Tap the checkmark to save

### Running a Workout

1. From the **Workouts** tab, tap on a workout card
2. The workout executes in phases:
   - Warmup intervals (once)
   - Work/Rest intervals (repeated for rounds)
   - Cooldown intervals (once)
3. Use controls:
   - **Pause/Play**: Pause or resume the timer
   - **Skip**: Advance to the next interval
   - **Done**: (Reps mode) Mark interval as complete
4. Upon completion, the workout is automatically saved to your history

### Editing a Workout

1. From the **Workouts** tab, tap the **⋮** menu on a workout card
2. Select **Edit**
3. Make changes (edit intervals, reorder, add/remove)
4. Tap the checkmark to save

### Managing History

1. Navigate to the **Logbook** tab to view completed workouts
2. Tap the **edit** button (pencil icon) to enter edit mode
3. Tap the delete icon next to any workout log to remove it
4. Tap the checkmark to exit edit mode

## Contributing

Contributions are welcome! Please ensure:

- All unit tests pass (`flutter test`)
- New features include appropriate tests
- Code follows Flutter best practices

## License

This project is licensed under the GNU General Public License v3.0 - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

Built with Flutter and inspired by the need for flexible, customizable HIIT workouts.
