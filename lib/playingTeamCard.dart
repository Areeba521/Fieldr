import 'package:flutter/material.dart';

class TeamCard extends StatelessWidget {
  final String teamName;
  final Color cardColor;
  final IconData icon;

  TeamCard({
    required this.teamName,
    required this.cardColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      margin: const EdgeInsets.only(bottom: 8),
      
      decoration: BoxDecoration(
        color: cardColor,  
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: Offset(0, 2), 
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 25), 
          const SizedBox(width: 12),
          Text(
            teamName,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}