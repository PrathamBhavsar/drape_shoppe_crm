import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomeProvider extends ChangeNotifier {
  static final HomeProvider instance = HomeProvider._privateConstructor();
  HomeProvider._privateConstructor();

  List<String> userNames = [];
  List<String> taskStatus = [
    "Pending",
    "Closed - lost",
    "Closed - won",
    "Measurement",
    "Quote review",
    "Site long delay",
    "So & advance",
    "Store visit / selection"
  ];

  Future<void> getUsers() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('users').get();

      // Extract user names from the snapshot
      List<String> names =
          snapshot.docs.map((doc) => doc['user_name'] as String).toList();

      userNames = names;
      notifyListeners();
    } catch (e) {
      print('Error fetching users: $e');
    }
  }
}
