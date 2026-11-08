import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:clone/main.dart';
import 'package:clone/widgets/task_tile.dart';

void main() {
  testWidgets('Exercise 12.4 — Final Optimization & Release Verification Test',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const TasklyApp());
    await tester.pumpAndSettle();

    // Verify Taskly title
    expect(find.text('Taskly — Exercise 12.4'), findsOneWidget);

    // Verify precached logo image is displayed
    expect(find.byType(Image), findsOneWidget);

    // Verify optimized TaskTile widgets are rendered
    expect(find.byType(TaskTile), findsWidgets);

    // Verify adding a task in release-ready mode
    final inputField = find.byType(TextField);
    expect(inputField, findsOneWidget);

    await tester.enterText(inputField, 'Production Ready Task');
    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();

    expect(find.text('Production Ready Task'), findsOneWidget);
  });
}
