import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomeProvider extends ChangeNotifier {
  static final HomeProvider instance = HomeProvider._privateConstructor();
  HomeProvider._privateConstructor();

  List<String> userNames = [];
  // List<String> taskStatus = [
  //   "Pending",
  //   "Closed - lost",
  //   "Closed - won",
  //   "Measurement",
  //   "Quote review",
  //   "Site long delay",
  //   "So & advance",
  //   "Store visit / selection"
  // ];

  List<String> pickedFile = [];

  List<Map<String, dynamic>> taskStatus = [
    {
      "text": "Pending",
      "primaryColor": Colors.blue,
      "secondaryColor": Color(0x660000FF)
    },
    {
      "text": "Closed - lost",
      "primaryColor": Colors.green,
      "secondaryColor": Color(0x6600FF00)
    },
    {
      "text": "Closed - won",
      "primaryColor": Colors.purple,
      "secondaryColor": Color(0x66800080)
    },
    {
      "text": "Measurement",
      "primaryColor": Colors.orange,
      "secondaryColor": Color(0x66FFA500)
    },
    {
      "text": "Quote review",
      "primaryColor": Colors.teal,
      "secondaryColor": Color(0x66008080)
    },
    {
      "text": "Site long delay",
      "primaryColor": Colors.pink,
      "secondaryColor": Color(0x66FFB6C1)
    },
    {
      "text": "So & advance",
      "primaryColor": Colors.grey,
      "secondaryColor": Color(0x66B0B0B0)
    },
    {
      "text": "Store visit / selection",
      "primaryColor": Colors.amber,
      "secondaryColor": Color(0x66FFD700)
    }
  ];

  late String selectedStatus = taskStatus[0]["text"];
  int selectedStatusIndex = 0;

  void setSelectedStatus(int index) {
    selectedStatus = taskStatus[index]["text"];
    selectedStatusIndex = index;
    notifyListeners();
  }

  Future<void> getUsers() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('users').get();

      List<String> names =
          snapshot.docs.map((doc) => doc['user_name'] as String).toList();

      userNames = names;
      notifyListeners();
    } catch (e) {
      print('Error fetching users: $e');
    }
  }
}
