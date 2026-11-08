import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:clone/models/task.dart';
import 'package:clone/repositories/task_repository.dart';
import 'package:clone/screens/task_list_screen.dart';

void main() {
  group('Task Navigation Tests: Task List -> Task Detail', () {
    late TaskRepository repository;

    setUp(() {
      repository = TaskRepository();
    });

    testWidgets('Tap seeded task in TaskListScreen navigates to TaskDetailScreen',
        (WidgetTester tester) async {
      // Step 1: Seed repository with at least one task
      final seededTask = Task(
        id: 'seed-task-1',
        title: 'Review PRM393 Navigation Lecture',
        completed: false,
      );
      repository.addTask(seededTask);

      // Step 2: Pump TaskListScreen inside MaterialApp
      await tester.pumpWidget(
        MaterialApp(
          home: TaskListScreen(repository: repository),
        ),
      );

      // Verify seeded task is displayed in list
      expect(find.text('Review PRM393 Navigation Lecture'), findsOneWidget);

      // Step 3: Tap seeded task -> call pumpAndSettle() to complete navigation transition
      await tester.tap(find.text('Review PRM393 Navigation Lecture'));
      await tester.pumpAndSettle();

      // Step 4: Validate navigation result
      // - AppBar title: "Task Detail"
      expect(
        find.descendant(
          of: find.byType(AppBar),
          matching: find.text('Task Detail'),
        ),
        findsOneWidget,
        reason: 'AppBar title must be "Task Detail"',
      );

      // - TextField key: detailTitleField
      final detailFieldFinder = find.byKey(const Key('detailTitleField'));
      expect(
        detailFieldFinder,
        findsOneWidget,
        reason: 'Detail screen must contain TextField with key "detailTitleField"',
      );

      // Verify the TextField contains the seeded task title
      final textField = tester.widget<TextField>(detailFieldFinder);
      expect(textField.controller?.text, equals('Review PRM393 Navigation Lecture'));
    });

    testWidgets('Pop back from TaskDetailScreen returns to TaskListScreen',
        (WidgetTester tester) async {
      // Seed task
      final seededTask = Task(id: 'seed-task-2', title: 'Navigation Return Test');
      repository.addTask(seededTask);

      // Pump screen
      await tester.pumpWidget(
        MaterialApp(
          home: TaskListScreen(repository: repository),
        ),
      );

      // Tap to navigate
      await tester.tap(find.text('Navigation Return Test'));
      await tester.pumpAndSettle();
      expect(find.text('Task Detail'), findsOneWidget);

      // Tap back button
      final backButton = find.byTooltip('Back');
      if (backButton.evaluate().isNotEmpty) {
        await tester.tap(backButton);
      } else {
        await tester.tap(find.byType(BackButton));
      }
      await tester.pumpAndSettle();

      // Verify returned to Taskly list
      expect(find.text('Taskly'), findsOneWidget);
      expect(find.text('Navigation Return Test'), findsOneWidget);
    });
  });
}
