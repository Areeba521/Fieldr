import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import 'createMatchPage.dart';
import 'playingTeamCard.dart';

class MatchFinderScreen extends StatelessWidget {
  const MatchFinderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Match Finder',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF2a6068),
        elevation: 5,
        shadowColor: const Color.fromARGB(255, 61, 134, 146),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
       IconButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateMatchPage()),
    ).then((_) {
      
      BlocProvider.of<MatchBloc>(context).add(FetchMatchEvent());
    });
  },
  icon: const Icon(Icons.add, color: Colors.white, size: 35),
),
        ],
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: MatchListView(),
      ),

     
    );
  }
}

class MatchListView extends StatefulWidget {
  const MatchListView({super.key});

  @override
  _MatchListViewState createState() => _MatchListViewState();
}

class _MatchListViewState extends State<MatchListView> {
  String _searchQuery = ''; 
  String _selectedTimeOfDay = 'All';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
       
        TextField(
          cursorColor: const Color(0xFF2a6068),
          onChanged: (value) {
            setState(() {
              _searchQuery = value.toLowerCase();
            });
          },
          decoration: InputDecoration(
           
            labelText: 'Search by location',
             labelStyle: const TextStyle(
              color: Color(0xFF2a6068), 
            ),
            hintText: 'Enter location',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
               borderSide: const BorderSide(
                color: Color(0xFF2a6068), 
              ),
              
            ),

             focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: const BorderSide(
                color: Color(0xFF2a6068), 
                width: 2.0,
              ),
            ),
             enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: const BorderSide(
                color: Colors.grey, 
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),

     Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    const Text(
      'Filter by Time of Day',
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: const Color(0xFF2a6068),
      ),
    ),
    const SizedBox(height: 8), 
    Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: const Color(0xFF2a6068), 
        ),

        
      ),
      child: DropdownButton2<String>(
        value: _selectedTimeOfDay,
        items: [
          'All',
          'Morning',
          'Afternoon',
          'Evening',
          'Night',
        ].map((time) {
          return DropdownMenuItem<String>(
            value: time,
            child: Text(time),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            _selectedTimeOfDay = value!;
          });
        },
        hint: const Text(
          'Select Time of Day',
          style: TextStyle(color: Colors.black54),
        ),
        isExpanded: true, 
        underline: const SizedBox(), 
         style: Theme.of(context).textTheme.bodyLarge?.copyWith(
        fontSize: 16,
     
      ),


      ),
    ),
    const SizedBox(height: 16), 
  ],
),


        Expanded(
          child: BlocBuilder<MatchBloc, MatchState>(
            builder: (context, state) {
              if (state is MatchItemLoading) {
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

               if (state is MatchItemLoaded) {
                final now = DateTime.now();
                final matches = state.matches.where((match) {
                  final isFutureMatch = match.dateTime.toDate().isAfter(now);
                  final matchLocationMatches = match.location.toLowerCase().contains(_searchQuery);
                    final timeMatches = _isMatchInSelectedTimeRange(match.timeOfDay);

                  return isFutureMatch && matchLocationMatches && timeMatches;
                }).toList();

                if (matches.isEmpty) {
                  return const Center(
                    child: Text(
                      'No matches available',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: matches.length,
                  itemBuilder: (context, index) {
                    final match = matches[index];
                    return _buildMatchCard(context, match);
                  },
                );
              }

              return const Center(child: Text('Unknown state'));
            },
          ),
          

        
        ),

        
      ],
    
    );

  }


bool _isMatchInSelectedTimeRange(String timeOfDay) {
    if (_selectedTimeOfDay == 'All') return true;

    switch (_selectedTimeOfDay) {
      case 'Morning':
        return timeOfDay == 'Morning';
      case 'Afternoon':
        return timeOfDay == 'Afternoon';
      case 'Evening':
        return timeOfDay == 'Evening';
      case 'Night':
        return timeOfDay == 'Night';
      default:
        return true;
    }
  }
}
  Widget _buildMatchCard(BuildContext context, Match match) {
    return Card(
      margin: const EdgeInsets.all(12),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              match.location,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2a6068),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 18),
                    const SizedBox(width: 5),
                    Text(
                      _formatDateTime(match.dateTime),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                Expanded(
                  child: Row(
                    children: [
                      const Icon(Icons.sports_soccer, size: 18),
                      const SizedBox(width: 5),
                      Text(
                        match.skillLevel,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: match.skillLevel == 'Intermediate'
                              ? Colors.orange
                              : match.skillLevel == 'Beginner'
                                  ? Colors.green
                                  : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20,),
           Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
       
        TeamCard(
          teamName: match.teamA['teamName'],
          cardColor: const Color.fromARGB(255, 9, 63, 156), 
          icon: Icons.sports_soccer, 
        ),

        
         Text(
          "VS",
           style: Theme.of(context).textTheme.bodyLarge?.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        
      ),
         
        ),
      
    
   
        TeamCard(
          teamName: match.teamB['teamName'],
          cardColor: const Color.fromARGB(255, 228, 19, 19),  
          icon: Icons.sports_soccer,  
        ),
      ],
    ),
            const SizedBox(height: 12),
          
          ],
        ),
      ),
    );
  }



  String _formatDateTime(Timestamp timestamp) {
    final DateTime date = timestamp.toDate();
    return DateFormat('yyyy-MM-dd – hh:mm a').format(date);
  }

  // void _joinMatch(BuildContext context, Match match) async {
  //   final userId = 'user123';
  //   try {
  //     List<String> teamAPlayers = List<String>.from(match.teamA['players'] ?? []);
  //     List<String> teamBPlayers = List<String>.from(match.teamB['players'] ?? []);

  //     if (teamAPlayers.length <= teamBPlayers.length) {
  //       await FirebaseFirestore.instance
  //           .collection('Match')
  //           .doc(match.matchId)
  //           .update({
  //         'teamA.players': FieldValue.arrayUnion([userId]),
  //       });
  //     } else {
  //       await FirebaseFirestore.instance
  //           .collection('Match')
  //           .doc(match.matchId)
  //           .update({
  //         'teamB.players': FieldValue.arrayUnion([userId]),
  //       });
  //     }

  //     if (context.mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('You have joined the match!')),
  //       );
  //     }
  //   } catch (e) {
  //     if (context.mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Error joining the match: $e')),
  //       );
  //     }
  //   }
  // }


class Match {
  final String createdBy;
  final Timestamp dateTime;
  final String location;
  final String matchId;
  final String skillLevel;
  final String timeOfDay; 
  final Map<String, dynamic> teamA; 
  final Map<String, dynamic> teamB;  

  Match({
    required this.createdBy,
    required this.dateTime,
    required this.location,
    required this.matchId,
    required this.skillLevel,
    required this.timeOfDay,  
    required this.teamA,
    required this.teamB,
  });

  factory Match.fromJson(Map<String, dynamic> json) {
    return Match(
      createdBy: json['createdBy'] ?? '',
      dateTime: json['dateTime'] ?? Timestamp.now(),
      location: json['location'] ?? '',
      matchId: json['matchId'] ?? '',
      skillLevel: json['skillLevel'] ?? '',
      timeOfDay: json['timeOfDay'] ?? 'All',
     teamA: json['teamA'] != null
        ? {
            
            'teamName': json['teamA']['teamName'] ?? '',
            'teamId': json['teamA']['teamId'] ?? '',
          }
        : {'teamName': '', 'teamId': ''},  
    teamB: json['teamB'] != null
        ? {
           
            'teamName': json['teamB']['teamName'] ?? '',
            'teamId': json['teamB']['teamId'] ?? '',
          }
        : { 'teamName': '', 'teamId': ''},
    );
  }
}

abstract class MatchEvent {}

class FetchMatchEvent extends MatchEvent {}

abstract class MatchState {}

class MatchItemLoading extends MatchState {}

class MatchItemLoaded extends MatchState {
  final List<Match> matches;
  // final num playerInTeamA;
  // final num playerInTeamB;

  MatchItemLoaded({
    required this.matches,
    // required this.playerInTeamA,
    // required this.playerInTeamB,
  });
}

class Error extends MatchState {
  final String error;
  Error(this.error);
}

class MatchBloc extends Bloc<MatchEvent, MatchState> {
  final FirebaseFirestore store = FirebaseFirestore.instance;

  MatchBloc() : super(MatchItemLoading()) {
    on<FetchMatchEvent>(_onFetchMatch);
  }

  void _onFetchMatch(MatchEvent event, Emitter<MatchState> emit) async {
    emit(MatchItemLoading());
    try {
      List<Match> matches = [];
      QuerySnapshot snapshot = await store.collection('Match').get();

      print('Documents found: ${snapshot.docs.length}');
      for (var doc in snapshot.docs) {
        print('Document data: ${doc.data()}');
      }

      matches = snapshot.docs.map((doc) {
        return Match.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();

      
      emit(MatchItemLoaded(
        matches: matches,
        // playerInTeamA: playerInTeamA,
        // playerInTeamB: playerInTeamB,

      ));
    } catch (e) {
      emit(Error(e.toString()));
    }
  }

  
 
}

