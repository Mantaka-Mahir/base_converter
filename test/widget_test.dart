// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:untitled1/main.dart';

void main() {
  testWidgets('Base converter app loads test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const BaseConversionApp());

    // Verify that the app loads with expected UI elements
    expect(find.text('Number System Converter'), findsOneWidget);
    expect(find.text('From Base:'), findsOneWidget);
    expect(find.text('To Base:'), findsOneWidget);
    expect(find.text('Convert'), findsOneWidget);
  });
}
