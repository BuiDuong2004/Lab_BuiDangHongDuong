import 'package:flutter_test/flutter_test.dart';
import 'package:lab10_5_notification/main.dart';

void main() {
  testWidgets('NotificationHomeScreen loads properly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify header title exists
    expect(find.text('Lab 10.5 - Local Notification (LO7)'), findsOneWidget);
    expect(find.text('Tích Hợp Local Notification (LO7)'), findsOneWidget);
  });
}
