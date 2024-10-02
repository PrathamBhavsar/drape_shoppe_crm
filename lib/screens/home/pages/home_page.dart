import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Incomplete Task',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ),
          ],
        ),
        TableRow(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Alpesh Desai',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
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
                      style: const TextStyle(fontSize: 18),
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
