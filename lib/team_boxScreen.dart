
import 'package:flutter/material.dart';
import 'teamMembers_screen.dart';
import 'team_managementScreen.dart';

class TeamBox extends StatelessWidget {
  final Team team;
  const TeamBox({super.key, required this.team});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 10.0,
              spreadRadius: 2.0,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              // CircleAvatar(
              //   radius: 60,
              //   backgroundImage: team.captain['captainProfilePic'] != null &&
              //           team.captain['captainProfilePic'] != ''
              //       ? NetworkImage(team.captain['captainProfilePic'])
              //           as ImageProvider
              //       : const AssetImage("images/man.jpg"),
                    

              //   backgroundColor: Colors.grey.shade200,
              // ),
CircleAvatar(
  radius: 60,
  backgroundImage: team.captain['captainProfilePic'] != null &&
          team.captain['captainProfilePic'] != ''
      ? (team.captain['captainProfilePic'].startsWith('http')
          ? NetworkImage(team.captain['captainProfilePic'])
          : AssetImage(team.captain['captainProfilePic'])) as ImageProvider
      : const AssetImage("images/man.png"),
  backgroundColor: Colors.grey.shade200,
),
              
              const SizedBox(height: 16),
       
              Text(
                team.teamName,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: const Color(0xFF2a6068),
                ),
              ),
              const SizedBox(height: 12),
           
              Divider(
                color: const Color(0xFF2a6068),
                thickness: 1.0,
              ),
              const SizedBox(height: 12),


      
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildActionButton(
                    context: context,
                    label: "View Stats",
                    onPressed: () {
                      _showTeamStats(context, team.stats);
                    },
                  ),

 _buildActionButton(
                    context: context,
                    label: "View Members",
                    onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TeamMembersScreen(teamId: team.teamId, team_name: team.teamName,),
      ),
    );
  },
                  ),
               
                ]
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget _buildStatColumn(String title, int? value) {
  //   return Column(
  //     mainAxisSize: MainAxisSize.min,
  //     children: [
  //       Text(
  //         value?.toString() ?? "0",
  //         style: const TextStyle(
  //           fontSize: 20,
  //           fontWeight: FontWeight.bold,
  //           color: const Color(0xFF2a6068),
  //         ),
  //       ),
  //       const SizedBox(height: 4),
  //       Text(
  //         title,
  //         style: const TextStyle(
  //           fontSize: 14,
  //           color: Colors.grey,
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildActionButton({
    required BuildContext context,
    required String label,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF2a6068),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 2.0,
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.white,
        ),
      ),
    );
  }


  void _showTeamStats(BuildContext context, Map<String, int> stats) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Team Stats',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2a6068),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatCard(
                    context,
                    icon: Icons.emoji_events,
                    label: 'Wins',
                    count: stats['wins']!,
                    color: Colors.green.shade400,
                  ),
                  _buildStatCard(
                    context,
                    icon: Icons.handshake,
                    label: 'Draws',
                    count: stats['draws']!,
                    color: Colors.amber.shade400,
                  ),
                  _buildStatCard(
                    context,
                    icon: Icons.thumb_down,
                    label: 'Losses',
                    count: stats['losses']!,
                    color: Colors.red.shade400,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required int count,
    required Color color,
  }) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color, size: 30),
        ),
        const SizedBox(height: 8),
        Text(
          '$count',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
        ),
      ],
    );
  }
}

