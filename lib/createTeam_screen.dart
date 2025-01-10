import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateTeamPage extends StatefulWidget {

  @override
  _CreateTeamPageState createState() => _CreateTeamPageState();
}

class _CreateTeamPageState extends State<CreateTeamPage> {
  final TextEditingController _teamNameController = TextEditingController();
  final TextEditingController _captainNameController = TextEditingController();
  final TextEditingController _teamIdController = TextEditingController();
  final TextEditingController _captainIdController = TextEditingController();
  final List<Map<String, String>> _members = [];
  String _captainProfileImage = '';

  void _addMember() {
    setState(() {
      _members.add({'memberId': '', 'memberName': ''});
    });

  }

  void _removeMember(int index) {
    setState(() {
      _members.removeAt(index);
    });
  }

  void _saveTeam() async {
    final String teamName = _teamNameController.text;
    final String captainName = _captainNameController.text;
    final String captainId = _captainIdController.text;
    final String teamId = _teamIdController.text; 

    if (teamName.isEmpty || captainName.isEmpty || captainId.isEmpty || teamId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all the required fields!')),
      );
      return;
    }

    try {
     
      QuerySnapshot captainQuerySnapshot = await FirebaseFirestore.instance
          .collection('User')
          .where('userId', isEqualTo: captainId)  
          .get();

      if (captainQuerySnapshot.docs.isNotEmpty) {
   
        DocumentSnapshot captainSnapshot = captainQuerySnapshot.docs.first;
        _captainProfileImage = captainSnapshot['profilePicture'] ?? ''; 
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Captain not found!')),
        );
        return;
      }
      QuerySnapshot teamsCollectionLength =
        await FirebaseFirestore.instance.collection('Teams').get();

   
      DocumentReference teamRef = await FirebaseFirestore.instance.collection('Teams').add({
        'teamName': teamName,
        'captain': {
          'captainId': captainId,
          'captainName': captainName,
          'captainProfilePic': _captainProfileImage, 
        },
        'members': _members,
        'stats': {'wins': 0, 'draws': 0, 'losses': 0},
        'teamId': "team00${teamsCollectionLength.size+1}",
      });
        
       DocumentSnapshot teamSnapshot = await teamRef.get();
      String teamId = teamSnapshot['teamId']; 
        
      for (var member in _members) {
        String memberId = member['memberId'] ?? '';
        if (memberId.isNotEmpty) {
      
          QuerySnapshot memberQuerySnapshot = await FirebaseFirestore.instance
              .collection('User')
              .where('userId', isEqualTo: memberId)
              .get();

          if (memberQuerySnapshot.docs.isNotEmpty) {
            DocumentSnapshot memberSnapshot = memberQuerySnapshot.docs.first;
         
            await memberSnapshot.reference.update({'teamId': teamId});
          }
        }
      }

    
      QuerySnapshot captainSnapshot = await FirebaseFirestore.instance
          .collection('User')
          .where('userId', isEqualTo: captainId)
          .get();

      if (captainSnapshot.docs.isNotEmpty) {
        DocumentSnapshot captainDoc = captainSnapshot.docs.first;
    
        await captainDoc.reference.update({'teamId': teamId});
      }


      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Team created and teamId updated successfully!')),
      );

      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create team: $e')),
      );
    }

  }

  @override
  Widget build(BuildContext context) {
 
    return Scaffold(
      
      appBar: AppBar(
        title: const Text('Create New Team',
         style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold
        ),
        ),
        backgroundColor: const Color(0xFF2a6068),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _teamNameController,
                cursorColor: const Color(0xFF2a6068),
                decoration: const InputDecoration(labelText: 'Team Name',
                floatingLabelStyle: TextStyle(color: const Color(0xFF2a6068)),
                focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: const Color(0xFF2a6068)), 
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.grey), 
    ),),
              ),
              TextField(
                controller: _captainNameController,
                cursorColor: const Color(0xFF2a6068),
                decoration: const InputDecoration(labelText: 'Captain Name', 
                floatingLabelStyle: TextStyle(color: const Color(0xFF2a6068)),
                focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: const Color(0xFF2a6068)), 
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.grey), 
    ),),
              ),
              TextField(
                controller: _captainIdController,
                cursorColor: const Color(0xFF2a6068),
                decoration: const InputDecoration(labelText: 'Captain ID',
                floatingLabelStyle: TextStyle(color: const Color(0xFF2a6068)),
                focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: const Color(0xFF2a6068)), 
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.grey), 
    ),),
              ),
               TextField(
                controller: _teamIdController,  
                cursorColor: const Color(0xFF2a6068),
                decoration: const InputDecoration(labelText: 'Team ID',
                floatingLabelStyle: TextStyle(color: const Color(0xFF2a6068)),
                focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: const Color(0xFF2a6068)), 
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.grey), 
    ),),
              ),
              const SizedBox(height: 20),
              const Text(
                'Team Members',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
            ListView.builder(
  shrinkWrap: true,
  itemCount: _members.length,
  itemBuilder: (context, index) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              cursorColor: const Color(0xFF2a6068),
              decoration: const InputDecoration(
                labelText: 'Member Name',
                floatingLabelStyle: TextStyle(color: const Color(0xFF2a6068)),
                focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: const Color(0xFF2a6068)), 
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.grey), 
    ),
              ),
              onChanged: (value) {
                setState(() {
                  _members[index]['memberName'] = value;
                });
              },
            ),
            TextField(
              cursorColor: const Color(0xFF2a6068),
              decoration: const InputDecoration(
                labelText: 'Member ID',
                floatingLabelStyle: TextStyle(color: const Color(0xFF2a6068)),
                focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: const Color(0xFF2a6068)), 
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.grey), 
    ),
              ),
              onChanged: (value) {
                setState(() {
                  _members[index]['memberId'] = value;
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.remove_circle, color: Colors.red),
              onPressed: () => _removeMember(index),
            ),
          ],
        ),
      ),
    );
  },
),

              const SizedBox(height: 10),
              ElevatedButton(
              onPressed: _addMember,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2a6068),  
                 foregroundColor: Colors.white, 
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20), 
                shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),  // Round the corners
    ),
  ),
  child: const Text('Add Member'),
),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _saveTeam,
                   style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2a6068),  
                 foregroundColor: Colors.white, 
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20), 
                shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8), 
    ),
  ),
                  child: const Text('Save Team'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
