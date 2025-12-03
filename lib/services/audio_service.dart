import 'package:just_audio/just_audio.dart';
import '../models/settings_model.dart';

enum SoundType {
  workStart,
  restStart,
  warmupStart,
  cooldownStart,
  countdown,
  workoutComplete,
}

class AudioService {
  // Singleton pattern
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  // Audio players for each sound type
  final Map<SoundType, AudioPlayer> _players = {};
  bool _isInitialized = false;

  // Factory for creating AudioPlayer, can be overridden in tests
  AudioPlayer Function()? _audioPlayerFactory;

  // Asset paths
  static const Map<SoundType, String> _assetPaths = {
    SoundType.workStart: 'assets/sounds/beep.mp3',
    SoundType.restStart: 'assets/sounds/start.mp3',
    SoundType.warmupStart: 'assets/sounds/beep.mp3',
    SoundType.cooldownStart: 'assets/sounds/start.mp3',
    SoundType.countdown: 'assets/sounds/beep.mp3',
    SoundType.workoutComplete: 'assets/sounds/complete.mp3',
  };

  // Allow setting a custom AudioPlayer factory (for testing)
  void setAudioPlayerFactory(AudioPlayer Function() factory) {
    _audioPlayerFactory = factory;
  }

  Future<void> initialize() async {
    if (_isInitialized) return;

    // Create audio players for each sound type
    for (final soundType in SoundType.values) {
      final player = (_audioPlayerFactory != null)
          ? _audioPlayerFactory!()
          : AudioPlayer();
      final assetPath = _assetPaths[soundType]!;
      try {
        await player.setAsset(assetPath);
        _players[soundType] = player;
      } catch (e) {
        // Asset loading failed, continue without this sound
      }
    }

    _isInitialized = true;
  }

  Future<void> playSound(SoundType soundType, Settings settings) async {
    if (!_isInitialized) {
      await initialize();
    }

    // Check if sounds are globally enabled
    if (!settings.soundEnabled) return;

    // Check individual sound preferences
    bool shouldPlay = switch (soundType) {
      SoundType.workStart => settings.workStartEnabled,
      SoundType.restStart => settings.restStartEnabled,
      SoundType.warmupStart => settings.warmupStartEnabled,
      SoundType.cooldownStart => settings.cooldownStartEnabled,
      SoundType.countdown => settings.countdownEnabled,
      SoundType.workoutComplete => settings.completionEnabled,
    };

    if (!shouldPlay) return;

    final player = _players[soundType];
    if (player == null) return;

    try {
      // Stop the player first to reset its state
      await player.stop();
      
      // Set volume
      await player.setVolume(settings.volume);

      // Seek to start and play
      await player.seek(Duration.zero);
      await player.play();
    } catch (e) {
      // Sound playback failed, continue silently
    }
  }

  Future<void> dispose() async {
    for (final player in _players.values) {
      await player.dispose();
    }
    _players.clear();
    _isInitialized = false;
  }
}
