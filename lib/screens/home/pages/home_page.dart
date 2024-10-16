import 'package:drape_shoppe_crm/controllers/firebase_controller.dart';
import 'package:drape_shoppe_crm/models/task.dart';
import 'package:drape_shoppe_crm/providers/home_provider.dart';
import 'package:drape_shoppe_crm/screens/home/widgets/custom_table_widget.dart';
import 'package:drape_shoppe_crm/screens/home/widgets/user_modal_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    Provider.of<HomeProvider>(context, listen: false).getUsers();
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
                'Overall Summary',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              Container(
                child: Consumer<HomeProvider>(
                  builder: (BuildContext context, provider, Widget? child) {
                    return GridView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 2 / 1,
                      ),
                      children: [
                        const CustomGridTile(
                          color: Colors.blue,
                          headTxt: 'Total Task',
                          amount: '9',
                        ),
                        CustomGridTile(
                          color: Colors.orange,
                          headTxt: 'Assigned',
                          amount: provider.assignedTasks.toString(),
                        ),
                        CustomGridTile(
                          color: Colors.redAccent,
                          headTxt: 'Due Today',
                          amount: provider.dueTodayTasks.toString(),
                        ),
                        CustomGridTile(
                          color: Colors.lightGreen,
                          headTxt: 'Past Due',
                          amount: provider.dueTodayTasks.toString(),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Team Tasks',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              Card(
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: TableWidget(
                    columnHeaders: ['Name', 'Incomplete Tasks'],
                    rowData: HomeProvider.instance.userTaskCountList,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildUserModelSheet() {
    return showModalBottomSheet(
      showDragHandle: true,
      elevation: 1.5,
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return UserModalWidget();
      },
    );
  }
}

// class TableWidget extends StatelessWidget {
//   TableWidget({super.key});
//   Map<String, int> taskData = HomeProvider.instance.userTaskCount;
//
//   @override
//   Widget build(BuildContext context) {
//     return Table(
//       border: TableBorder(
//         horizontalInside: BorderSide(width: 1, color: Colors.grey),
//         // verticalInside: BorderSide(width: 1, color: Colors.grey),
//       ),
//       columnWidths: {
//         0: FlexColumnWidth(1.5),
//         1: FlexColumnWidth(1),
//       },
//       children: [
//         TableRow(
//           children: [
//             Padding(
//               padding: EdgeInsets.all(8.0),
//               child: Text('Name',
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
//             ),
//             Padding(
//               padding: EdgeInsets.all(8.0),
//               child: Text('Incomplete Task',
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
//             ),
//           ],
//         ),
//         ...taskData.entries.map((task) {
//           return TableRow(children: [
//             Padding(
//               padding: EdgeInsets.all(8.0),
//               child: Text(task.key),
//             ),
//             Padding(
//               padding: EdgeInsets.all(8.0),
//               child: Text(
//                 task.value.toString(),
//               ),
//             ),
//           ]);
//         })
//       ],
//     );
//   }
// }

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
