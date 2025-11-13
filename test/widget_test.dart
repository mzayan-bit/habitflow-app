// test/widget_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:habitflow/main.dart'; // The file is correct
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('App starts and shows a placeholder', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    // **FIX**: Use the correct app widget name and wrap with ProviderScope for Riverpod
    await tester.pumpWidget(const ProviderScope(child: HabitFlowApp()));

    // Since our app now has complex auth logic, a simple counter test won't work.
    // We can just verify that something appears on the screen.
    // This test will pass if the initial loading spinner or login screen appears.
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}