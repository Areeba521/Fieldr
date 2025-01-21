//widget testing
import 'package:fieldr_project/playingTeamCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {
  group('TeamCard Widget Tests', () {
    testWidgets('TeamCard displays team name, icon, and card color correctly', (tester) async {
      
      const teamName = 'Team A';
      const cardColor = Colors.blue;
      const icon = Icons.sports_football;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TeamCard(
              teamName: teamName,
              cardColor: cardColor,
              icon: icon,
            ),
          ),
        ),
      );

      expect(find.text(teamName), findsOneWidget);

      
      expect(find.byIcon(icon), findsOneWidget);

     
      final container = tester.firstWidget(find.byType(Container)) as Container;
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, cardColor);
    });

   testWidgets('TeamCard layout looks correct with spacing', (tester) async {
  const teamName = 'Team B';
  const cardColor = Colors.green;
  const icon = Icons.group;

  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: TeamCard(
          teamName: teamName,
          cardColor: cardColor,
          icon: icon,
        ),
      ),
    ),
  );

  final iconFinder = find.byIcon(icon);
  final textFinder = find.text(teamName);

  
  final iconOffset = tester.getTopLeft(iconFinder);
  final textOffset = tester.getTopLeft(textFinder);

  expect(iconOffset.dx, lessThan(textOffset.dx));

  
  expect(textOffset.dx - iconOffset.dx, greaterThanOrEqualTo(12));
});

  });
}
