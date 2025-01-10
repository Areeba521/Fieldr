import 'package:fieldr_project/Fields_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateMatchPage extends StatefulWidget {
  const CreateMatchPage({Key? key}) : super(key: key);

  @override
  _CreateMatchPageState createState() => _CreateMatchPageState();
}

class _CreateMatchPageState extends State<CreateMatchPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _skillLevelController = TextEditingController();
  final TextEditingController _teamANameController = TextEditingController();
  final TextEditingController _teamBNameController = TextEditingController();
  final TextEditingController _teamAIdController = TextEditingController();
  final TextEditingController _teamBIdController = TextEditingController();
  final TextEditingController _matchIdController = TextEditingController();
  final TextEditingController _dateTimeController = TextEditingController();
  DateTime? _selectedDateTime;

Future<void> _navigateToFieldScreen(BuildContext context) async {
  final String? selectedField = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => BlocProvider(
        create: (context) => FieldBloc()..add(FetchFieldEvent()), 
        child: FieldsScreen(location: ''),
      ),
    ),
  );

  if (selectedField != null && selectedField.isNotEmpty) {
    setState(() {
      _locationController.text = selectedField;  
    });
  }
}



  Future<void> _selectDateTime(BuildContext context) async {

  DateTime? selectedDate = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2000),
    lastDate: DateTime(2101),
  );

  if (selectedDate != null) {
  
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(DateTime.now()),
    );

    if (selectedTime != null) {
    
      final DateTime dateTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        selectedTime.hour,
        selectedTime.minute,
      );

      setState(() {
        _selectedDateTime = dateTime;
        _dateTimeController.text = "${dateTime.toLocal()}".split(' ')[0]; 
      });
    }
  }
}



Future<void> _submitMatch() async {
  if (_formKey.currentState?.validate() ?? false) {
    final matchData = {
      'location': _locationController.text,
      'skillLevel': _skillLevelController.text,
      'teamA': {
        'teamName': _teamANameController.text,
        'teamId': _teamAIdController.text,
      },
      'teamB': {
        'teamName': _teamBNameController.text,
        'teamId': _teamBIdController.text,
      },
      'createdBy': 'currentUser', // actual user ID
      'dateTime': _selectedDateTime != null ? Timestamp.fromDate(_selectedDateTime!) : null,
      'matchId': _matchIdController.text,
    };

    print("Submitting match: $matchData");

    try {
      await FirebaseFirestore.instance.collection('Match').add(matchData);
      print("Match added successfully!");
      Navigator.pop(context);
    } catch (e) {
      print("Error adding match: $e");
    }
  } else {
    print("Form validation failed.");
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Match', style: TextStyle(color: Colors.white),),
        backgroundColor: const Color(0xFF2a6068),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
         child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          customTextField(
            controller: _matchIdController,
            labelText: 'MatchId',
            hintText: 'Enter Match ID',
            validator: (value) => value?.isEmpty ?? true ? 'Please enter Match ID' : null,
          ),
          const SizedBox(height: 16),

           GestureDetector(
                  onTap: () => _navigateToFieldScreen(context),
                  child: AbsorbPointer(
                    child: customTextField(
                      controller: _locationController,
                      labelText: 'Book Field',
                      hintText: 'Tap to choose field location',
                      validator: (value) => value?.isEmpty ?? true ? 'Please book Field' : null,
                    ),
                  ),
                ),
        
      const SizedBox(height: 16),
                    customTextField(
                      controller: _locationController,
                      labelText: 'Location',
                      hintText: 'Tap to choose field location',
                      validator: (value) => value?.isEmpty ?? true ? 'Please select location' : null,
                    ),
               
          const SizedBox(height: 16),
        
          customTextField(
            controller: _skillLevelController,
            labelText: 'Skill Level',
            hintText: 'Enter Skill Level',
            validator: (value) => value?.isEmpty ?? true ? 'Please enter skill level' : null,
          ),
          const SizedBox(height: 16),
        
        
             
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: customTextField(
                  controller: _teamANameController,
                  labelText: 'Team A Name',
                  hintText: 'Enter Team A Name',
                  validator: (value) => value?.isEmpty ?? true ? 'Please enter Team A name' : null,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: customTextField(
                  controller: _teamAIdController,
                  labelText: 'Team A Id',
                  hintText: 'Enter Team A ID',
                  validator: (value) => value?.isEmpty ?? true ? 'Please enter Team A Id' : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: customTextField(
                  controller: _teamBNameController,
                  labelText: 'Team B Name',
                  hintText: 'Enter Team B Name',
                  validator: (value) => value?.isEmpty ?? true ? 'Please enter Team B name' : null,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: customTextField(
                  controller: _teamBIdController,
                  labelText: 'Team B Id',
                  hintText: 'Enter Team B ID',
                  validator: (value) => value?.isEmpty ?? true ? 'Please enter Team B Id' : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
 
                GestureDetector(
        onTap: () => _selectDateTime(context),
        child: AbsorbPointer(
          child: customTextField(
            controller: _dateTimeController,
            labelText: 'Time of the Match',
            hintText: 'Tap to select date and time',
            validator: (value) => value?.isEmpty ?? true ? 'Please select time' : null,
          ),
        ),
      ),
          const SizedBox(height: 20),
        
          
          ElevatedButton(
            onPressed: _submitMatch,
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 48), 
              backgroundColor: const Color(0xFF2a6068),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Create Match', style: TextStyle(color: Colors.white),),
          ),
        ],
            ),
          ),
        ),
        
        ),
      ),
    );
  }

  Widget customTextField({
  required TextEditingController controller,
  required String labelText,
  required String hintText,
  String? Function(String?)? validator,
  TextInputType keyboardType = TextInputType.text,
}) {
  return TextFormField(
    controller: controller,
    decoration: InputDecoration(
      labelText: labelText,
      hintText: hintText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: const Color(0xFF2a6068), width: 2), 
        borderRadius: BorderRadius.circular(12),
      ),
      labelStyle: TextStyle(color: Colors.grey),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: const Color(0xFF2a6068), width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.all(16),
    ),
    validator: validator,
    keyboardType: keyboardType,
  );
}
}
