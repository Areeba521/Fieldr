<<<<<<< HEAD
//import 'package:fieldr_project/parent_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'first_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(const MainApp());
}



=======
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

>>>>>>> 16c78ab469d37117aeab4818438245c958c6ca08
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyFirstScreen(),
    
    );


    
  }


=======
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Hello World!'),
        ),
      ),
    );
  }
>>>>>>> 16c78ab469d37117aeab4818438245c958c6ca08
}
