import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:short_tales/controllers/auth_controller.dart';
import 'package:short_tales/screens/home_nav_pages/accounts.dart';
import 'package:short_tales/screens/home_nav_pages/favourite.dart';
import 'package:short_tales/screens/home_nav_pages/home.dart';
import 'package:short_tales/screens/home_nav_pages/search.dart';

var firebaseAuth = FirebaseAuth.instance;
var firestore = FirebaseFirestore.instance;
//var currentUser = firebaseAuth.currentUser;

var authController = AuthController();

List pages = [
  Home(),
  SearchScreen(),
  FavouriteScreen(),
  AccountScreen(),
];
