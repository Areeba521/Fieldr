import 'package:fieldr_project/first_screen.dart';
import 'package:fieldr_project/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {
  testWidgets('Golden Test', (WidgetTester tester) async {
   
    await tester.pumpWidget(
      MaterialApp(
       home: MyFirstScreen(), 
   
      ),
    );

    await tester.pumpAndSettle();

   
    await expectLater(
      find.byType(SignIn),
      matchesGoldenFile('golden_tests/my_first_screen.png'), 
    );
  });
}