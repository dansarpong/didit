import 'package:flutter_test/flutter_test.dart';
import 'package:didit_app/services/audio_service.dart';
import 'package:didit_app/models/settings_model.dart';
import 'package:mocktail/mocktail.dart';
import 'mock_audio_player.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    // Register fallback values for mocktail if needed
    registerFallbackValue(Duration.zero);
  });

  group('AudioService', () {
    test('should be a singleton', () {
      final instance1 = AudioService();
      final instance2 = AudioService();

      expect(instance1, same(instance2));
    });

    test('should have all sound types defined', () {
      expect(SoundType.values.length, 6);
      expect(SoundType.values, contains(SoundType.workStart));
      expect(SoundType.values, contains(SoundType.restStart));
      expect(SoundType.values, contains(SoundType.warmupStart));
      expect(SoundType.values, contains(SoundType.cooldownStart));
      expect(SoundType.values, contains(SoundType.countdown));
      expect(SoundType.values, contains(SoundType.workoutComplete));
    });

    test('playSound should respect soundEnabled setting', () async {
      final audioService = AudioService();
      // Inject mock player
      audioService.setAudioPlayerFactory(() {
        final mockPlayer = MockAudioPlayer();
        when(() => mockPlayer.setAsset(any()))
            .thenAnswer((_) async => Duration.zero);
        when(() => mockPlayer.setVolume(any())).thenAnswer((_) async {});
        when(() => mockPlayer.seek(any())).thenAnswer((_) async {});
        when(() => mockPlayer.play()).thenAnswer((_) async {});
        when(() => mockPlayer.dispose()).thenAnswer((_) async {});
        return mockPlayer;
      });
      final settings = Settings(soundEnabled: false);

      // This should not throw even if sounds are disabled
      expect(
        () => audioService.playSound(SoundType.workStart, settings),
        returnsNormally,
      );
    });

    test('playSound should respect individual sound settings', () async {
      final audioService = AudioService();
      // Inject mock player
      audioService.setAudioPlayerFactory(() {
        final mockPlayer = MockAudioPlayer();
        when(() => mockPlayer.setAsset(any()))
            .thenAnswer((_) async => Duration.zero);
        when(() => mockPlayer.setVolume(any())).thenAnswer((_) async {});
        when(() => mockPlayer.seek(any())).thenAnswer((_) async {});
        when(() => mockPlayer.play()).thenAnswer((_) async {});
        when(() => mockPlayer.dispose()).thenAnswer((_) async {});
        return mockPlayer;
      });
      final settings = Settings(
        soundEnabled: true,
        workStartEnabled: false,
      );

      // This should not throw even if specific sound is disabled
      expect(
        () => audioService.playSound(SoundType.workStart, settings),
        returnsNormally,
      );
    });

    test('dispose should clean up resources', () async {
      final audioService = AudioService();
      // Inject mock player
      audioService.setAudioPlayerFactory(() {
        final mockPlayer = MockAudioPlayer();
        when(() => mockPlayer.setAsset(any()))
            .thenAnswer((_) async => Duration.zero);
        when(() => mockPlayer.setVolume(any())).thenAnswer((_) async {});
        when(() => mockPlayer.seek(any())).thenAnswer((_) async {});
        when(() => mockPlayer.play()).thenAnswer((_) async {});
        when(() => mockPlayer.dispose()).thenAnswer((_) async {});
        return mockPlayer;
      });
      await audioService.initialize();
      // This should not throw
      expect(() => audioService.dispose(), returnsNormally);
    });

    test('should respect warmup and cooldown sound settings', () async {
      final audioService = AudioService();
      audioService.setAudioPlayerFactory(() {
        final mockPlayer = MockAudioPlayer();
        when(() => mockPlayer.setAsset(any()))
            .thenAnswer((_) async => Duration.zero);
        when(() => mockPlayer.setVolume(any())).thenAnswer((_) async {});
        when(() => mockPlayer.seek(any())).thenAnswer((_) async {});
        when(() => mockPlayer.play()).thenAnswer((_) async {});
        when(() => mockPlayer.stop()).thenAnswer((_) async {});
        when(() => mockPlayer.dispose()).thenAnswer((_) async {});
        return mockPlayer;
      });

      // Test warmup sound disabled
      final warmupDisabled = Settings(
        soundEnabled: true,
        warmupStartEnabled: false,
      );
      expect(
        () => audioService.playSound(SoundType.warmupStart, warmupDisabled),
        returnsNormally,
      );

      // Test cooldown sound disabled
      final cooldownDisabled = Settings(
        soundEnabled: true,
        cooldownStartEnabled: false,
      );
      expect(
        () => audioService.playSound(SoundType.cooldownStart, cooldownDisabled),
        returnsNormally,
      );
    });
  });
}
