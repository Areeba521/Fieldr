import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'AddPlayer_screen.dart';

class TeamMembersScreen extends StatelessWidget {
  final String teamId;
  final String team_name;
  

  TeamMembersScreen({required this.teamId, required this.team_name});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(team_name,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold
        ),),
        backgroundColor: const Color(0xFF2a6068),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchTeamMembers(teamId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading members'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
  final members = snapshot.data!;
return Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16, 
            crossAxisSpacing: 16, 
            childAspectRatio: 0.75, 
          ),
          itemCount: members.length,
          itemBuilder: (context, index) {
            final member = members[index];
            return SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              
              child: 
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  
                  const SizedBox(height: 12),
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: member['profilePicture'] != null &&
                            member['profilePicture'] != ''
                        ? NetworkImage(member['profilePicture'])
                        : const AssetImage('images/man.jpg') as ImageProvider,
                    backgroundColor: const Color(0xFF2a6068),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    member['name'],
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2a6068),
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis, 
                    maxLines: 1, 
                  ),
                  const SizedBox(height: 4),
                  Text(
                    member['role'],
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade700,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2a6068),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Goals: ${member['stats']['goals']}',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        Text(
                          'Assists: ${member['stats']['assists']}',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        Text(
                          'Matches: ${member['stats']['matchesPlayed']}',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
           IconButton(
            
           onPressed: () async {
                 
                },
         
          icon: const Icon(
            Icons.remove_circle,
            color: const Color(0xFF2a6068),
          ),
        ),

 

                ],
              ),
            ),
            );
          },
        ),

        
      );
    


          } else {
            return const Center(child: Text('No members found'));
          }
        },
      ),
      
     floatingActionButton: SizedBox(
  height: 50,
  width: 150, 
  child: ElevatedButton(
     onPressed: () async {
         QuerySnapshot teamsSnapshot = await FirebaseFirestore.instance
          .collection('Teams')
          .where('teamId', isEqualTo: teamId)
          .get();

      if (teamsSnapshot.docs.isNotEmpty) {
       
        DocumentSnapshot teamDoc = teamsSnapshot.docs.first;

        List members = teamDoc['members'] ?? [];
        
        if (members.length < 5) {
        
          showModalBottomSheet(
            context: context,
            builder: (_) => AddPlayersBottomSheet(
              teamId: teamId,
            ),
          );
        } else {
         
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Cannot add more than 5 players to the team.'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      } else {
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Team not found.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF2a6068),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25), 
      ),
    ),
    child: const Text(
      "Add Players",
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 16, 
      ),
    ),
  ),
),

      
    );
  }





Future<List<Map<String, dynamic>>> fetchTeamMembers(String teamId) async {
  print("Fetching team members for teamId: $teamId");
  try {
    final firestore = FirebaseFirestore.instance;


    QuerySnapshot teamQuery = await firestore
        .collection('Teams')
        .where('teamId', isEqualTo: teamId)
        .get();

    if (teamQuery.docs.isNotEmpty) {
     
      final teamDoc = teamQuery.docs.first;
      final teamData = teamDoc.data() as Map<String, dynamic>;

      print("Team Data: $teamData");

      List<dynamic> members = teamData['members'] ?? [];
      print("Members Data: $members");

      if (members.isEmpty) {
        print("No members in team document");
        return [];
      }

      
List<Future<Map<String, dynamic>?>> userFutures = members.map((member) async {
        final memberMap = member as Map<String, dynamic>;

      
        QuerySnapshot userQuery = await firestore
            .collection('User')
            .where('userId', isEqualTo: memberMap['id'])
            
            .get();
            

        if (userQuery.docs.isNotEmpty) {
          final userDoc = userQuery.docs.first;
          final userData = userDoc.data() as Map<String, dynamic>;
          print("Fetched User Data: $userData");

          return {
            'userId': userDoc.id,
            'name': userData['name'],
            'profilePicture': userData['profilePicture'],
            'stats': {
              'goals': userData['stats']?['goals'] ?? 0,
              'assists': userData['stats']?['assists'] ?? 0,
              'matchesPlayed': userData['stats']?['matchesPlayed'] ?? 0,
            },
            'role': userData['role'] ?? 'Regular Player',
          };
        } else {
          print("No user found with userId: ${memberMap['id']}");
          return null;
        }
      }).toList();

     
List<Map<String, dynamic>?> userDataList = await Future.wait(userFutures);


      return userDataList.where((user) => user != null).cast<Map<String, dynamic>>().toList();
    } else {
      print("No document found with teamId '$teamId'");
      return [];
    }
  } catch (e) {
    print("Error in fetchTeamMembers: $e");
    return [];
  }
}




}

