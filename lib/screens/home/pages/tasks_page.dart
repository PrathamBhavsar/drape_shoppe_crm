import 'package:drape_shoppe_crm/controllers/firebase_controller.dart';
import 'package:drape_shoppe_crm/models/task.dart';
import 'package:drape_shoppe_crm/providers/home_provider.dart';
import 'package:drape_shoppe_crm/screens/task/add_task_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  final FocusNode searchFocusNode = FocusNode();
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    Provider.of<HomeProvider>(context, listen: false).getUsers();
    FirebaseController.instance.fetchTasksList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Icon(
              Icons.menu_rounded,
              size: 30,
            ),
            const Spacer(),
            IconButton(
              onPressed: () {
                _buildUserModelSheet();
              },
              icon: const Icon(
                Icons.people_outline_rounded,
                size: 30,
              ),
            ),
            SizedBox(
              width: 20,
            ),
            const Icon(
              Icons.notifications_none_rounded,
              size: 30,
            ),
            Container(
              height: 12,
              decoration: BoxDecoration(
                  borderRadius: BorderRadiusDirectional.circular(20)),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Your Tasks',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Container(
                height: 400,
                child: FutureBuilder<List<TaskModel>>(
                    future: FirebaseController.instance.fetchTasksList(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (snapshot.hasError) {
                        return Center(
                          child: Text(snapshot.error.toString()),
                        );
                      }
                      List<TaskModel> tasks = snapshot.data!;
                      return ListView.builder(
                        itemCount: tasks.length,
                        itemBuilder: (context, index) {
                          TaskModel task = tasks[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => AddTaskScreen(
                                    dealNo: task.dealNo,
                                    isNewTask: false,
                                  ),
                                ),
                              );
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(task.dealNo),
                                Text(task.createdBy),
                                Text(task.title),
                                SizedBox(height: 5),
                                Divider()
                              ],
                            ),
                          );
                        },
                      );
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }

  _buildUserModelSheet() {
    final homeProvider = Provider.of<HomeProvider>(context);
    return showModalBottomSheet(
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
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
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
                  child: homeProvider.userNames.isEmpty
                      ? const Center(
                          child:
                              CircularProgressIndicator()) // Loading indicator
                      : ListView.builder(
                          itemCount: homeProvider.userNames.length,
                          itemBuilder: (context, index) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                          homeProvider.userNames[index],
                                          style: const TextStyle(fontSize: 18),
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
  }
}
