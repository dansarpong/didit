import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/workout_model.dart';

class WorkoutProvider extends ChangeNotifier {
  Box<Workout>? _box;
  List<Workout> _workouts = [];
  final String boxName;

  List<Workout> get workouts => _workouts;

  WorkoutProvider({this.boxName = 'workouts'}) {
    _init();
  }

  Future<void> _init() async {
    if (Hive.isBoxOpen(boxName)) {
      _box = Hive.box<Workout>(boxName);
    } else {
      _box = await Hive.openBox<Workout>(boxName);
    }
    _workouts = _box!.values.toList();
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
}
