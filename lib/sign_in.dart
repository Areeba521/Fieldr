
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fieldr_project/parent_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'signup_screen.dart';



class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _signInWithEmailAndPassword() async {
    try {
      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim());

      if (userCredential.user != null) {
    
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ParentScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == 'user-not-found') {
        message = 'No user found for this email.';
      } else if (e.code == 'wrong-password') {
        message = 'Incorrect password.';
      } else {
        message = 'An error occurred. Please try again.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter, colors: [
          Color(0xFF2a6068),
          Color(0xFF3b808b),
          Color(0xFF4a9aa4)
        ])),
        child: SafeArea(
          child: ListView(
            children: [
              SizedBox(height: size.height * 0.03),
              Text(
                'Fieldr',
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.w700,
                  fontSize: 37,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
              const SizedBox(height: 15),
              Text(
                'Where Every Match Begins',
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.w500,
                  fontSize: 27,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
              SizedBox(height: size.height * 0.04),
              _myTextField(
                  "Enter email", Colors.white, _emailController, false),
              _myTextField(
                  "Enter password", Colors.black26, _passwordController, true),
              const SizedBox(height: 10),
              SizedBox(height: size.height * 0.04),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _signInWithEmailAndPassword,
                      child: Container(
                        width: size.width,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF293232),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Center(
                          child: Text(
                            "Sign In",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 229, 223, 223),
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.06),
                     GestureDetector(
                      onTap: () async {
                        UserCredential userCredential = await signInWithGoogle();
                        if (userCredential.user != null) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ParentScreen()),
                          );
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 15,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Image.asset(
                              "images/google.png",
                              height: 35,
                            ),
                            const Text(
                              "         Sign in With Google",
                              style: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 229, 223, 223),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.07),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MySignupPage()), 
                        );
                      },
                      child: RichText(
                        text: const TextSpan(
                          text: "Not a member? ",
                          style: TextStyle(
                            color: Color.fromARGB(238, 192, 188, 188),
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                          children: [
                            TextSpan(
                              text: "Register now",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }


  Container _myTextField(String hint, Color color, TextEditingController controller,
      bool isPassword) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 25,
        vertical: 10,
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        style: const TextStyle(
        color: Colors.black, 
        fontSize: 18,       
      ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 22,
          ),
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(15),
          ),
          hintText: hint,
          hintStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 19,
          ),
          // suffixIcon: Icon(
          //   Icons.visibility_off_outlined,
          //   color: color,
          // ),
        ),
      ),
    );
  }
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
        'name': googleUser!.displayName ?? 'Unknown User',
        'role': 'Regular Player', 
        'stats': {
            'assists': 0,
            'goals': 0,
            'matchesPlayed': 0,
          },
        'teamId': "", 
        'profilePicture': "https://karachiunited.com/wp-content/uploads/2023/12/av-1.jpg", 
        'userId': newUserId,
      });
    }
  }

  return userCredential;
}
