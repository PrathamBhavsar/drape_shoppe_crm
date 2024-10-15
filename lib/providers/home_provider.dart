import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drape_shoppe_crm/controllers/firebase_controller.dart';
import 'package:drape_shoppe_crm/models/task.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';

class HomeProvider extends ChangeNotifier {
  static final HomeProvider instance = HomeProvider._privateConstructor();
  HomeProvider._privateConstructor();

  List<String> userNames = [];
  List<Map<String, dynamic>> priorityValues = [
    {"text": "Low", "color": const Color.fromARGB(255, 182, 255, 220)},
    {"text": "Medium", "color": const Color.fromARGB(255, 254, 254, 226)},
    {"text": "High", "color": const Color.fromARGB(255, 255, 160, 160)},
  ];

  late String selectedPriority = priorityValues[0]["text"];
  int selectedPriorityIndex = 0;

  List<String> pickedFile = [];

  DateTime now = DateTime.now();
  String dealNo = '';

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

  void setSelectedPriority(int index) {
    selectedPriority = priorityValues[index]["text"];
    selectedPriorityIndex = index;
    notifyListeners();
  }

  Map<String, int> userTaskCount = {};

  int assignedTasks = 0;
  int dueTodayTasks = 0;
  int pastDueTasks = 0;

  Future<void> setAssignedTasks() async {
    final taskList = await FirebaseController.instance.fetchTasksList();
    Timestamp timestamp = Timestamp.now();
    DateTime dateOnly = DateTime(timestamp.toDate().year,
        timestamp.toDate().month, timestamp.toDate().day);

    assignedTasks = taskList.length;
    for (var task in taskList) {
      if (task.dueDate == dateOnly) {
        dueTodayTasks++;
      }
      if (task.dueDate.isAfter(dateOnly)) {
        pastDueTasks++;
      }
    }
    notifyListeners();
  }

  Future<void> setIncompleteTasks() async {
    // Fetch the incomplete tasks from Firestore (assuming fetchIncompleteTasks is correctly implemented)
    List<TaskModel> tasks =
        await FirebaseController.instance.fetchIncompleteTasks();

    // Initialize a map to store the usernames and the count of tasks assigned to them
    userTaskCount = {};
    // Loop through each task
    for (var task in tasks) {
      // Assuming 'assignedTo' is a list of usernames
      for (var user in task.assignedTo) {
        // If the user is already in the map, increment their task count
        if (userTaskCount.containsKey(user)) {
          userTaskCount[user] = userTaskCount[user]! + 1;
        } else {
          // Otherwise, add the user to the map with a count of 1
          userTaskCount[user] = 1;
        }
      }
    }
    notifyListeners();
    // Now you have a map of usernames and their assigned task counts
    print(userTaskCount); // For debugging, or use it as needed in your app
  }

  Future<void> setControllers(
      String dealNo,
      TextEditingController title,
      TextEditingController desc,
      TextEditingController assignedTo,
      TextEditingController designer) async {
    TaskModel task = await FirebaseController.instance.getTask(dealNo);
    title.text = task.title;
    desc.text = task.description;
    String assignedToUser = task.assignedTo.join(', ');
    assignedTo.text = assignedToUser;
    designer.text = task.designer;

    getTaskIndexFromText(task.status);
    getPriorityIndexFromText(task.priority);
    notifyListeners();
  }

  void getPriorityIndexFromText(String priority) {
    for (int index = 0; index < priorityValues.length; index++) {
      var priority = priorityValues[index];
      if (priority['text'] == priority) {
        selectedPriorityIndex = index;
      }
    }
  }

  void getTaskIndexFromText(String status) {
    for (int index = 0; index < taskStatus.length; index++) {
      var status = taskStatus[index];
      if (status['text'] == status) {
        selectedStatusIndex = index;
      }
    }
  }

  String setDealNo() {
    DateTime rightNow = DateTime.now();
    now = rightNow;
    dealNo = DateFormat('yyyyMMddHHmmss').format(rightNow);
    print(dealNo);
    print(now);
    notifyListeners();
    return dealNo;
  }

  String comment = '';
  void setComment(String text) {
    comment = text;
    print(comment);
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
