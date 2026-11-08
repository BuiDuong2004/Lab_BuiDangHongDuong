// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:lab9/screens/lab92_storage_screen.dart';
import 'package:lab9/screens/lab93_crud_screen.dart';

const _pathProviderChannel = MethodChannel('plugins.flutter.io/path_provider');

late Directory _documentsDirectory;

void main() {
  setUp(() async {
    _documentsDirectory = await Directory.systemTemp.createTemp('lab9-test-');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_pathProviderChannel, (call) async {
      if (call.method == 'getApplicationDocumentsDirectory') {
        return _documentsDirectory.path;
      }

      return null;
    });
  });

  tearDown(() async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_pathProviderChannel, null);
    await _documentsDirectory.delete(recursive: true);
  });

  testWidgets('Lab 9.2 saves items and loads them again', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Lab92StorageScreen()),
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'Học Flutter');
    await tester.tap(find.byTooltip('Thêm mục').first);
    await tester.pumpAndSettle();
    expect(find.text('Học Flutter'), findsOneWidget);

    await tester.tap(find.text('Lưu dữ liệu JSON'));
    await tester.pumpAndSettle();

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpWidget(
      const MaterialApp(home: Lab92StorageScreen()),
    );
    await tester.pumpAndSettle();

    expect(find.text('Học Flutter'), findsOneWidget);
  });

  testWidgets('Lab 9.3 creates, updates, and deletes items', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Lab93CrudScreen()),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Thêm mục'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).last, 'Alice');
    await tester.tap(find.text('Lưu'));
    await tester.pumpAndSettle();
    expect(find.text('Alice'), findsOneWidget);

    await tester.tap(find.byTooltip('Sửa'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).last, 'Alicia');
    await tester.tap(find.text('Lưu'));
    await tester.pumpAndSettle();
    expect(find.text('Alicia'), findsOneWidget);

    await tester.tap(find.byTooltip('Xóa'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Xóa'));
    await tester.pumpAndSettle();
    expect(find.text('Không có dữ liệu phù hợp.'), findsOneWidget);
  });
}
