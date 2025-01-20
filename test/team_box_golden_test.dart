import 'package:fieldr_project/team_boxScreen.dart';
import 'package:fieldr_project/team_managementScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('TeamBox golden test', (WidgetTester tester) async {
    // Create a dummy team object for testing
    final team = Team(
      teamId: '123',
      teamName: 'The Testers',
      captain: {'captainProfilePic': 'images/man.jpg'}, 
      stats: {'wins': 10, 'draws': 5, 'losses': 2},
      members: [],
    );

    
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TeamBox(team: team),
        ),
      ),
    );

    
    await expectLater(
      find.byType(TeamBox),
      matchesGoldenFile('goldens/team_box.png'),
    );
  });
}
