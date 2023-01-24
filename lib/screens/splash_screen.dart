import 'dart:async';

import 'package:flutter/material.dart';
import 'package:short_tales/constants.dart';
import 'package:short_tales/screens/auth/verify_email.dart';
import 'package:short_tales/screens/home_screen.dart';
import 'package:short_tales/screens/intro_screen.dart';
import 'package:short_tales/screens/auth/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 2), () {
      var currentUser = firebaseAuth.currentUser;
      if (currentUser == null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => IntroScreen()));
        // } else if (currentUser.emailVerified == false) {
        //   Navigator.pushReplacement(
        //       context, MaterialPageRoute(builder: (context) => VerifyEmail()));
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: Color(0xFF4B91F1),
          child: Center(
            child: Image.asset('assets/images/logo.png'),
          )),
    );
  }
}
