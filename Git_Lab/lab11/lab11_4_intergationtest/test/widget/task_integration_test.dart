import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:clone/main.dart';
import 'package:clone/repositories/task_repository.dart';

void main() {
  group('Taskly End-to-End Integration Flow', () {
    late TaskRepository repository;

    setUp(() {
      repository = TaskRepository();
    });

    testWidgets('Full flow: Add "Original title" -> Open detail -> Edit to "Updated title" -> Save -> Verify in list',
        (WidgetTester tester) async {
      // Step 1: Pump the full TasklyApp
      await tester.pumpWidget(TasklyApp(repository: repository));
      expect(find.text('Taskly'), findsOneWidget);
      expect(find.text('No tasks yet. Add one!'), findsOneWidget);

      // Step 2: Add "Original title"
      final inputField = find.byKey(const Key('taskInputField'));
      final addButton = find.byKey(const Key('addTaskButton'));

      await tester.enterText(inputField, 'Original title');
      await tester.tap(addButton);
      await tester.pumpAndSettle();

      // Step 3: Verify "Original title" is rendered in task list
      expect(find.text('Original title'), findsOneWidget);
      expect(find.text('No tasks yet. Add one!'), findsNothing);

      // Step 4: Tap task -> open detail
      await tester.tap(find.text('Original title'));
      await tester.pumpAndSettle();

      // Step 5: Verify detail screen is open
      expect(find.text('Task Detail'), findsOneWidget);
      final detailField = find.byKey(const Key('detailTitleField'));
      expect(detailField, findsOneWidget);

      // Step 6: Edit -> "Updated title"
      await tester.enterText(detailField, 'Updated title');
      await tester.pumpAndSettle();

      // Step 7: Save
      final saveButton = find.widgetWithText(ElevatedButton, 'Save');
      expect(saveButton, findsOneWidget);
      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      // Step 8: Verify updated title appears in list and original title is gone
      expect(find.text('Task Detail'), findsNothing);
      expect(find.text('Updated title'), findsOneWidget);
      expect(find.text('Original title'), findsNothing);

      // Assert repository state
      expect(repository.tasks.length, equals(1));
      expect(repository.tasks.first.title, equals('Updated title'));
    });
  });
}
