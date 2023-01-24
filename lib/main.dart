import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:short_tales/firebase_options.dart';
import 'package:short_tales/screens/auth/forgot_password.dart';
import 'package:short_tales/screens/auth/login_screen.dart';
import 'package:short_tales/screens/auth/register_screen.dart';
import 'package:short_tales/screens/splash_screen.dart';
import 'package:short_tales/screens/auth/verify_email.dart';

void main() async {
  runApp(const MyApp());
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Short Tales',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Short Tales'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen();
  }
}
