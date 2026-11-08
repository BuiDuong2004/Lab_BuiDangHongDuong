import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:clone/main.dart';

void main() {
  testWidgets('Exercise 12.2 — Asset Optimization & Pre-cache Test',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const TasklyApp());
    await tester.pumpAndSettle();

    // Verify Taskly title for Exercise 12.2
    expect(find.text('Taskly — Exercise 12.2'), findsOneWidget);

    // Verify the Image.asset widget is present in the AppBar
    expect(find.byType(Image), findsOneWidget);

    // Verify dialog with Before & After asset comparison opens
    final infoButton = find.byIcon(Icons.photo_library_outlined);
    expect(infoButton, findsOneWidget);
    await tester.tap(infoButton);
    await tester.pumpAndSettle();

    expect(find.text('Exercise 12.2 — Asset Optimization'), findsOneWidget);
    expect(find.text('Before & After Asset Comparison:'), findsOneWidget);
    expect(find.text('task_logo_opt.png'), findsOneWidget);
  });
}
