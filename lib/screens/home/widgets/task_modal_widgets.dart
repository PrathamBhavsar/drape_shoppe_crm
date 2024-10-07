import 'package:drape_shoppe_crm/providers/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TaskStatusModalWidget extends StatefulWidget {
  const TaskStatusModalWidget({super.key});

  @override
  State<TaskStatusModalWidget> createState() => _TaskStatusModalWidgetState();
}

class _TaskStatusModalWidgetState extends State<TaskStatusModalWidget> {
  final FocusNode searchFocusNode = FocusNode();
  final TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);

    return FractionallySizedBox(
      heightFactor: 0.7,
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Task Status',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: homeProvider.userNames.isEmpty
                  ? const Center(
                      child: CircularProgressIndicator()) // Loading indicator
                  : ListView.builder(
                      itemCount: homeProvider.taskStatus.length,
                      itemBuilder: (context, index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 18.0, vertical: 5),
                              child: Text(
                                homeProvider.taskStatus[index],
                                style: const TextStyle(fontSize: 18),
                              ),
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
  }
}
