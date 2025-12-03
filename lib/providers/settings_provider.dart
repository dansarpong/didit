import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/settings_model.dart';

class SettingsProvider extends ChangeNotifier {
  static const String _boxName = 'settings';
  Settings? _settings;

  Settings get settings => _settings ?? Settings();

  Future<void> initialize() async {
    final box = await Hive.openBox<Settings>(_boxName);
    if (box.isEmpty) {
      _settings = Settings();
      await box.add(_settings!);
      await _settings!.save();
    } else {
      _settings = box.getAt(0);
    }
    notifyListeners();
  }

  Future<void> updateSoundEnabled(bool value) async {
    _settings?.soundEnabled = value;
    await _settings?.save();
    notifyListeners();
  }

  Future<void> updateWorkStartEnabled(bool value) async {
    _settings?.workStartEnabled = value;
    await _settings?.save();
    notifyListeners();
  }

  Future<void> updateRestStartEnabled(bool value) async {
    _settings?.restStartEnabled = value;
    await _settings?.save();
    notifyListeners();
  }

  Future<void> updateWarmupStartEnabled(bool value) async {
    _settings?.warmupStartEnabled = value;
    await _settings?.save();
    notifyListeners();
  }

  Future<void> updateCooldownStartEnabled(bool value) async {
    _settings?.cooldownStartEnabled = value;
    await _settings?.save();
    notifyListeners();
  }

  Future<void> updateCountdownEnabled(bool value) async {
    _settings?.countdownEnabled = value;
    await _settings?.save();
    notifyListeners();
  }

  Future<void> updateCompletionEnabled(bool value) async {
    _settings?.completionEnabled = value;
    await _settings?.save();
    notifyListeners();
  }

  Future<void> updateVolume(double value) async {
    _settings?.volume = value;
    await _settings?.save();
    notifyListeners();
  }
}
