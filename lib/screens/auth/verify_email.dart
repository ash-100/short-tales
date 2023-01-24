import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:short_tales/constants.dart';

import '../home_screen.dart';

class VerifyEmail extends StatelessWidget {
  const VerifyEmail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF4B91F1),
        body: Column(
          children: [
            Container(
              color: Colors.blue,
              height: MediaQuery.of(context).size.height * 0.68,
              child: Image.asset('assets/images/logo.png'),
            ),
            ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25), topRight: Radius.circular(25)),
              child: Container(
                color: Colors.white,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Check your email',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        'A link has been sent to your email for verification. Please click on the link sent to your email for verification.',
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                      Row(
                        children: [
                          TextButton(
                            child: Text('Click here'),
                            onPressed: () async {
                              await FirebaseAuth.instance.currentUser
                                  ?.sendEmailVerification();
                              var snackBar = SnackBar(
                                  content: Text(
                                      'A verification email has been sent'));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            },
                          ),
                          Text('to sent the mail again'),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 1),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(40))),
                        ),
                        onPressed: () {
                          if (firebaseAuth.currentUser!.emailVerified == true) {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomeScreen()),
                                (route) => false);
                          } else {
                            var snackBar = SnackBar(
                                content: Text('Verify your email to continue'));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            'Verify',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.white,
              ),
            )
          ],
        ));
  }
}
