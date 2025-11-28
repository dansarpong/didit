import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

// Manual TypeIds:
// Workout: 0
// Exercise: 1
// Interval: 2
// IntervalType: 3

enum IntervalType { work, rest, warmup, cooldown }

class IntervalTypeAdapter extends TypeAdapter<IntervalType> {
  @override
  final int typeId = 3;

  @override
  IntervalType read(BinaryReader reader) {
    return IntervalType.values[reader.readByte()];
  }

  @override
  void write(BinaryWriter writer, IntervalType obj) {
    writer.writeByte(obj.index);
  }
}

class Interval {
  String id;
  IntervalType type;
  int durationSeconds;
  String name;
  bool isReps;
  int reps;

  Interval({
    required this.type,
    this.durationSeconds = 30,
    String? name,
    this.isReps = false,
    this.reps = 10,
    String? id,
  })  : id = id ?? const Uuid().v4(),
        name = name ?? type.name.toUpperCase();
}

class IntervalAdapter extends TypeAdapter<Interval> {
  @override
  final int typeId = 2;

  @override
  Interval read(BinaryReader reader) {
    return Interval(
      type: IntervalType.values[reader.readByte()],
      durationSeconds: reader.readInt(),
      id: reader.readString(),
      name: reader.readString(),
      isReps: reader.readBool(),
      reps: reader.readInt(),
    );
  }

  @override
  void write(BinaryWriter writer, Interval obj) {
    writer.writeByte(obj.type.index);
    writer.writeInt(obj.durationSeconds);
    writer.writeString(obj.id);
    writer.writeString(obj.name);
    writer.writeBool(obj.isReps);
    writer.writeInt(obj.reps);
  }
}

class Exercise {
  String id;
  String name;
  // Can add more details like description, video URL, etc.

  Exercise({
    required this.name,
    String? id,
  }) : id = id ?? const Uuid().v4();
}

class ExerciseAdapter extends TypeAdapter<Exercise> {
  @override
  final int typeId = 1;

  @override
  Exercise read(BinaryReader reader) {
    return Exercise(
      name: reader.readString(),
      id: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, Exercise obj) {
    writer.writeString(obj.name);
    writer.writeString(obj.id);
  }
}

class Workout extends HiveObject {
  String id;
  String name;
  List<Interval> warmup;
  List<Interval> intervals;
  List<Interval> cooldown;
  int rounds;

  Workout({
    required this.name,
    required this.intervals,
    this.warmup = const [],
    this.cooldown = const [],
    this.rounds = 1,
    String? id,
  }) : id = id ?? const Uuid().v4();

  int get totalDuration {
    int warmupDuration = warmup.fold(0, (sum, i) => sum + i.durationSeconds);
    int cooldownDuration = cooldown.fold(0, (sum, i) => sum + i.durationSeconds);
    int mainDuration = intervals.fold(0, (sum, i) => sum + i.durationSeconds);
    return warmupDuration + (mainDuration * rounds) + cooldownDuration;
  }
}

class WorkoutAdapter extends TypeAdapter<Workout> {
  @override
  final int typeId = 0;

  @override
  Workout read(BinaryReader reader) {
    return Workout(
      name: reader.readString(),
      intervals: (reader.readList()).cast<Interval>(),
      rounds: reader.readInt(),
      id: reader.readString(),
      warmup: (reader.readList()).cast<Interval>(),
      cooldown: (reader.readList()).cast<Interval>(),
    );
  }

  @override
  void write(BinaryWriter writer, Workout obj) {
    writer.writeString(obj.name);
    writer.writeList(obj.intervals);
    writer.writeInt(obj.rounds);
    writer.writeString(obj.id);
    writer.writeList(obj.warmup);
    writer.writeList(obj.cooldown);
  }
}
