//widget testing
import 'package:fieldr_project/playingTeamCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {
  group('TeamCard Widget Tests', () {
    testWidgets('TeamCard displays team name, icon, and card color correctly', (tester) async {
      // Create the TeamCard widget with mock data
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

      // Check if the TeamCard is displaying the correct team name
      expect(find.text(teamName), findsOneWidget);

      // Check if the correct icon is displayed
      expect(find.byIcon(icon), findsOneWidget);

      // Check if the background color is correct (you can use `find.byWidget` for this)
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

  // Verify the padding and layout by checking widget positions
  final iconFinder = find.byIcon(icon);
  final textFinder = find.text(teamName);

  // Check that the icon is positioned first in the Row (compare the 'dx' values)
  final iconOffset = tester.getTopLeft(iconFinder);
  final textOffset = tester.getTopLeft(textFinder);

  // Check that the icon is positioned to the left of the text
  expect(iconOffset.dx, lessThan(textOffset.dx));

  // Check that there is space between the icon and the text (due to SizedBox)
  expect(textOffset.dx - iconOffset.dx, greaterThanOrEqualTo(12));
});

  });
}
