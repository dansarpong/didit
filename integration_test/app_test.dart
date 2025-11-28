import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:didit_app/main.dart';
import 'package:integration_test/integration_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:didit_app/models/workout_model.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    final tempDir = await getTemporaryDirectory();
    final testPath = p.join(
        tempDir.path, 'hive_test_${DateTime.now().millisecondsSinceEpoch}');
    await Hive.initFlutter(testPath);
    Hive.registerAdapter(WorkoutAdapter());
    Hive.registerAdapter(IntervalAdapter());
    Hive.registerAdapter(ExerciseAdapter());
    Hive.registerAdapter(IntervalTypeAdapter());
  });

  group('HIIT App Integration Tests', () {
    testWidgets('Create workout with warmup, work/rest, and cooldown',
        (tester) async {
      await tester.pumpWidget(const DiditApp());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Tap create workout button
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // Enter workout name
      await tester.enterText(
          find.byType(TextFormField).first, 'Full Workout Test');
      await tester.pumpAndSettle();

      // Add warmup interval
      await tester.tap(find.text('Warmup'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Add'));
      await tester.pumpAndSettle();

      // Add work interval
      await tester.tap(find.text('Work'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Add'));
      await tester.pumpAndSettle();

      // Add rest interval
      await tester.tap(find.text('Rest'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Add'));
      await tester.pumpAndSettle();

      // Add cooldown interval
      await tester.tap(find.text('Cooldown'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Add'));
      await tester.pumpAndSettle();

      // Save workout
      await tester.tap(find.byIcon(Icons.check));
      await tester.pumpAndSettle();

      // Verify workout appears in list
      expect(find.text('Full Workout Test'), findsWidgets);
    });

    testWidgets('Edit existing workout', (tester) async {
      await tester.pumpWidget(const DiditApp());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Create workout
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).first, 'Original Name');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Work'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Add'));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.check));
      await tester.pumpAndSettle();

      // Ensure the workout appears before proceeding
      expect(find.text('Original Name'), findsWidgets);

      // Open menu and edit
      await tester.tap(find.byKey(const ValueKey('more-Original Name')));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Edit'));
      await tester.pumpAndSettle();

      // Verify in edit mode
      expect(find.text('Edit Workout'), findsOneWidget);

      // Change name
      final nameField = find.byType(TextFormField).first;
      await tester.tap(nameField);
      await tester.pumpAndSettle();
      await tester.enterText(nameField, 'Edited Name');
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.check));
      await tester.pumpAndSettle();

      // Verify name changed
      expect(find.text('Edited Name'), findsOneWidget);
      expect(find.text('Original Name'), findsNothing);
    });

    testWidgets('Duplicate workout', (tester) async {
      await tester.pumpWidget(const DiditApp());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Create workout
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).first, 'To Duplicate');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Work'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Add'));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.check));
      await tester.pumpAndSettle();

      // Ensure the workout appears before proceeding
      expect(find.text('To Duplicate'), findsWidgets);

      // Duplicate
      await tester.tap(find.byKey(const ValueKey('more-To Duplicate')));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Duplicate'));
      await tester.pumpAndSettle();

      // Verify both workouts exist
      expect(find.text('To Duplicate'), findsWidgets);
      expect(find.text('To Duplicate (Copy)'), findsWidgets);
    });

    testWidgets('Delete workout', (tester) async {
      await tester.pumpWidget(const DiditApp());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Create workout
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).first, 'To Delete');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Work'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Add'));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.check));
      await tester.pumpAndSettle();

      // Ensure the workout appears before proceeding
      expect(find.text('To Delete'), findsWidgets);

      // Delete
      await tester.tap(find.byKey(const ValueKey('more-To Delete')));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      // Verify deleted
      expect(find.text('To Delete'), findsNothing);
    });
  });
}
