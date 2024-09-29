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
              showModalBottomSheet(
                showDragHandle: true,
                elevation: 1.5,
                isScrollControlled: true,
                context: context,
                builder: (context) {
                  return FractionallySizedBox(
                    heightFactor: 0.7,
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Users',
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          // Search Field
                          TextField(
                            focusNode: searchFocusNode,
                            controller: searchController,
                            decoration: const InputDecoration(
                              isDense: true,
                              hintText: 'Search Here',
                              prefixIcon: Icon(Icons.search_rounded),
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 20),
                          // List of Users
                          Expanded(
                            // Wrap ListView in Expanded to take remaining space
                            child: userNames.isEmpty
                                ? const Center(
                                    child:
                                        CircularProgressIndicator()) // Loading indicator
                                : ListView.builder(
                                    itemCount: userNames.length,
                                    itemBuilder: (context, index) {
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              const SizedBox(
                                                width: 12,
                                              ),
                                              Container(
                                                decoration: const BoxDecoration(
                                                  color: Colors.red,
                                                  shape: BoxShape.circle,
                                                ),
                                                height: 40,
                                                width: 40,
                                              ),
                                              const SizedBox(
                                                width: 12,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    userNames[index],
                                                    style: const TextStyle(
                                                        fontSize: 18),
                                                  ),
                                                  const Text('Tasks: 10'),
                                                ],
                                              ),
                                            ],
                                          ), // Display each user's name

                                          const Divider(), // Divider between each ListTile
                                        ],
                                      );
                                    },
                                  ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
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
