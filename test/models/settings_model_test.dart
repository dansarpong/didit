import 'package:flutter_test/flutter_test.dart';
import 'package:didit_app/models/settings_model.dart';

void main() {
  group('Settings Model', () {
    test('should have default values', () {
      final settings = Settings();

      expect(settings.soundEnabled, true);
      expect(settings.workStartEnabled, true);
      expect(settings.restStartEnabled, true);
      expect(settings.warmupStartEnabled, true);
      expect(settings.cooldownStartEnabled, true);
      expect(settings.countdownEnabled, true);
      expect(settings.completionEnabled, true);
      expect(settings.volume, 0.8);
    });

    test('should create copy with updated values', () {
      final settings = Settings();
      final updated = settings.copyWith(
        soundEnabled: false,
        volume: 0.5,
      );

      expect(updated.soundEnabled, false);
      expect(updated.volume, 0.5);
      // Other values should remain unchanged
      expect(updated.workStartEnabled, true);
      expect(updated.restStartEnabled, true);
    });

    test('should create copy with all values updated', () {
      final settings = Settings();
      final updated = settings.copyWith(
        soundEnabled: false,
        workStartEnabled: false,
        restStartEnabled: false,
        warmupStartEnabled: false,
        cooldownStartEnabled: false,
        countdownEnabled: false,
        completionEnabled: false,
        volume: 0.3,
      );

      expect(updated.soundEnabled, false);
      expect(updated.workStartEnabled, false);
      expect(updated.restStartEnabled, false);
      expect(updated.warmupStartEnabled, false);
      expect(updated.cooldownStartEnabled, false);
      expect(updated.countdownEnabled, false);
      expect(updated.completionEnabled, false);
      expect(updated.volume, 0.3);
    });

    test('should handle volume edge cases', () {
      final settings1 = Settings(volume: 0.0);
      expect(settings1.volume, 0.0);

      final settings2 = Settings(volume: 1.0);
      expect(settings2.volume, 1.0);
    });
  });
}
