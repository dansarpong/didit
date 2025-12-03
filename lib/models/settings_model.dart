import 'package:hive/hive.dart';

// TypeId: 5
class Settings extends HiveObject {
  // Sound preferences
  bool soundEnabled;
  bool workStartEnabled;
  bool restStartEnabled;
  bool warmupStartEnabled;
  bool cooldownStartEnabled;
  bool countdownEnabled;
  bool completionEnabled;
  double volume;

  Settings({
    this.soundEnabled = true,
    this.workStartEnabled = true,
    this.restStartEnabled = true,
    this.warmupStartEnabled = true,
    this.cooldownStartEnabled = true,
    this.countdownEnabled = true,
    this.completionEnabled = true,
    this.volume = 0.8,
  });

  // Create a copy with updated values
  Settings copyWith({
    bool? soundEnabled,
    bool? workStartEnabled,
    bool? restStartEnabled,
    bool? warmupStartEnabled,
    bool? cooldownStartEnabled,
    bool? countdownEnabled,
    bool? completionEnabled,
    double? volume,
  }) {
    return Settings(
      soundEnabled: soundEnabled ?? this.soundEnabled,
      workStartEnabled: workStartEnabled ?? this.workStartEnabled,
      restStartEnabled: restStartEnabled ?? this.restStartEnabled,
      warmupStartEnabled: warmupStartEnabled ?? this.warmupStartEnabled,
      cooldownStartEnabled: cooldownStartEnabled ?? this.cooldownStartEnabled,
      countdownEnabled: countdownEnabled ?? this.countdownEnabled,
      completionEnabled: completionEnabled ?? this.completionEnabled,
      volume: volume ?? this.volume,
    );
  }
}

class SettingsAdapter extends TypeAdapter<Settings> {
  @override
  final int typeId = 5;

  @override
  Settings read(BinaryReader reader) {
    return Settings(
      soundEnabled: reader.readBool(),
      workStartEnabled: reader.readBool(),
      restStartEnabled: reader.readBool(),
      warmupStartEnabled: reader.readBool(),
      cooldownStartEnabled: reader.readBool(),
      countdownEnabled: reader.readBool(),
      completionEnabled: reader.readBool(),
      volume: reader.readDouble(),
    );
  }

  @override
  void write(BinaryWriter writer, Settings obj) {
    writer.writeBool(obj.soundEnabled);
    writer.writeBool(obj.workStartEnabled);
    writer.writeBool(obj.restStartEnabled);
    writer.writeBool(obj.warmupStartEnabled);
    writer.writeBool(obj.cooldownStartEnabled);
    writer.writeBool(obj.countdownEnabled);
    writer.writeBool(obj.completionEnabled);
    writer.writeDouble(obj.volume);
  }
}
