import 'dart:async';
import 'package:flutter/material.dart' hide Interval;
import 'package:flutter_animate/flutter_animate.dart';
import '../models/workout_model.dart';

enum WorkoutPhase { warmup, main, cooldown }

class RunWorkoutScreen extends StatefulWidget {
  final Workout workout;

  const RunWorkoutScreen({super.key, required this.workout});

  @override
  State<RunWorkoutScreen> createState() => _RunWorkoutScreenState();
}

class _RunWorkoutScreenState extends State<RunWorkoutScreen> {
  late Timer _timer;
  int _currentRound = 1;
  int _currentIntervalIndex = 0;
  int _remainingSeconds = 0;
  bool _isPaused = false;
  bool _isFinished = false;
  WorkoutPhase _phase = WorkoutPhase.warmup;

  // Computed properties for current interval
  Interval? get _currentInterval {
    switch (_phase) {
      case WorkoutPhase.warmup:
        if (_currentIntervalIndex < widget.workout.warmup.length) {
          return widget.workout.warmup[_currentIntervalIndex];
        }
        return null;
      case WorkoutPhase.main:
        if (_currentIntervalIndex < widget.workout.intervals.length) {
          return widget.workout.intervals[_currentIntervalIndex];
        }
        return null;
      case WorkoutPhase.cooldown:
        if (_currentIntervalIndex < widget.workout.cooldown.length) {
          return widget.workout.cooldown[_currentIntervalIndex];
        }
        return null;
    }
  }

  @override
  void initState() {
    super.initState();
    _startInterval();
  }

  void _startInterval() {
    // Advance to next phase if current phase is complete
    if (_currentInterval == null) {
      if (_phase == WorkoutPhase.warmup) {
        _phase = WorkoutPhase.main;
        _currentIntervalIndex = 0;
        _currentRound = 1;
      } else if (_phase == WorkoutPhase.main) {
        _currentIntervalIndex = 0;
        if (_currentRound < widget.workout.rounds) {
          _currentRound++;
        } else {
          _phase = WorkoutPhase.cooldown;
          _currentIntervalIndex = 0;
          _currentRound = 1;
        }
      } else if (_phase == WorkoutPhase.cooldown) {
        _finishWorkout();
        return;
      }
    }

    final interval = _currentInterval;
    if (interval == null) {
      _finishWorkout();
      return;
    }

    setState(() {
      _remainingSeconds = interval.durationSeconds;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isPaused) return;

      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        timer.cancel();
        _currentIntervalIndex++;
        _startInterval();
      }
    });
  }

  void _finishWorkout() {
    setState(() {
      _isFinished = true;
    });
    _timer.cancel();
  }

  void _togglePause() {
    setState(() {
      _isPaused = !_isPaused;
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Color _getBackgroundColor() {
    if (_isFinished) return Colors.green.shade900;
    final interval = _currentInterval;
    if (interval == null) {
      return Theme.of(context).colorScheme.surface;
    }
    switch (interval.type) {
      case IntervalType.work:
        return const Color(0xFF00E5FF).withValues(alpha: 0.1);
      case IntervalType.rest:
        return const Color(0xFFFF4081).withValues(alpha: 0.1);
      case IntervalType.warmup:
        return Colors.orange.withValues(alpha: 0.1);
      case IntervalType.cooldown:
        return Colors.green.withValues(alpha: 0.1);
    }
  }

  Color _getIntervalColor(IntervalType type) {
    switch (type) {
      case IntervalType.work:
        return Theme.of(context).colorScheme.primary;
      case IntervalType.rest:
        return Theme.of(context).colorScheme.secondary;
      case IntervalType.warmup:
        return Colors.orange;
      case IntervalType.cooldown:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isFinished) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.emoji_events, size: 100, color: Colors.amber)
                  .animate()
                  .scale(duration: 500.ms)
                  .then()
                  .shake(),
              const SizedBox(height: 20),
              Text('Workout Complete!', style: Theme.of(context).textTheme.displayLarge),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Back to Home'),
              ),
            ],
          ),
        ),
      );
    }

    final currentInterval = _currentInterval!;
    final progress = currentInterval.isReps
        ? 1.0
        : _remainingSeconds / currentInterval.durationSeconds;

    return Scaffold(
      backgroundColor: _getBackgroundColor(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Exercise name above timer
          Text(
            currentInterval.name,
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: _getIntervalColor(currentInterval.type),
                  fontSize: 32,
                ),
          ).animate(target: _remainingSeconds == currentInterval.durationSeconds ? 1 : 0).scale(),
          const SizedBox(height: 40),
          // Circle timer
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 300,
                height: 300,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 20,
                  backgroundColor: Colors.white10,
                  color: _getIntervalColor(currentInterval.type),
                ),
              ),
              // Countdown or reps inside circle
              if (currentInterval.isReps)
                Text(
                  '${currentInterval.reps} reps',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 60),
                )
              else
                Text(
                  '$_remainingSeconds',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 80),
                ),
            ],
          ),
          const SizedBox(height: 40),
          // Round info below timer
          if (_phase == WorkoutPhase.main)
            Text(
              'Round $_currentRound / ${widget.workout.rounds}',
              style: Theme.of(context).textTheme.displayMedium,
            )
          else
            Text(
              _phase == WorkoutPhase.warmup ? 'Warmup' : 'Cooldown',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: _phase == WorkoutPhase.warmup ? Colors.orange : Colors.green,
                  ),
            ),
          const SizedBox(height: 60),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (currentInterval.isReps)
                FloatingActionButton.large(
                  heroTag: 'done_button',
                  onPressed: () {
                    _timer.cancel();
                    _currentIntervalIndex++;
                    _startInterval();
                  },
                  child: const Icon(Icons.check),
                )
              else ...[
                FloatingActionButton.large(
                  heroTag: 'pause_button',
                  onPressed: _togglePause,
                  child: Icon(_isPaused ? Icons.play_arrow : Icons.pause),
                ),
                const SizedBox(width: 24),
                FloatingActionButton(
                  heroTag: 'skip_button',
                  onPressed: () {
                    _timer.cancel();
                    _currentIntervalIndex++;
                    _startInterval();
                  },
                  backgroundColor: Colors.grey.shade700,
                  child: const Icon(Icons.skip_next),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
