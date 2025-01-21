import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fieldr_project/parent_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'firebase_options.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';
import 'first_screen.dart';
import 'theme_set.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);


  await Hive.initFlutter();
  await Hive.openBox('settings');
  await Hive.openBox('userBox');
  
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MainApp(),
    )
  );

    //const MainApp());
}



// class MainApp extends StatelessWidget {
//   const MainApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final themeProvider = Provider.of<ThemeProvider>(context);

//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       themeMode: themeProvider.themeMode,
//       // theme: ThemeData.light(),
//       // darkTheme: ThemeData.dark(),
//       theme: AppTheme.lightTheme,
//       darkTheme: AppTheme.darkTheme,
//       home: StreamBuilder<User?>(
//         stream: FirebaseAuth.instance.authStateChanges(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
 
//           if (snapshot.hasData) {
//             return const ParentScreen(); 
//           }
//           return const MyFirstScreen(); 
//         },
//       ),
//     );
//   }
// }

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  Future<void> _initializeUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
 
      final userDoc = await FirebaseFirestore.instance
          .collection('User')
          .where('email', isEqualTo: user.email)
          .get();

      if (userDoc.docs.isNotEmpty) {
        final userData = userDoc.docs.first.data();

        
        final userBox = Hive.box('userBox');
        userBox.put('email', userData['email']);
        userBox.put('role', userData['role']);
        userBox.put('userId', userData['userId']);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.themeMode,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: FutureBuilder(
        future: _initializeUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (FirebaseAuth.instance.currentUser != null) {
           
            final userBox = Hive.box('userBox');
            final role = userBox.get('role');

            if (role == 'Team Captain') {
              return const ParentScreen(); 
            } else {
              return const ParentScreen(); 
            }
          }

          return const MyFirstScreen();
        },
      ),
    );
  }
}

