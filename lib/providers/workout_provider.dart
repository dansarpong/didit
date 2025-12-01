import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/workout_model.dart';

class WorkoutProvider extends ChangeNotifier {
  Box<Workout>? _box;
  Box<WorkoutHistory>? _historyBox;
  List<Workout> _workouts = [];
  List<WorkoutHistory> _history = [];
  final String boxName;
  final String historyBoxName;

  List<Workout> get workouts => _workouts;
  List<WorkoutHistory> get history => _history;

  WorkoutProvider({
    this.boxName = 'workouts',
    this.historyBoxName = 'history',
  }) {
    _init();
  }

  Future<void> _init() async {
    if (Hive.isBoxOpen(boxName)) {
      _box = Hive.box<Workout>(boxName);
    } else {
      _box = await Hive.openBox<Workout>(boxName);
    }
    
    if (Hive.isBoxOpen(historyBoxName)) {
      _historyBox = Hive.box<WorkoutHistory>(historyBoxName);
    } else {
      _historyBox = await Hive.openBox<WorkoutHistory>(historyBoxName);
    }

    _workouts = _box!.values.toList();
    _history = _historyBox!.values.toList()..sort((a, b) => b.completedAt.compareTo(a.completedAt));
    notifyListeners();
  }

  Future<void> addWorkout(Workout workout) async {
    await _box?.add(workout);
    _workouts = _box!.values.toList();
    notifyListeners();
  }

  Future<void> deleteWorkout(int index) async {
    await _box?.deleteAt(index);
    _workouts = _box!.values.toList();
    notifyListeners();
  }

  Future<void> updateWorkout(int index, Workout workout) async {
    await _box?.putAt(index, workout);
    _workouts = _box!.values.toList();
    notifyListeners();
  }

  Future<void> addHistory(WorkoutHistory record) async {
    await _historyBox?.add(record);
    _history = _historyBox!.values.toList()..sort((a, b) => b.completedAt.compareTo(a.completedAt));
    notifyListeners();
  }

  Future<void> clearHistory() async {
    await _historyBox?.clear();
    _history = [];
    notifyListeners();
  }
}
