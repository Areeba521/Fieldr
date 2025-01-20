import 'package:fieldr_project/first_screen.dart';
import 'package:fieldr_project/match_finder.dart';
import 'package:fieldr_project/team_managementScreen.dart';
import 'package:fieldr_project/theme_set.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class ParentScreen extends StatefulWidget {
  const ParentScreen({Key? key}) : super(key: key);

  @override
  State<ParentScreen> createState() => _ParentScreenState();
}

class _ParentScreenState extends State<ParentScreen> {
  int _selectedIndex = 0; 

  
  final List<Widget> _screens = [
    BlocProvider(
      create: (context) => MatchBloc()..add(FetchMatchEvent()),
      child: const MatchFinderScreen(),
    ),
    BlocProvider(
      create: (context) => TeamBloc()..add(FetchTeamEvent()),
      child: const TeamManagementScreen(),
    ),
  ];

  

 @override
  Widget build(BuildContext context) {

    User? user = FirebaseAuth.instance.currentUser;
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Fieldr" , style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold) ,),
        backgroundColor: const Color(0xFF2a6068),),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: const Color(0xFF2a6068)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 30),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    user?.email ?? 'Guest',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
 
      ListTile(
  leading: Icon(
    themeProvider.themeMode == ThemeMode.dark
        ? Icons.dark_mode
        : Icons.light_mode,
  ),
  title: const Text("Color Mode"),
  trailing: Switch(
    value: themeProvider.themeMode == ThemeMode.dark,
    onChanged: (value) {
      themeProvider.toggleTheme(value);
    },
    activeColor: Theme.of(context).primaryColor,
    inactiveThumbColor: Colors.grey,
    inactiveTrackColor: Colors.grey.shade300,
  ),
),

            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              onTap: _logout, 
            ),

            
          ],
        ),
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_football_rounded),
            label: "Match Finder",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: "Team Management",
          ),
        ],
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        backgroundColor: const Color(0xFF2a6068),
      ),
    );
  }


  void _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MyFirstScreen()), 
    );
  }
}
