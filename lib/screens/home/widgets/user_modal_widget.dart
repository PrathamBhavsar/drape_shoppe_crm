import 'package:drape_shoppe_crm/providers/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserModalWidget extends StatefulWidget {
  const UserModalWidget({super.key});

  @override
  State<UserModalWidget> createState() => _UserModalWidgetState();
}

class _UserModalWidgetState extends State<UserModalWidget> {
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
            Expanded(
              child: homeProvider.userNames.isEmpty
                  ? const Center(child: CircularProgressIndicator())
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
  }
}
