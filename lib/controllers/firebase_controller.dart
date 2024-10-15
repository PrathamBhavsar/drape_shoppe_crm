import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drape_shoppe_crm/models/comment.dart';
import 'package:drape_shoppe_crm/models/task.dart';
import 'package:drape_shoppe_crm/models/user.dart';
import 'package:drape_shoppe_crm/providers/home_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class FirebaseController {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseStorage _storage = FirebaseStorage.instance;
  static final FirebaseController instance =
      FirebaseController._privateConstructor();
  FirebaseController._privateConstructor();

  // Future<Map<String, dynamic>> fetchTasksList() async {
  //   Map<String, dynamic> tasks = {};
  //   await _firestore
  //       .collection('tasks')
  //       .where("progress", isEqualTo: 100)
  //       .get()
  //       .then((snapshot) {
  //     for (var docSnapshot in snapshot.docs) {
  //       tasks.addAll(docSnapshot.data());
  //     }
  //   });
  //   return tasks;
  // }

  Future<List<TaskModel>> fetchIncompleteTasks() async {
    List<TaskModel> incompleteTasks = [];
    final querySnapshot = await _firestore
        .collection('tasks')
        .where("status", isNotEqualTo: "Closed - lost")
        .get();

    final filteredDocs = querySnapshot.docs
        .where((doc) => doc["status"] != "Closed - won")
        .toList();

    for (var docSnapshot in filteredDocs) {
      incompleteTasks.add(TaskModel.fromJson(docSnapshot.data()));
    }

    return incompleteTasks;
  }

  Future<List<TaskModel>> fetchTasksList() async {
    List<TaskModel> tasks = [];
    await _firestore
        .collection('tasks')
        .where("progress", isEqualTo: 100)
        .get()
        .then((snapshot) {
      for (var docSnapshot in snapshot.docs) {
        tasks.add(TaskModel.fromJson(docSnapshot.data()));
      }
    });
    return tasks;
  }

  Future<TaskModel> getTask(String dealNo) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _firestore.collection('tasks').doc(dealNo).get();
    TaskModel task = TaskModel.fromJson(snapshot.data()!);
    return task;
  }

  Future<CommentModel> addComment() async {
    String comment = HomeProvider.instance.comment;
    DateTime now = DateTime.now();
    String? user = _auth.currentUser!.email;
    return CommentModel(user: user!, createdAt: now, comment: comment);
  }

  Future<List<CommentModel>> fetchComments(String dealNo) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _firestore.collection('tasks').doc(dealNo).get();

    Map<String, dynamic> comments = snapshot['comments'];

    return comments.entries.map((entry) {
      return CommentModel.fromJson(entry.value);
    }).toList();
  }

  Future<void> setTask(
      String priority,
      String title,
      String description,
      String designer,
      int progress,
      String status,
      List<String> assignedTo,
      List<String> fileDir) async {
    DateTime now = HomeProvider.instance.now;
    String dealNo = HomeProvider.instance.dealNo;
    String? createdBy = _auth.currentUser!.email;

    // Upload attachments and get their URLs
    List<String> attachmentUrls = await storeAttachments(dealNo, fileDir);
    CommentModel comment = CommentModel(
        user: createdBy!,
        createdAt: now,
        comment: HomeProvider.instance.comment);
    // Log to ensure URLs are collected
    print(attachmentUrls);

    // Create the task model
    TaskModel task = TaskModel(
      dealNo: dealNo,
      createdAt: now,
      createdBy: createdBy,
      assignedTo: assignedTo,
      priority: priority,
      title: title,
      description: description,
      dueDate: now,
      designer: designer,
      comments: {dealNo: comment},
      status: status,
      progress: progress,
      attachments: attachmentUrls,
    );

    // Store the task in Firestore
    await _firestore.collection('tasks').doc(dealNo).set(task.toJson());
  }

  Future<void> editTask(
      String dealNo,
      String priority,
      String title,
      String description,
      String designer,
      int progress,
      String status,
      List<String> assignedTo,
      List<String> fileDir) async {
    DateTime now = HomeProvider.instance.now;
    String? createdBy = _auth.currentUser!.email;

    // Upload attachments and get their URLs
    List<String> attachmentUrls = await storeAttachments(dealNo, fileDir);
    CommentModel comment = CommentModel(
        user: createdBy!,
        createdAt: now,
        comment: HomeProvider.instance.comment);
    // Log to ensure URLs are collected
    print(attachmentUrls);

    // Create the task model
    TaskModel task = TaskModel(
      dealNo: dealNo,
      createdAt: now,
      createdBy: createdBy,
      assignedTo: assignedTo,
      priority: priority,
      title: title,
      description: description,
      dueDate: now,
      designer: designer,
      comments: {dealNo: comment},
      status: status,
      progress: progress,
      attachments: attachmentUrls,
    );

    // Store the task in Firestore
    await _firestore.collection('tasks').doc(dealNo).set(task.toJson());
  }

  Future<List<String>> storeAttachments(
      String dealNo, List<String> fileDir) async {
    final storageRef = _storage.ref();
    List<String> attachmentUrls = [];

    // Use a regular for-loop to await the async tasks
    for (String filePath in fileDir) {
      try {
        final String fileName = basename(filePath);
        final Reference fileRef = storageRef.child("$dealNo/$fileName");

        // Upload the file
        await fileRef.putFile(File(filePath));

        // Get the download URL
        String downloadUrl = await fileRef.getDownloadURL();
        attachmentUrls.add(downloadUrl);

        // Log each URL
        print(downloadUrl);
      } catch (e) {
        print('Error uploading $filePath: $e');
      }
    }

    // Return the list of download URLs after all uploads are completed
    return attachmentUrls;
  }

  Future<void> login(BuildContext context, String email, String password,
      String userName) async {
    try {
      // Firebase sign in
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      // Save login state to SharedPreferences
      await _saveLoginState(credential.user!.uid);
      context.goNamed('home');
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
    context.goNamed('login');
  }
}
