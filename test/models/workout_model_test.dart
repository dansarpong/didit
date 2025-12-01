import 'package:flutter_test/flutter_test.dart';
import 'package:didit_app/models/workout_model.dart';

void main() {
  group('Workout Model Tests', () {
    test('Workout calculates total duration correctly with warmup and cooldown', () {
      final workout = Workout(
        name: 'Test Workout',
        warmup: [
          Interval(type: IntervalType.warmup, durationSeconds: 30),
        ],
        intervals: [
          Interval(type: IntervalType.work, durationSeconds: 40),
          Interval(type: IntervalType.rest, durationSeconds: 20),
        ],
        cooldown: [
          Interval(type: IntervalType.cooldown, durationSeconds: 30),
        ],
        rounds: 3,
      );

      // Warmup (30) + [Work (40) + Rest (20)] * 3 + Cooldown (30) = 240
      expect(workout.totalDuration, 240);
    });

    test('Workout calculates duration correctly without warmup/cooldown', () {
      final workout = Workout(
        name: 'Test Workout',
        intervals: [
          Interval(type: IntervalType.work, durationSeconds: 30),
          Interval(type: IntervalType.rest, durationSeconds: 15),
        ],
        rounds: 2,
      );

      expect(workout.totalDuration, 90); // (30 + 15) * 2
    });

    test('Workout with zero rounds has correct duration', () {
      final workout = Workout(
        name: 'Test Workout',
        intervals: [
          Interval(type: IntervalType.work, durationSeconds: 30),
        ],
        rounds: 0,
      );

      expect(workout.totalDuration, 0);
    });

    test('Workout with only warmup and cooldown', () {
      final workout = Workout(
        name: 'Stretch Only',
        warmup: [
          Interval(type: IntervalType.warmup, durationSeconds: 60),
        ],
        intervals: [],
        cooldown: [
          Interval(type: IntervalType.cooldown, durationSeconds: 60),
        ],
        rounds: 1,
      );

      expect(workout.totalDuration, 120);
    });
  });

  group('Interval Tests', () {
    test('Interval generates unique IDs', () {
      final interval1 = Interval(type: IntervalType.work, durationSeconds: 30);
      final interval2 = Interval(type: IntervalType.work, durationSeconds: 30);

      expect(interval1.id, isNot(equals(interval2.id)));
    });

    test('Interval default name is type in uppercase', () {
      final workInterval = Interval(type: IntervalType.work, durationSeconds: 30);
      final restInterval = Interval(type: IntervalType.rest, durationSeconds: 15);

      expect(workInterval.name, 'WORK');
      expect(restInterval.name, 'REST');
    });

    test('Interval accepts custom name', () {
      final interval = Interval(
        type: IntervalType.work,
        durationSeconds: 30,
        name: 'Burpees',
      );

      expect(interval.name, 'Burpees');
    });

    test('Interval supports reps mode', () {
      final interval = Interval(
        type: IntervalType.work,
        name: 'Push-ups',
        isReps: true,
        reps: 20,
      );

      expect(interval.isReps, true);
      expect(interval.reps, 20);
    });

    test('Interval defaults to time mode', () {
      final interval = Interval(
        type: IntervalType.work,
        durationSeconds: 45,
      );

      expect(interval.isReps, false);
      expect(interval.durationSeconds, 45);
    });

    test('All interval types are supported', () {
      final warmup = Interval(type: IntervalType.warmup, durationSeconds: 30);
      final work = Interval(type: IntervalType.work, durationSeconds: 40);
      final rest = Interval(type: IntervalType.rest, durationSeconds: 20);
      final cooldown = Interval(type: IntervalType.cooldown, durationSeconds: 30);

      expect(warmup.type, IntervalType.warmup);
      expect(work.type, IntervalType.work);
      expect(rest.type, IntervalType.rest);
      expect(cooldown.type, IntervalType.cooldown);
    });
  });

  group('Edge Cases', () {
    test('Empty workout intervals with rounds', () {
      final workout = Workout(
        name: 'Empty',
        intervals: [],
        rounds: 5,
      );

      expect(workout.totalDuration, 0);
    });

    test('Large number of rounds', () {
      final workout = Workout(
        name: 'Endurance',
        intervals: [
          Interval(type: IntervalType.work, durationSeconds: 10),
        ],
        rounds: 100,
      );

      expect(workout.totalDuration, 1000);
    });

    test('Maximum duration interval (5 minutes)', () {
      final interval = Interval(
        type: IntervalType.work,
        durationSeconds: 300, // 5 minutes
      );

      expect(interval.durationSeconds, 300);
    });
    test('Interval properties can be updated', () {
      final interval = Interval(
        type: IntervalType.work,
        durationSeconds: 30,
        name: 'Original',
      );

      // Simulate editing by creating a new interval with same ID
      final updated = Interval(
        type: IntervalType.work,
        durationSeconds: 45,
        name: 'Updated',
        id: interval.id,
      );

      expect(updated.id, interval.id);
      expect(updated.name, 'Updated');
      expect(updated.durationSeconds, 45);
    });
  });
}
