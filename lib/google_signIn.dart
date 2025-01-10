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
  return await FirebaseAuth.instance.signInWithCredential(credential);
}


}

