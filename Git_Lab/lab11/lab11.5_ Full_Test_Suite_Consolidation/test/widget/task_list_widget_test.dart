import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:clone/repositories/task_repository.dart';
import 'package:clone/screens/task_list_screen.dart';

void main() {
  group('TaskListScreen Widget Tests', () {
    late TaskRepository repository;

    setUp(() {
      repository = TaskRepository();
    });

    Widget createWidgetUnderTest() {
      return MaterialApp(
        home: TaskListScreen(repository: repository),
      );
    }

    testWidgets('Empty State: displays "No tasks yet. Add one!" when list is empty',
        (WidgetTester tester) async {
      // Act: Pump the widget tree with an empty repository
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert: Verify empty state text is rendered
      expect(find.text('No tasks yet. Add one!'), findsOneWidget);
    });

    testWidgets('Add Task: enter text -> tap add -> verify UI updates',
        (WidgetTester tester) async {
      // Arrange: Pump widget tree
      await tester.pumpWidget(createWidgetUnderTest());
      expect(find.text('No tasks yet. Add one!'), findsOneWidget);

      // Act: Enter text into input field
      final inputFinder = find.byKey(const Key('taskInputField'));
      await tester.enterText(inputFinder, 'Read Flutter Documentation');

      // Act: Tap add button and trigger a frame rebuild with pump()
      final addButtonFinder = find.byKey(const Key('addTaskButton'));
      await tester.tap(addButtonFinder);
      await tester.pump();

      // Assert: Verify UI updates with the new task and empty state disappears
      expect(find.text('Read Flutter Documentation'), findsOneWidget);
      expect(find.text('No tasks yet. Add one!'), findsNothing);
      expect(repository.tasks.length, equals(1));
      expect(repository.tasks.first.title, equals('Read Flutter Documentation'));
    });

    testWidgets('Multiple Tasks: add two tasks -> verify both visible',
        (WidgetTester tester) async {
      // Arrange: Pump widget tree
      await tester.pumpWidget(createWidgetUnderTest());

      final inputFinder = find.byKey(const Key('taskInputField'));
      final addButtonFinder = find.byKey(const Key('addTaskButton'));

      // Act: Add first task
      await tester.enterText(inputFinder, 'Task Alpha');
      await tester.tap(addButtonFinder);
      await tester.pump();

      // Act: Add second task
      await tester.enterText(inputFinder, 'Task Beta');
      await tester.tap(addButtonFinder);
      await tester.pump();

      // Assert: Verify both tasks are visible on the screen
      expect(find.text('Task Alpha'), findsOneWidget);
      expect(find.text('Task Beta'), findsOneWidget);
      expect(repository.tasks.length, equals(2));
    });
  });
}
