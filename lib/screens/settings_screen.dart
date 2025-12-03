import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../services/audio_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(16.0),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: 20),
                  Text(
                    'DIDIT',
                    style: Theme.of(context).textTheme.displayLarge,
                  ).animate().fadeIn().slideX(),
                  Text(
                    'Settings',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ).animate().fadeIn(delay: 200.ms).slideX(),
                  const SizedBox(height: 30),
                ]),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                // Audio Settings Section
                _buildSectionHeader(context, 'Audio'),
                Consumer<SettingsProvider>(
                  builder: (context, settingsProvider, child) {
                    final settings = settingsProvider.settings;
                    
                    return Column(
                      children: [
                        // Master sound toggle
                        SwitchListTile(
                          secondary: Icon(
                            settings.soundEnabled ? Icons.volume_up : Icons.volume_off,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          title: const Text('Sound Effects'),
                          subtitle: Text(settings.soundEnabled ? 'Enabled' : 'Disabled'),
                          value: settings.soundEnabled,
                          onChanged: (value) => settingsProvider.updateSoundEnabled(value),
                        ),
                        
                        // Volume slider
                        if (settings.soundEnabled) ...[
                          ListTile(
                            leading: Icon(
                              Icons.volume_down,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            title: const Text('Volume'),
                            subtitle: Slider(
                              value: settings.volume,
                              min: 0.0,
                              max: 1.0,
                              divisions: 10,
                              label: '${(settings.volume * 100).round()}%',
                              onChanged: (value) => settingsProvider.updateVolume(value),
                            ),
                            trailing: Text('${(settings.volume * 100).round()}%'),
                          ),
                          
                          const Divider(indent: 16, endIndent: 16),
                          
                          // Individual sound toggles
                          _buildSoundToggle(
                            context,
                            settingsProvider,
                            'Work Interval Start',
                            settings.workStartEnabled,
                            Icons.fitness_center,
                            (value) => settingsProvider.updateWorkStartEnabled(value),
                            SoundType.workStart,
                          ),
                          _buildSoundToggle(
                            context,
                            settingsProvider,
                            'Rest Interval Start',
                            settings.restStartEnabled,
                            Icons.self_improvement,
                            (value) => settingsProvider.updateRestStartEnabled(value),
                            SoundType.restStart,
                          ),
                          _buildSoundToggle(
                            context,
                            settingsProvider,
                            'Warmup Interval Start',
                            settings.warmupStartEnabled,
                            Icons.wb_sunny,
                            (value) => settingsProvider.updateWarmupStartEnabled(value),
                            SoundType.warmupStart,
                          ),
                          _buildSoundToggle(
                            context,
                            settingsProvider,
                            'Cooldown Interval Start',
                            settings.cooldownStartEnabled,
                            Icons.ac_unit,
                            (value) => settingsProvider.updateCooldownStartEnabled(value),
                            SoundType.cooldownStart,
                          ),
                          _buildSoundToggle(
                            context,
                            settingsProvider,
                            'Countdown Beeps',
                            settings.countdownEnabled,
                            Icons.timer,
                            (value) => settingsProvider.updateCountdownEnabled(value),
                            SoundType.countdown,
                          ),
                          _buildSoundToggle(
                            context,
                            settingsProvider,
                            'Workout Completion',
                            settings.completionEnabled,
                            Icons.celebration,
                            (value) => settingsProvider.updateCompletionEnabled(value),
                            SoundType.workoutComplete,
                          ),
                        ],
                      ],
                    );
                  },
                ),
                
                const SizedBox(height: 24),
                _buildSectionHeader(context, 'Preferences'),
                ListTile(
                  leading: const Icon(Icons.palette_outlined),
                  title: const Text('Theme'),
                  subtitle: const Text('Dark mode'),
                  onTap: () {},
                ),
                _buildSectionHeader(context, 'App Info'),
                const ListTile(
                  leading: Icon(Icons.info_outline),
                  title: Text('About DIDIT'),
                  subtitle: Text('Version 1.0.0'),
                ),
                const SizedBox(height: 40),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
      ),
    );
  }

  Widget _buildSoundToggle(
    BuildContext context,
    SettingsProvider settingsProvider,
    String title,
    bool value,
    IconData icon,
    Function(bool) onChanged,
    SoundType soundType,
  ) {
    return ListTile(
      leading: Icon(icon, size: 20),
      title: Text(title),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Test button
          IconButton(
            icon: const Icon(Icons.play_circle_outline, size: 20),
            tooltip: 'Test sound',
            onPressed: value
                ? () {
                    AudioService().playSound(
                      soundType,
                      settingsProvider.settings,
                    );
                  }
                : null,
          ),
          // Toggle switch
          Switch(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
