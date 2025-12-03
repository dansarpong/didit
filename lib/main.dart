import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'theme/app_theme.dart';
import 'providers/workout_provider.dart';
import 'providers/settings_provider.dart';
import 'screens/main_screen.dart';
import 'models/workout_model.dart';
import 'models/settings_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  
  // Register Adapters
  Hive.registerAdapter(WorkoutAdapter());
  Hive.registerAdapter(ExerciseAdapter());
  Hive.registerAdapter(IntervalAdapter());
  Hive.registerAdapter(IntervalTypeAdapter());
  Hive.registerAdapter(WorkoutHistoryAdapter());
  Hive.registerAdapter(SettingsAdapter());


  
  await Hive.openBox<Workout>('workouts');
  await Hive.openBox<WorkoutHistory>('history');

  runApp(const DiditApp());
}

class DiditApp extends StatelessWidget {
  const DiditApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WorkoutProvider()),
        ChangeNotifierProvider(
          create: (_) => SettingsProvider()..initialize(),
        ),
      ],
      child: MaterialApp(
        title: 'DIDIT',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const MainScreen(),
      ),
    );
  }
}
