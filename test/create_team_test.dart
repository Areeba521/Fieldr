//widget testing
import 'package:fieldr_project/createTeam_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {
  group('CreateTeamPage Widget Tests', () {
    testWidgets('Check initial UI elements', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: CreateTeamPage(),
        ),
      );

      // Verify the presence of text fields and buttons
      expect(find.text('Team Name'), findsOneWidget);
      expect(find.text('Captain Name'), findsOneWidget);
      expect(find.text('Captain ID'), findsOneWidget);
      expect(find.text('Team ID'), findsOneWidget);
      expect(find.text('Add Member'), findsOneWidget);
      expect(find.text('Save Team'), findsOneWidget);
    });

    testWidgets('Add Member functionality', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: CreateTeamPage(),
        ),
      );

     
      await tester.tap(find.text('Add Member'));
      await tester.pump(); 
      
      expect(find.text('Member Name'), findsOneWidget);
      expect(find.text('Member ID'), findsOneWidget);
    });

    testWidgets('Save Team without filling required fields shows SnackBar', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CreateTeamPage(),
          ),
        ),
      );


      await tester.tap(find.text('Save Team'));
      await tester.pump(); 

     
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Please fill all the required fields!'), findsOneWidget);
    });

    testWidgets('Remove Member functionality', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: CreateTeamPage(),
        ),
      );


      await tester.tap(find.text('Add Member'));
      await tester.pump();

    
      expect(find.text('Member Name'), findsOneWidget);

      
      await tester.tap(find.byIcon(Icons.remove_circle));
      await tester.pump();

      
      expect(find.text('Member Name'), findsNothing);
    });
  });
}
