import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
                                                  decoration:
                                                      const BoxDecoration(
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
              'Overall Summary',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            Container(
              child: GridView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2 / 1,
                ),
                children: const [
                  CustomGridTile(
                    color: Colors.blue,
                    headTxt: 'Total Task',
                    amount: '9',
                  ),
                  CustomGridTile(
                    color: Colors.orange,
                    headTxt: 'Assigned',
                    amount: '9',
                  ),
                  CustomGridTile(
                    color: Colors.redAccent,
                    headTxt: 'Due Today',
                    amount: '0',
                  ),
                  CustomGridTile(
                    color: Colors.lightGreen,
                    headTxt: 'Past Due',
                    amount: '8',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Team Tasks',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const Card(
              elevation: 5,
              child:
                  Padding(padding: EdgeInsets.all(18.0), child: TableWidget()),
            ),
          ],
        )),
      ),
    );
  }
}

class TableWidget extends StatelessWidget {
  const TableWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Table(
      border: const TableBorder(
        horizontalInside: BorderSide(width: 1, color: Colors.grey),
        verticalInside: BorderSide(width: 1, color: Colors.grey),
      ),
      columnWidths: const {
        0: FlexColumnWidth(1.5),
        1: FlexColumnWidth(1),
      },
      children: const [
        TableRow(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Name',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Incomplete Task',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            ),
          ],
        ),
        TableRow(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Alpesh Desai'),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('1'),
            ),
          ],
        ),
        TableRow(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Bhushan Zare'),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('1'),
            ),
          ],
        ),
        TableRow(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Chirag Keswani'),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('0'),
            ),
          ],
        ),
        TableRow(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Darshan Panpaliya'),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('0'),
            ),
          ],
        ),
        TableRow(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Neha Thakur'),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('1'),
            ),
          ],
        ),
        TableRow(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Sangita Bishwakarma'),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('0'),
            ),
          ],
        ),
      ],
    );
  }
}

class CustomGridTile extends StatelessWidget {
  const CustomGridTile(
      {super.key,
      required this.color,
      required this.headTxt,
      required this.amount});

  final Color color;
  final String headTxt;
  final String amount;

  @override
  Widget build(BuildContext context) {
    return GridTile(
      child: Card(
        elevation: 3,
        margin: const EdgeInsets.all(8),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadiusDirectional.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle, // Make the container a circle
                  ),
                ),
                const SizedBox(
                  width: 14,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      headTxt,
                      style: const TextStyle(fontSize: 14),
                    ),
                    Text(
                      amount,
                      style: const TextStyle(
                          fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
