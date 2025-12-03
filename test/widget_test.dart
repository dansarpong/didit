import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:didit_app/main.dart';
import 'package:didit_app/models/workout_model.dart';
import 'package:didit_app/models/settings_model.dart';

void main() {
  setUpAll(() async {
    // Create a temporary directory for Hive
    final tempDir = await Directory.systemTemp.createTemp();
    Hive.init(tempDir.path);
    
    // Register Adapters
    if (!Hive.isAdapterRegistered(1)) Hive.registerAdapter(WorkoutAdapter());
    if (!Hive.isAdapterRegistered(2)) Hive.registerAdapter(ExerciseAdapter());
    if (!Hive.isAdapterRegistered(3)) Hive.registerAdapter(IntervalAdapter());
    if (!Hive.isAdapterRegistered(4)) Hive.registerAdapter(IntervalTypeAdapter());
    if (!Hive.isAdapterRegistered(5)) Hive.registerAdapter(WorkoutHistoryAdapter());
    if (!Hive.isAdapterRegistered(6)) Hive.registerAdapter(SettingsAdapter());
  });

  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const DiditApp());

    // Verify that the app builds successfully
    expect(find.byType(MaterialApp), findsOneWidget);
    
    // Allow animations to settle
    await tester.pumpAndSettle();
  });
}
