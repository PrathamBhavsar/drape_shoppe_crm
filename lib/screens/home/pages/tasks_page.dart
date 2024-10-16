import 'package:drape_shoppe_crm/controllers/firebase_controller.dart';
import 'package:drape_shoppe_crm/models/task.dart';
import 'package:drape_shoppe_crm/providers/home_provider.dart';
import 'package:drape_shoppe_crm/screens/task/add_task_screen.dart';
import 'package:drape_shoppe_crm/screens/task/widgets/custom_task_icon_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: IntrinsicWidth(
                          child: TableWidget(
                            columnHeaders: ['Task Name', 'Due Date', 'Status'],
                            taskData: tasks,
                          ),
                        ),
                      );

                      // return ListView.builder(
                      //   itemCount: tasks.length,
                      //   itemBuilder: (context, index) {
                      //     TaskModel task = tasks[index];
                      //     int priorityIndex = HomeProvider.instance
                      //         .getPriorityIndexFromText(task.priority);
                      //     int statusIndex = HomeProvider.instance
                      //         .getTaskIndexFromText(task.status);
                      //     String formattedCreatedAtDate =
                      //         DateFormat("dd MMM''yy").format(task.createdAt);
                      //     String formattedDueDate =
                      //         DateFormat("dd MMM''yy").format(task.dueDate);
                      //
                      //     return GestureDetector(
                      //       onTap: () {
                      //         Navigator.of(context).push(
                      //           MaterialPageRoute(
                      //             builder: (context) => AddTaskScreen(
                      //               dealNo: task.dealNo,
                      //               isNewTask: false,
                      //             ),
                      //           ),
                      //         );
                      //       },
                      //       child: Column(
                      //         children: [
                      //           Row(
                      //             crossAxisAlignment: CrossAxisAlignment.center,
                      //             mainAxisAlignment:
                      //                 MainAxisAlignment.spaceAround,
                      //             children: [
                      //               CustomTaskIconWidget(
                      //                 color: HomeProvider.instance
                      //                         .priorityValues[priorityIndex]
                      //                     ["color"],
                      //               ),
                      //               Column(
                      //                 crossAxisAlignment:
                      //                     CrossAxisAlignment.start,
                      //                 children: [
                      //                   Text(task.title),
                      //                   Text(formattedCreatedAtDate),
                      //                 ],
                      //               ),
                      //               Text(formattedDueDate),
                      //               Container(
                      //                 decoration: BoxDecoration(
                      //                     borderRadius:
                      //                         BorderRadius.circular(10),
                      //                     color: HomeProvider.instance
                      //                             .taskStatus[statusIndex]
                      //                         ["secondaryColor"]),
                      //                 child: Padding(
                      //                   padding: const EdgeInsets.all(8.0),
                      //                   child: Row(
                      //                     children: [
                      //                       CustomTaskIconWidget(
                      //                         color: HomeProvider.instance
                      //                                 .taskStatus[statusIndex]
                      //                             ["primaryColor"],
                      //                       ),
                      //                       SizedBox(width: 10),
                      //                       Text(
                      //                         HomeProvider.instance
                      //                                 .taskStatus[statusIndex]
                      //                             ["text"],
                      //                         style: TextStyle(
                      //                             color:
                      //                                 HomeProvider.instance
                      //                                             .taskStatus[
                      //                                         statusIndex]
                      //                                     ["primaryColor"],
                      //                             fontWeight: FontWeight.bold),
                      //                       ),
                      //                     ],
                      //                   ),
                      //                 ),
                      //               )
                      //             ],
                      //           ),
                      //           SizedBox(height: 5),
                      //           Divider(),
                      //         ],
                      //       ),
                      //     );
                      //   },
                      // );
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

class TableWidget extends StatelessWidget {
  TableWidget({super.key, required this.taskData, required this.columnHeaders});
  final List<TaskModel> taskData;
  final List<String> columnHeaders;

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder(
        horizontalInside: BorderSide(width: 1, color: Colors.grey),
        // verticalInside: BorderSide(width: 1, color: Colors.grey),
      ),
      columnWidths: {
        0: FlexColumnWidth(1.5),
        1: FlexColumnWidth(1),
      },
      children: [
        TableRow(
            children: columnHeaders.map((header) {
          return Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              header,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          );
        }).toList()),
        ...taskData.map((task) {
          int priorityIndex =
              HomeProvider.instance.getPriorityIndexFromText(task.priority);
          int statusIndex =
              HomeProvider.instance.getTaskIndexFromText(task.status);
          return TableRow(children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(task.createdBy),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                task.description,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: HomeProvider.instance.taskStatus[statusIndex]
                        ["secondaryColor"]),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      CustomTaskIconWidget(
                        color: HomeProvider.instance.taskStatus[statusIndex]
                            ["primaryColor"],
                      ),
                      SizedBox(width: 10),
                      Text(
                        HomeProvider.instance.taskStatus[statusIndex]["text"],
                        style: TextStyle(
                            color: HomeProvider.instance.taskStatus[statusIndex]
                                ["primaryColor"],
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ]);
        })
      ],
    );
  }
}
