import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

import 'createTeam_screen.dart';
import 'team_boxScreen.dart';

class TeamManagementScreen extends StatelessWidget {
 

  const TeamManagementScreen({super.key});

 String? _getUserRole() {
    final userBox = Hive.box('userBox');
    final role = userBox.get('role');
    debugPrint('Fetched user role from Hive in TeamManagementScreen: $role');
    return role;
  }

  @override
  Widget build(BuildContext context) {
      final String? userRole = _getUserRole();
    debugPrint('User role determined in build method: $userRole');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Team Details',
         style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold
        ),),
        centerTitle: true,
        backgroundColor: const Color(0xFF2a6068),
      ),
      body: BlocBuilder<TeamBloc, TeamState>(builder: (context, state){
        if (state is TeamLoading) {
        return const Center(child: CircularProgressIndicator());
      } else if (state is TeamLoaded) {
        return Column(
          children: [
         
            Expanded( 
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: state.teams.length,
                itemBuilder: (context, index) {
                  Team team = state.teams[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TeamBox(team: team),
                  );
                },
              ),
            ),
          ],
        );
      
         }
          else if(state is Error){
          return Center(
            child: Text(
              'Failed to load Teams: ${state.error}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }
        else {
          return const SizedBox.shrink();
        }
      }

      
      ),
    floatingActionButton: (userRole == "Team Captain")?

    
    FloatingActionButton(
        onPressed: () {
        Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => CreateTeamPage()),
).then((_) {
  BlocProvider.of<TeamBloc>(context).add(FetchTeamEvent());
});

        },
        backgroundColor: const Color(0xFF2a6068),
        child: const Icon(Icons.add, color: Colors.white),
      ):null,
    
    );
  }
  }

  

  





class Team {
  final String teamId;
  final String teamName;
  final Map<String, dynamic> captain;
  final List<Map<String, dynamic>> members;
  final Map<String, int> stats;

  Team({
    required this.teamId,
    required this.teamName,
    required this.captain,
    required this.members,
    required this.stats,
  });

factory Team.fromJson(Map<String, dynamic> json) {
  return Team(
    teamId: json['teamId'] ?? '',
    teamName: json['teamName'] ?? '',
    captain: json['captain'] ?? {'captainId': '', 'captainName': '', 'captainProfilePic': ''},
    members: List<Map<String, dynamic>>.from(json['members'] ?? []),
    stats: {
      'wins': json['stats']?['wins'] ?? 0,
      'draws': json['stats']?['draws'] ?? 0,
      'losses': json['stats']?['losses'] ?? 0,
    },
  );
}

}

abstract class TeamEvent {}

class FetchTeamEvent extends TeamEvent {}

abstract class TeamState {}

class TeamLoading extends TeamState {}

class TeamLoaded extends TeamState{
  final List<Team> teams;
 
 TeamLoaded({
    required this.teams,
  });
}

class Error extends TeamState {
  final String error;
  Error(this.error);
}

class TeamBloc extends Bloc<TeamEvent, TeamState> {
  final FirebaseFirestore store = FirebaseFirestore.instance;

  TeamBloc() : super(TeamLoading()) {
    on<FetchTeamEvent>(_onFetchTeam);
  }

  void _onFetchTeam(TeamEvent event, Emitter<TeamState> emit) async {
    emit(TeamLoading());
    try {
      List<Team> teams = [];
      QuerySnapshot snapshot = await store.collection('Teams').get();

      print('Documents found: ${snapshot.docs.length}');
      for (var doc in snapshot.docs) {
        print('Document data: ${doc.data()}');
      }

      teams = snapshot.docs.map((doc) {
        return Team.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();

     print('Teams Loaded: ${teams.length}');
      
     
      emit(TeamLoaded(
        teams: teams,
      ));
    } catch (e) {
      emit(Error(e.toString()));
    }
  }



 
}