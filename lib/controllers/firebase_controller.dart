import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drape_shoppe_crm/main.dart';
import 'package:drape_shoppe_crm/models/user.dart';
import 'package:drape_shoppe_crm/screens/home/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class FirebaseController {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseController instance =
      FirebaseController._privateConstructor();
  FirebaseController._privateConstructor();

  Future<void> login(BuildContext context, String email, String password,
      String userName) async {
    try {
      // Firebase sign in
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      // Save login state to SharedPreferences
      await _saveLoginState(credential.user!.uid);
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => HomeScreen(),
      ));
    } catch (error) {
      print('Error during login: $error');
      Fluttertoast.showToast(
        msg: error.toString(),
      );
    }
  }

  Future<void> signup(String email, String password, String userName) async {
    try {
      // Firebase sign in
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      // Create the UserModel object
      String now = DateTime.now().toString();
      UserModel user = UserModel(
        createdAt: now,
        userName: userName,
      );

      // Save user to Firestore using user's UID
      _firestore.collection('users').doc(email).set(user.toJson());

      // Save login state to SharedPreferences
      await _saveLoginState(credential.user!.uid);
    } catch (error) {
      print('Error during signUp: $error');
      Fluttertoast.showToast(
        msg: error.toString(),
      );
    }
  }

  // Function to save the login state in SharedPreferences
  Future<void> _saveLoginState(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('userId', userId);
  }

  // Function to handle logout
  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    await prefs.remove('userId');
    await FirebaseAuth.instance.signOut();

    // Navigate back to the login screen
    Navigator.of(context).pushReplacementNamed('/login');
  }
}
