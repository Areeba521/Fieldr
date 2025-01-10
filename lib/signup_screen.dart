import 'package:fieldr_project/sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';



class MySignupPage extends StatefulWidget {
  const MySignupPage({super.key});

  @override
  State<MySignupPage> createState() => _MySignupPageState();
}

class _MySignupPageState extends State<MySignupPage> {
  
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confPasswordController = TextEditingController();
  
 
  String? errorMessage;

void _signup() async {

  print('Signup method called');
  print('Email: ${emailController.text.trim()}');
  print('Password: ${passwordController.text.trim()}');

  setState(() {
    errorMessage = null;
  });

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    },
  );

  try {
   
    if (emailController.text.trim().isEmpty) {
      throw FirebaseAuthException(code: 'empty-email');
    }
    if (passwordController.text.trim().isEmpty) {
      throw FirebaseAuthException(code: 'empty-password');
    }
    if (passwordController.text != confPasswordController.text) {
      throw FirebaseAuthException(code: 'passwords-do-not-match');
    }


    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(emailController.text.trim())) {
      throw FirebaseAuthException(code: 'invalid-email');
    }

    if (passwordController.text.trim().length < 6) {
      throw FirebaseAuthException(code: 'weak-password');
    }

    UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    print('User created successfully: ${userCredential.user?.uid}');

    await createUserNode(userCredential.user);


    if (context.mounted) {
      Navigator.of(context).pop(); 
    }

   
  Navigator.pushReplacement(
  context,
  MaterialPageRoute(builder: (context) => SignIn()),
);
  } on FirebaseAuthException catch (e) {
    print('Firebase Auth Exception: ${e.code}');
    
  
    if (context.mounted) {
      Navigator.of(context).pop(); 
    }

    setState(() {
      switch (e.code) {
        case 'weak-password':
          errorMessage = 'The password is too weak.';
          break;
        case 'email-already-in-use':
          errorMessage = 'An account already exists with this email.';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email address.';
          break;
        case 'empty-email':
          errorMessage = 'Email cannot be empty.';
          break;
        case 'empty-password':
          errorMessage = 'Password cannot be empty.';
          break;
        case 'passwords-do-not-match':
          errorMessage = 'Passwords do not match.';
          break;
        default:
          errorMessage = 'Sign up failed. Please try again.';
      }
    });
  } catch (e) {
    print('Unexpected error: $e');
    
    
    if (context.mounted) {
      Navigator.of(context).pop(); 
    }
    
    setState(() {
      errorMessage = 'An unexpected error occurred.';
    });
  }
}


  
  Future<void> createUserNode(User? user) async {
    if (user != null) {
      try {
        DatabaseReference userRef = FirebaseDatabase.instance.ref().child('users').child(user.uid);
        await userRef.set({
          'email': user.email,
          'createdAt': DateTime.now().toIso8601String(),
        });
        print('User node created successfully');
      } catch (e) {
        print('Error creating user node: $e');
        rethrow;
      }
    }
  }

  @override
  void dispose() {

    emailController.dispose();
    passwordController.dispose();
    confPasswordController.dispose();
    super.dispose();
  }
 @override
  Widget build(BuildContext context) {
    const Color tealColor = Color(0xFF2a6068);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: tealColor,
        title: const Text('Sign Up', style: TextStyle(color: Colors.white,)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Create an Account',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: tealColor,
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            TextField(
              controller: emailController,
              cursorColor: tealColor,
              decoration: InputDecoration(
                labelText: 'Enter Email',
                labelStyle: TextStyle(color: tealColor),
                prefixIcon: const Icon(Icons.email, color: tealColor),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: tealColor),
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: tealColor),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: passwordController,
              obscureText: true,
              cursorColor: tealColor,
              decoration: InputDecoration(
                labelText: 'Enter Password',
                labelStyle: TextStyle(color: tealColor),
                prefixIcon: const Icon(Icons.lock, color: tealColor),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: tealColor),
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: tealColor),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: confPasswordController,
              obscureText: true,
              cursorColor: tealColor,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                labelStyle: TextStyle(color: tealColor),
                prefixIcon: const Icon(Icons.lock, color: tealColor),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: tealColor),
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: tealColor),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            if (errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Text(
                  errorMessage!,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _signup();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: tealColor,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Sign Up', style: TextStyle(color: Colors.white),),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
              Navigator.pushReplacement(
  context,
  MaterialPageRoute(builder: (context) => SignIn()),
);
              },
              child: Text(
                'Already have an account? Login',
                style: TextStyle(color: tealColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}