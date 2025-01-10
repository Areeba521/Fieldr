import 'package:fieldr_project/first_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {
  testWidgets('MyFirstScreen golden test', (WidgetTester tester) async {
    // Build the widget tree
    await tester.pumpWidget(
      MaterialApp(
        home: MyFirstScreen(),
      ),
    );

    await tester.pumpAndSettle();

    expect(
      find.byType(MyFirstScreen),
      matchesGoldenFile('goldens/my_first_screen.png'),
    );
  });
}
