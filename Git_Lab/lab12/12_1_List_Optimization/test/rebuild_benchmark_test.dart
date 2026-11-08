import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:clone/main.dart';
import 'package:clone/widgets/task_tile.dart';

void main() {
  testWidgets('Verify Rebuild Isolation with Selector and ValueKey',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const TasklyApp());
    await tester.pumpAndSettle();

    // Verify initial state
    expect(find.byType(TaskTile), findsWidgets);
    expect(find.text('Rebuilds: 1'), findsWidgets);

    // Toggle Task 1 checkbox
    final task1Checkbox = find.descendant(
      of: find.byKey(const ValueKey('1')),
      matching: find.byType(Checkbox),
    );
    expect(task1Checkbox, findsOneWidget);

    await tester.tap(task1Checkbox);
    await tester.pumpAndSettle();

    // Verify that Task 1 rebuilt (Rebuilds: 2)
    final task1Tile = find.byKey(const ValueKey('1'));
    expect(
      find.descendant(of: task1Tile, matching: find.text('Rebuilds: 2')),
      findsOneWidget,
    );

    // Verify that Task 2 did NOT rebuild (still Rebuilds: 1)
    final task2Tile = find.byKey(const ValueKey('2'));
    expect(
      find.descendant(of: task2Tile, matching: find.text('Rebuilds: 1')),
      findsOneWidget,
    );
  });
}
