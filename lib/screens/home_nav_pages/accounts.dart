import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:short_tales/constants.dart';
import 'package:short_tales/models/user.dart';
import 'package:short_tales/screens/auth/login_screen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  User user = User(
      name: '',
      email: '',
      uid: '',
      premium: false,
      premiumEndDate: DateTime.now(),
      favouriteGenres: [],
      noOfFreeStories: 0,
      favouriteStories: []);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserInfo();
  }

  Future getUserInfo() async {
    DocumentSnapshot userDoc = await firestore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .get();
    User _user = User.fromSnap(userDoc);
    setState(() {
      user = _user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Image.asset('assets/images/logo.png'),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                margin: EdgeInsets.all(8),
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(25)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Hello, ',
                      style: TextStyle(fontSize: 25),
                    ),
                    Text(
                      user.name,
                      style: TextStyle(fontSize: 25),
                    ),
                  ],
                ),
              ),
            ),
            ElevatedButton(
                onPressed: () async {
                  await firebaseAuth.signOut();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                      (route) => false);
                },
                child: Text('Log out')),
          ],
        ),
      ),
    );
  }
}
