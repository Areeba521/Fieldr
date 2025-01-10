import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddPlayersBottomSheet extends StatefulWidget {
  final String teamId;

  AddPlayersBottomSheet({required this.teamId});

  @override
  _AddPlayersBottomSheetState createState() => _AddPlayersBottomSheetState();
}

class _AddPlayersBottomSheetState extends State<AddPlayersBottomSheet> {
  List<DocumentSnapshot> availableUsers = [];
  List<String> selectedUsers = [];

  @override
  void initState() {
    super.initState();
    fetchAvailableUsers();
  }

  Future<void> fetchAvailableUsers() async {
    final usersQuery = await FirebaseFirestore.instance
        .collection('User')
        .where('teamId', isEqualTo: '')
        .get();
    setState(() {
      availableUsers = usersQuery.docs;
    });
  }

  
Future<void> addPlayersToTeam() async {
  for (String userId in selectedUsers) {
    try {
    
      final userQuerySnapshot = await FirebaseFirestore.instance
          .collection('User')
          .where('userId', isEqualTo: userId)
          .get();

      if (userQuerySnapshot.docs.isEmpty) {
        throw Exception('User with ID $userId not found.');
      }

      final userDoc = userQuerySnapshot.docs.first; 


      await userDoc.reference.update({'teamId': widget.teamId});

      
      final teamQuerySnapshot = await FirebaseFirestore.instance
          .collection('Teams')
          .where('teamId', isEqualTo: widget.teamId)
          .get();

      if (teamQuerySnapshot.docs.isEmpty) {
        throw Exception('Team with ID ${widget.teamId} not found.');
      }

      final teamDoc = teamQuerySnapshot.docs.first; 
      

      String userName = userDoc['name'];
   
      await teamDoc.reference.update({
         'members': FieldValue.arrayUnion([
          {
            'id': userId,
            'name': userName,
          }
        ]),
      });

    } catch (e) {
      print('Error adding user $userId to team: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Navigator.pop(context);
}


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Add Players to Team",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: availableUsers.length,
              itemBuilder: (context, index) {
                final user = availableUsers[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: user['profilePicture'] != null &&
                            user['profilePicture'] != ''
                        ? NetworkImage(user['profilePicture'])
                        : const AssetImage('images/man.jpg') as ImageProvider,
                  ),
                  title: Text(user['name']),
                  subtitle: Text(user['role']),
                  trailing: Checkbox(
                     activeColor: const Color(0xFF2a6068), 
                    checkColor: Colors.white, 
                    value: selectedUsers.contains(user['userId']),
                    onChanged: (value) {
                      setState(() {
                        if (value == true) {
                          selectedUsers.add(user['userId']);
                        } else {
                          selectedUsers.remove(user['userId']);
                        }
                      });
                    },
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: addPlayersToTeam,
            child: const Text("Confirm", style: TextStyle(color: Colors.white),),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2a6068)),
          ),
        ],
      ),
    );
  }
}