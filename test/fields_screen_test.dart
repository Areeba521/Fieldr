//widget testing
import 'package:fieldr_project/Fields_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';


void main() {
  group('FieldCard Widget Tests', () {
    final mockField = Field(
      fieldId: 'test-field-1',
      fieldName: 'Test Field',
      location: 'Test Location',
      availability: [
        {
          'date': '2025-01-18',
          'startTime': DateTime(2025, 1, 18, 9, 0), 
          'endTime': DateTime(2025, 1, 18, 11, 0), 
          'isBooked': false,
        },
        {
          'date': '2025-01-18',
          'startTime': DateTime(2025, 1, 18, 14, 0), 
          'endTime': DateTime(2025, 1, 18, 16, 0), 
          'isBooked': true,
        },
      ],
    );

    testWidgets('FieldCard displays correct field information',
        (WidgetTester tester) async {
    
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FieldCard(field: mockField),
          ),
        ),
      );

      
      expect(find.text('Test Field'), findsOneWidget);

     
      expect(find.text('Location: Test Location'), findsOneWidget);

      
      expect(find.text('Availability:'), findsOneWidget);

      final firstTimeSlot =
          'Time: ${DateFormat.Hm().format(mockField.availability[0]['startTime'])} - ${DateFormat.Hm().format(mockField.availability[0]['endTime'])}';
      final secondTimeSlot =
          'Time: ${DateFormat.Hm().format(mockField.availability[1]['startTime'])} - ${DateFormat.Hm().format(mockField.availability[1]['endTime'])}';

      expect(find.text(firstTimeSlot), findsOneWidget);
      expect(find.text(secondTimeSlot), findsOneWidget);

      
      expect(find.text('Book Slot'), findsOneWidget);

      
      expect(find.byIcon(Icons.check), findsOneWidget); 
      expect(find.byIcon(Icons.close), findsOneWidget); 
    });

    testWidgets('FieldCard booking button opens booking modal',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FieldCard(field: mockField),
          ),
        ),
      );

     
      await tester.tap(find.text('Book Slot'));
      await tester.pumpAndSettle();

      
      expect(find.text('Book a Slot'), findsOneWidget);
      expect(find.text('Select Date'), findsOneWidget);
      expect(find.text('Select Start Time'), findsOneWidget);
      expect(find.text('Select End Time'), findsOneWidget);
      expect(find.text('Confirm Booking'), findsOneWidget);
    });
  });
}