import 'package:flutter_test/flutter_test.dart';
import 'package:didit_app/models/workout_model.dart';

void main() {
  group('WorkoutProvider Logic Tests', () {
    test('Workout model duration calculation with full workout', () {
      final workout = Workout(
        name: 'Provider Test Workout',
        warmup: [
          Interval(type: IntervalType.warmup, durationSeconds: 60),
        ],
        intervals: [
          Interval(type: IntervalType.work, durationSeconds: 40),
          Interval(type: IntervalType.rest, durationSeconds: 20),
        ],
        cooldown: [
          Interval(type: IntervalType.cooldown, durationSeconds: 60),
        ],
        rounds: 4,
      );

      // 60 + [(40+20) * 4] + 60 = 360 seconds
      expect(workout.totalDuration, 360);
    });

    test('Workout duration calculation matches what provider would store', () {
      final workouts = <Workout>[
        Workout(
          name: 'First',
          intervals: [
            Interval(type: IntervalType.work, durationSeconds: 30),
          ],
          rounds: 2,
        ),
        Workout(
          name: 'Second',
          intervals: [
            Interval(type: IntervalType.work, durationSeconds: 45),
            Interval(type: IntervalType.rest, durationSeconds: 15),
          ],
          rounds: 3,
        ),
      ];

      expect(workouts.length, 2);
      expect(workouts[0].totalDuration, 60); // 30 * 2
      expect(workouts[1].totalDuration, 180); // (45 + 15) * 3
    });

    test('Complex workout with all interval types', () {
      final workout = Workout(
        name: 'Complex',
        warmup: [
          Interval(type: IntervalType.warmup, durationSeconds: 120, name: 'Dynamic Stretch'),
        ],
        intervals: [
          Interval(type: IntervalType.work, durationSeconds: 50, name: 'Burpees'),
          Interval(type: IntervalType.rest, durationSeconds: 10),
          Interval(type: IntervalType.work, durationSeconds: 30, name: 'Squats', isReps: true, reps: 20),
          Interval(type: IntervalType.rest, durationSeconds: 10),
        ],
        cooldown: [
          Interval(type: IntervalType.cooldown, durationSeconds: 180, name: 'Static Stretch'),
        ],
        rounds: 5,
      );

      expect(workout.warmup.length, 1);
      expect(workout.intervals.length, 4);
      expect(workout.cooldown.length, 1);
      expect(workout.warmup[0].name, 'Dynamic Stretch');
      expect(workout.intervals[0].name, 'Burpees');
      expect(workout.intervals[2].isReps, true);
      expect(workout.intervals[2].reps, 20);
      
      // Duration: 120 + [(50+10+30+10) * 5] + 180 = 800
      expect(workout.totalDuration, 800);
    });

    test('Workout ID persistence', () {
      final workout1 = Workout(name: 'Test', intervals: []);
      final workout2 = Workout(name: 'Test', intervals: [], id: workout1.id);

      expect(workout2.id, workout1.id);
    });

    test('Workout update preserves ID', () {
      final original = Workout(
        name: 'Original',
        intervals: [
          Interval(type: IntervalType.work, durationSeconds: 30),
        ],
      );

      final updated = Workout(
        name: 'Updated',
        intervals: [
          Interval(type: IntervalType.work, durationSeconds: 45),
        ],
        id: original.id,
      );

      expect(updated.id, original.id);
      expect(updated.name, 'Updated');
      expect(updated.intervals[0].durationSeconds, 45);
    });
  });
}
