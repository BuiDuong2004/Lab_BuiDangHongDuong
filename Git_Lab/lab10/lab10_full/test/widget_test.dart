import 'package:flutter_test/flutter_test.dart';
import 'package:lab10_full/main.dart';

void main() {
  testWidgets('SplashScreen smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify splash text exists
    expect(find.text('Lab 10 - Final Project'), findsOneWidget);
    expect(find.text('Authentication & Local Notification'), findsOneWidget);
  });
}
