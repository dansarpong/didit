import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:didit_app/models/settings_model.dart';
import 'package:didit_app/providers/settings_provider.dart';

void main() {
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp();
    Hive.init(tempDir.path);
    if (!Hive.isAdapterRegistered(5)) {
      Hive.registerAdapter(SettingsAdapter());
    }
  });

  tearDown(() async {
    await Hive.deleteFromDisk();
    await tempDir.delete(recursive: true);
  });

  group('SettingsProvider', () {
    test('initialize creates default settings if box is empty', () async {
      final provider = SettingsProvider();
      await provider.initialize();

      expect(provider.settings.soundEnabled, true);
      expect(provider.settings.volume, 0.8);
      
      // Verify persistence
      final box = await Hive.openBox<Settings>('settings');
      expect(box.length, 1);
      expect(box.getAt(0)!.soundEnabled, true);
    });

    test('initialize loads existing settings', () async {
      final box = await Hive.openBox<Settings>('settings');
      final settings = Settings(soundEnabled: false, volume: 0.5);
      await box.add(settings);

      final provider = SettingsProvider();
      await provider.initialize();

      expect(provider.settings.soundEnabled, false);
      expect(provider.settings.volume, 0.5);
    });

    test('updateSoundEnabled persists changes', () async {
      final provider = SettingsProvider();
      await provider.initialize();

      await provider.updateSoundEnabled(false);

      expect(provider.settings.soundEnabled, false);

      // Verify persistence
      final box = await Hive.openBox<Settings>('settings');
      expect(box.getAt(0)!.soundEnabled, false);
    });

    test('updateVolume persists changes', () async {
      final provider = SettingsProvider();
      await provider.initialize();

      await provider.updateVolume(0.2);

      expect(provider.settings.volume, 0.2);

      // Verify persistence
      final box = await Hive.openBox<Settings>('settings');
      expect(box.getAt(0)!.volume, 0.2);
    });
    
    test('updateWorkStartEnabled persists changes', () async {
      final provider = SettingsProvider();
      await provider.initialize();

      await provider.updateWorkStartEnabled(false);

      expect(provider.settings.workStartEnabled, false);
      
      final box = await Hive.openBox<Settings>('settings');
      expect(box.getAt(0)!.workStartEnabled, false);
    });
  });
}
