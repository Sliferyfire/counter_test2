// import 'package:countertes/pages/home_page.dart';
import 'package:counter_test2/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
    apiKey: 'AIzaSyCjutYO9cACg3xew1EBFxlWX7EnnxRmKc4',
    appId: '1:288372919139:web:0756321b4b3d820502a156',
    messagingSenderId: '288372919139',
    projectId: 'countertest-84123',
    authDomain: 'countertest-84123.firebaseapp.com',
    databaseURL: 'https://countertest-84123-default-rtdb.firebaseio.com',
    storageBucket: 'countertest-84123.appspot.com',
  ));
  if (kIsWeb) {
    // initialiaze the facebook javascript SDK
    await FacebookAuth.i.webAndDesktopInitialize(
      appId: "1928350454272133",
      cookie: true,
      xfbml: true,
      version: "v15.0",
    );
  }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      home: LoginPage(),
    );
  }
}
