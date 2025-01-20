import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fieldr_project/parent_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';


class LoginInScreen extends StatelessWidget {
  const LoginInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async{
            UserCredential userCredential = await signInWithGoogle();
            if (userCredential.user != null) {
           
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const ParentScreen()),
              );
            }
          },
          child: const Text("Sign in with Google"),
        ),
      ),
    );
  }


Future<UserCredential> signInWithGoogle() async {
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

 
  UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
  User? user = userCredential.user;

  if (user != null) {

    CollectionReference usersCollection = FirebaseFirestore.instance.collection('User');

    
    DocumentSnapshot userDoc = await usersCollection.doc(user.uid).get();

    if (!userDoc.exists) {
   
      QuerySnapshot totalUsersSnapshot = await usersCollection.get();
      int totalUsers = totalUsersSnapshot.docs.length;

     
      String newUserId = 'user${(totalUsers + 1).toString().padLeft(3, '0')}';

 
      await usersCollection.doc(user.uid).set({
        'email': user.email,
        'username': googleUser!.displayName ?? 'Unknown User',
        'role': 'User', // Set default role
        'stats': 0, // Default value
        'teamId': null, // Default value
        'profilePicture': "https://karachiunited.com/wp-content/uploads/2023/12/av-1.jpg", // Default value
        'userId': newUserId,
      });
    }
  }

  return userCredential;
}


}

