import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FocusNode searchFocusNode = FocusNode();
  TextEditingController searchController = TextEditingController();
  List<String> userNames = [];

  @override
  void initState() {
    super.initState();
    _getUsers(); // Fetch users on init
  }

  // Function to fetch users from Firestore
  Future<void> _getUsers() async {
    try {
      QuerySnapshot snapshot =
      await FirebaseFirestore.instance.collection('users').get();

      // Extract user names from the snapshot
      List<String> names =
      snapshot.docs.map((doc) => doc['user_name'] as String).toList();

      setState(() {
        userNames = names;
      });
    } catch (e) {
      print('Error fetching users: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home Screen")),
      body: Column(
        children: [
          const Center(child: Text("Welcome to the Home Screen!")),
          ElevatedButton(
            onPressed: () {

            },
            child: const Text('AppBar Peoples icon button'),
          ),
          const SizedBox(height: 20),
          // Search bar
        ],
      ),
    );
  }
}