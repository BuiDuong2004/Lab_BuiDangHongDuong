import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:clone/main.dart';
import 'package:clone/widgets/task_tile.dart';

void main() {
  testWidgets('Exercise 12.1 — TaskTile extraction and ValueKey test',
      (WidgetTester tester) async {
    // Set a larger test surface to avoid scrolling issues
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const TasklyApp());
    await tester.pumpAndSettle();

    // Verify Taskly title
    expect(find.text('Taskly — Exercise 12.1'), findsOneWidget);

    // Verify extracted TaskTile widgets are rendered
    expect(find.byType(TaskTile), findsWidgets);

    // Verify ValueKey existence on task items
    expect(find.byKey(const ValueKey('1')), findsOneWidget);
    expect(find.byKey(const ValueKey('2')), findsOneWidget);

    // Verify Add Task functionality
    final inputField = find.byType(TextField);
    expect(inputField, findsOneWidget);

    await tester.enterText(inputField, 'New Test Optimization Task');
    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();

    expect(find.text('New Test Optimization Task'), findsOneWidget);
  });
}
