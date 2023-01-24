import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:short_tales/constants.dart';
import 'package:short_tales/screens/auth/login_screen.dart';
import 'package:short_tales/models/user.dart' as model;
import 'package:short_tales/screens/auth/verify_email.dart';

import '../home_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController _nameController = TextEditingController();
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
              height: MediaQuery.of(context).size.height * 0.39,
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
                          'Username',
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
                            controller: _nameController,
                            decoration: InputDecoration(
                                icon: Icon(Icons.person),
                                labelText: 'Username',
                                border: InputBorder.none),
                          ),
                        ),
                      ),
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
                      SizedBox(
                        height: 16,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 1),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(40))),
                        ),
                        onPressed: () async {
                          if (_nameController.text.toString().trim().isEmpty ||
                              _emailController.text.toString().trim().isEmpty ||
                              _passwordController.text
                                  .toString()
                                  .trim()
                                  .isEmpty) {
                            var snackBar =
                                SnackBar(content: Text('Enter valid details'));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          } else {
                            try {
                              final credential = await firebaseAuth
                                  .createUserWithEmailAndPassword(
                                email: _emailController.text,
                                password: _passwordController.text,
                              );
                              if (credential.user != null) {
                                model.User user = model.User(
                                    name:
                                        _nameController.text.toString().trim(),
                                    email:
                                        _emailController.text.toString().trim(),
                                    uid: credential.user!.uid,
                                    premium: false,
                                    premiumEndDate: DateTime.now(),
                                    noOfFreeStories: 3,
                                    favouriteGenres: [],
                                    favouriteStories: []);
                                await firestore
                                    .collection('users')
                                    .doc(credential.user!.uid)
                                    .set(user.toJson());
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomeScreen()),
                                    (route) => false);
                              }
                            } on FirebaseAuthException catch (e) {
                              if (e.code == 'weak-password') {
                                print('The password provided is too weak.');
                                var snackBar = SnackBar(
                                    content: Text(
                                        'The password provided is too weak'));
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              } else if (e.code == 'email-already-in-use') {
                                print(
                                    'The account already exists for that email.');
                                var snackBar = SnackBar(
                                    content: Text(
                                        'The account already exists for that email'));
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              }
                            } catch (e) {
                              print(e);
                            }
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            'Register',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Have an account?',
                            style: TextStyle(fontSize: 15),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginScreen()));
                            },
                            child: Text(
                              'Login',
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
              ),
            )
          ],
        ));
  }
}
