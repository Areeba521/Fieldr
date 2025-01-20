import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class FieldsScreen extends StatelessWidget {
  final String location;
  const FieldsScreen({super.key, required this.location});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Fields Information',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF2a6068),
        elevation: 5,
      ),
      body: BlocBuilder<FieldBloc, FieldState>(
        builder: (context, state) {
          if (state is FieldItemLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is Error) {
            return Center(
              child: Text(
                'Error: ${state.error}',
                style: const TextStyle(color: Colors.red, fontSize: 18),
              ),
            );
          }
          if (state is FieldItemLoaded) {
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: state.fields.length,
              itemBuilder: (context, index) {
                final field = state.fields[index];
                return FieldCard(field: field);
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class FieldCard extends StatelessWidget {
  final Field field;

  const FieldCard({Key? key, required this.field}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              field.fieldName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF2a6068),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Location: ${field.location}',
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
            const SizedBox(height: 12),
            Text(
              'Availability:',
        
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
            ),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: field.availability.length,
              itemBuilder: (context, index) {
                final availability = field.availability[index];
                return ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    availability['isBooked'] ? Icons.close : Icons.check,
                    color: availability['isBooked'] ? Colors.red : Colors.green,
                  ),
                  title: Text(
                    'Date: ${availability['date']}',
                    style: const TextStyle(fontSize: 14),
                  ),
                  subtitle: Text(
                    'Time: ${DateFormat.Hm().format(availability['startTime'])} - ${DateFormat.Hm().format(availability['endTime'])}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2a6068),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                    ),
                    builder: (_) => BookingModal(field: field),
                  );
                },
                child: Text(
                  'Book Slot',
              
                   style: Theme.of(context).textTheme.bodyLarge
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BookingModal extends StatefulWidget {
  final Field field;

  const BookingModal({Key? key, required this.field}) : super(key: key);

  @override
  State<BookingModal> createState() => _BookingModalState();
}

class _BookingModalState extends State<BookingModal> {
  DateTime? selectedDate;
  TimeOfDay? startTime;
  TimeOfDay? endTime;

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _selectTime(BuildContext context, bool isStart) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 6, minute: 0),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          startTime = picked;
        } else {
          endTime = picked;
        }
      });
    }
  }

  void _bookField() async {
  if (selectedDate == null || startTime == null || endTime == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please select all booking details')),
    );
    return;
  }

  final newStartTime = DateTime(selectedDate!.year, selectedDate!.month, selectedDate!.day, startTime!.hour, startTime!.minute);
  final newEndTime = DateTime(selectedDate!.year, selectedDate!.month, selectedDate!.day, endTime!.hour, endTime!.minute);

  if (newEndTime.isBefore(newStartTime)) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('End time must be after start time')),
    );
    return;
  }

  final newBooking = {
    'date': DateFormat('yyyy-MM-dd').format(selectedDate!),
    'startTime': newStartTime,
    'endTime': newEndTime,
    'isBooked': true,
  };

  try {

    final querySnapshot = await FirebaseFirestore.instance
        .collection('Fields')
        .where('fieldId', isEqualTo: widget.field.fieldId)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final doc = querySnapshot.docs.first; 
      final fieldData = doc.data();
      final availability = List<Map<String, dynamic>>.from(fieldData['availability'] ?? []);


      for (final booking in availability) {
        final existingDate = booking['date'];
        final existingStartTime = (booking['startTime'] as Timestamp).toDate();
        final existingEndTime = (booking['endTime'] as Timestamp).toDate();

        if (existingDate == newBooking['date'] &&
            newStartTime.isBefore(existingEndTime) &&
            newEndTime.isAfter(existingStartTime)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('This time slot is already booked.')),
          );
          return;
        }
      }


      availability.add(newBooking);

      await FirebaseFirestore.instance.collection('Fields').doc(doc.id).update({
        'availability': availability,
      });

       Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Field booked successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Field not found.')),
      );
    }
  } catch (error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to book field: $error')),
    );
  }
}



  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Book a Slot',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: Text(selectedDate == null
                ? 'Select Date'
                : DateFormat.yMMMMd().format(selectedDate!)),
            onTap: () => _selectDate(context),
          ),
          ListTile(
            leading: const Icon(Icons.access_time),
            title: Text(startTime == null
                ? 'Select Start Time'
                : startTime!.format(context)),
            onTap: () => _selectTime(context, true),
          ),
          ListTile(
            leading: const Icon(Icons.access_time),
            title: Text(endTime == null
                ? 'Select End Time'
                : endTime!.format(context)),
            onTap: () => _selectTime(context, false),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2a6068),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: _bookField,
            child: const Text('Confirm Booking'),
          ),
          
        ],
      ),
    );
  }
}

class Field {
  final String fieldId;
  final String fieldName;
  final String location;
  final List<Map<String, dynamic>> availability;

  Field({
    required this.fieldId,
    required this.fieldName,
    required this.location,
    required this.availability,
  });

  factory Field.fromJson(Map<String, dynamic> json) {
    return Field(
      fieldId: json['fieldId'] ?? '',
      fieldName: json['fieldName'] ?? '',
      location: json['location'] ?? '',
      availability: (json['availability'] as List<dynamic>).map((item) {
        return {
          'date': item['date'] ?? '',
          'startTime': (item['startTime'] as Timestamp).toDate(),
          'endTime': (item['endTime'] as Timestamp).toDate(),
          'isBooked': item['isBooked'] ?? false,
        };
      }).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fieldId': fieldId,
      'fieldName': fieldName,
      'location': location,
      'availability': availability.map((item) {
        return {
          'date': item['date'],
          'startTime': Timestamp.fromDate(item['startTime']),
          'endTime': Timestamp.fromDate(item['endTime']),
          'isBooked': item['isBooked'],
        };
      }).toList(),
    };
  }
}

abstract class FieldEvent {}

class FetchFieldEvent extends FieldEvent {}

abstract class FieldState {}

class FieldItemLoading extends FieldState {}

class FieldItemLoaded extends FieldState {
  final List<Field> fields;
 

  FieldItemLoaded({
    required this.fields,
   
  });
}

class Error extends FieldState {
  final String error;
  Error(this.error);
}

class FieldBloc extends Bloc<FieldEvent,FieldState> {
  final FirebaseFirestore store = FirebaseFirestore.instance;

  FieldBloc() : super(FieldItemLoading()) {
    on<FetchFieldEvent>(_onFetchField);
  }

 void _onFetchField(FieldEvent event, Emitter<FieldState> emit) async {
  emit(FieldItemLoading());
  try {
    List<Field> fields = [];
    QuerySnapshot snapshot = await store.collection('Fields').get();

    fields = snapshot.docs.map((doc) {
      final field = Field.fromJson(doc.data() as Map<String, dynamic>);

      final currentDate = DateTime.now();
      final filteredAvailability = field.availability.where((availability) {
        final availabilityDate = DateFormat('yyyy-MM-dd').parse(availability['date']);
        return availabilityDate.isAfter(currentDate);
      }).toList();

      return Field(
        fieldId: field.fieldId,
        fieldName: field.fieldName,
        location: field.location,
        availability: filteredAvailability,
      );
    }).toList();

    emit(FieldItemLoaded(fields: fields));
  } catch (e) {
    emit(Error(e.toString()));
  }
}




}
