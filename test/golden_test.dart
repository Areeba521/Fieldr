//golden test

// import 'package:fieldr_project/first_screen.dart';
// import 'package:fieldr_project/sign_in.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';


// void main() {
//   testWidgets('Golden Test', (WidgetTester tester) async {
   
//     await tester.pumpWidget(
//       MaterialApp(
//        home: MyFirstScreen(), 
   
//       ),
//     );

//     await tester.pumpAndSettle();

   
//     await expectLater(
//       find.byType(SignIn),
//       matchesGoldenFile('golden_tests/my_first_screen.png'), 
//     );
//   });
// }



import 'package:fieldr_project/main.dart';
import 'package:fieldr_project/theme_set.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

//import 'package:shared_preferences/shared_preferences.dart';


class MockFirebaseAuthPlatform extends FirebaseAuthPlatform {
  MockFirebaseAuthPlatform() : super();

  @override
  FirebaseAuthPlatform delegateFor({FirebaseApp? app}) {
    return this;
  }

  @override
  FirebaseAuthPlatform setInitialValues({
    PigeonUserDetails? currentUser,
    String? languageCode,
  }) {
    return this;
  }

  @override
  Future<void> signOut() async {}

  @override
  String get tenantId => '';

  @override
  Stream<UserPlatform?> authStateChanges() => Stream.value(null);

  @override
  Stream<UserPlatform?> idTokenChanges() => Stream.value(null);

  @override
  Stream<UserPlatform?> userChanges() => Stream.value(null);

  @override
  UserPlatform? get currentUser => null;

  @override
  Future<UserCredentialPlatform> signInWithEmailAndPassword(String email, String password) async {
    throw UnimplementedError();
  }

  @override
  Future<UserCredentialPlatform> createUserWithEmailAndPassword(String email, String password) async {
    throw UnimplementedError();
  }
}

class FakeFirebasePlatform extends FirebasePlatform {
  final Map<String, FirebaseAppPlatform> _apps = {};

  @override
  Future<FirebaseAppPlatform> initializeApp({
    String? name,
    FirebaseOptions? options,
  }) async {
    name ??= '[DEFAULT]';
    options ??= const FirebaseOptions(
      apiKey: 'fakeApiKey',
      appId: 'fakeAppId',
      messagingSenderId: 'fakeSenderId',
      projectId: 'fakeProjectId',
    );

    final app = TestFirebaseAppPlatform(name, options);
    _apps[name] = app;
    return app;
  }

  @override
  FirebaseAppPlatform app([String name = '[DEFAULT]']) {
    if (!_apps.containsKey(name)) {
      throw FirebaseException(
        plugin: 'core',
        message: 'No Firebase App $name has been created',
      );
    }
    return _apps[name]!;
  }

  @override
  List<FirebaseAppPlatform> get apps => _apps.values.toList();
}

class TestFirebaseAppPlatform extends FirebaseAppPlatform {
  TestFirebaseAppPlatform(super.name, super.options);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
   // SharedPreferences.setMockInitialValues({});
    FirebasePlatform.instance = FakeFirebasePlatform();
    FirebaseAuthPlatform.instance = MockFirebaseAuthPlatform().setInitialValues();
    await Firebase.initializeApp();
  });

  testWidgets('Golden test for the UI', (WidgetTester tester) async {
    await tester.pumpWidget(
      
      //  MaterialApp(home: const SignIn())
       //const MainApp()

      MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: MainApp(),
    ),

       );
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('test/ui_sc.png'),
    );
  });
}