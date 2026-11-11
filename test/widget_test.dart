// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:baocaotuan15/main.dart';

void main() {
  testWidgets('State updates UI when pressing +1 button', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: MainScreen()),
    );

    expect(find.text('Giá trị State hiện tại: 0'), findsOneWidget);

    await tester.tap(find.text('Bấm để gọi setState() (+1)'));
    await tester.pump();

    expect(find.text('Giá trị State hiện tại: 1'), findsOneWidget);
  });
}
