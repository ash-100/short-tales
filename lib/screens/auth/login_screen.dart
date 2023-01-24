import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:short_tales/constants.dart';
import 'package:short_tales/screens/auth/forgot_password.dart';
import 'package:short_tales/screens/auth/register_screen.dart';
import 'package:short_tales/screens/auth/verify_email.dart';
import 'package:short_tales/screens/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  bool _hidePassword = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(0xFF4B91F1),
        body: Column(
          children: [
            Container(
              color: Colors.blue,
              height: MediaQuery.of(context).size.height * 0.45,
              child: Image.asset('assets/images/logo.png'),
            ),
            ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25), topRight: Radius.circular(25)),
              child: Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 8, top: 8),
                        child: Text(
                          'Email',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          child: TextField(
                            controller: _emailController,
                            decoration: InputDecoration(
                                icon: Icon(Icons.email),
                                labelText: 'Email',
                                border: InputBorder.none),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 8, top: 8),
                        child: Text(
                          'Password',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          child: TextField(
                            controller: _passwordController,
                            obscureText: _hidePassword,
                            decoration: InputDecoration(
                                icon: Icon(Icons.lock),
                                labelText: 'Password',
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _hidePassword = !_hidePassword;
                                    });
                                  },
                                  icon: _hidePassword
                                      ? Icon(Icons.visibility_off)
                                      : Icon(Icons.visibility),
                                ),
                                border: InputBorder.none),
                          ),
                        ),
                      ),
                      Container(
                        child: TextButton(
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ForgotPasswordScreen()));
                          },
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 1),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(40))),
                        ),
                        onPressed: () async {
                          if (_emailController.text.toString().trim().isEmpty ||
                              _passwordController.text
                                  .toString()
                                  .trim()
                                  .isEmpty) {
                            var snackBar =
                                SnackBar(content: Text('Enter valid details'));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          } else {
                            if (FirebaseAuth.instance.currentUser != null) {
                              await FirebaseAuth.instance.signOut();
                            }
                            try {
                              final credential =
                                  await firebaseAuth.signInWithEmailAndPassword(
                                      email: _emailController.text,
                                      password: _passwordController.text);
                              if (credential.user != null) {
                                // if (credential.user!.emailVerified == false) {
                                //   Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => VerifyEmail()),
                                //   );
                                // } else {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomeScreen()),
                                    (route) => false);
                                //}
                              }
                            } on FirebaseAuthException catch (e) {
                              if (e.code == 'user-not-found') {
                                print('No user found for that email.');
                                var snackBar = SnackBar(
                                    content:
                                        Text('No user found for that email'));
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              } else if (e.code == 'wrong-password') {
                                print('Wrong password provided for that user.');
                                var snackBar =
                                    SnackBar(content: Text('Wrong password'));
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              }
                            }
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            'Login',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Don\'t have an account?',
                            style: TextStyle(fontSize: 15),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RegisterScreen()));
                            },
                            child: Text(
                              'Register',
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
                child: Container(
              color: Colors.white,
            ))
          ],
        ));
  }
}
