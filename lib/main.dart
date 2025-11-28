import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'theme/app_theme.dart';
import 'providers/workout_provider.dart';
import 'screens/home_screen.dart';
import 'models/workout_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  
  // Register Adapters
  Hive.registerAdapter(WorkoutAdapter());
  Hive.registerAdapter(ExerciseAdapter());
  Hive.registerAdapter(IntervalAdapter());
  Hive.registerAdapter(IntervalTypeAdapter());

  // Clear box for data migration (dev mode)
  if (await Hive.boxExists('workouts')) {
    await Hive.deleteBoxFromDisk('workouts');
  }
  
  await Hive.openBox<Workout>('workouts');

  runApp(const DiditApp());
}

class DiditApp extends StatelessWidget {
  const DiditApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WorkoutProvider()),
      ],
      child: MaterialApp(
        title: 'DIDIT',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const HomeScreen(),
      ),
    );
  }
}
