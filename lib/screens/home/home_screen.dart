import 'package:drape_shoppe_crm/controllers/firebase_controller.dart';
import 'package:drape_shoppe_crm/providers/home_provider.dart';
import 'package:drape_shoppe_crm/screens/home/pages/home_page.dart';
import 'package:drape_shoppe_crm/screens/home/pages/tasks_page.dart';
import 'package:drape_shoppe_crm/screens/task/add_task_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final List<String> userNames = [];
  int _currentIndex = 0;
  final List<Widget> _pages = [
    const HomePage(),
    const TasksPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          HomeProvider.instance.setIncompleteTasks();
          // HomeProvider.instance.setDealNo();
          // Navigator.of(context).push(
          //   MaterialPageRoute(
          //     builder: (context) => AddTaskScreen(
          //       isNewTask: true,
          //     ),
          //   ),
          // );
        },
        child: const Icon(
          Icons.add,
          size: 30,
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 75,
        child: BottomNavigationBar(
          onTap: _handleBottomBarTap,
          currentIndex: _currentIndex,
          iconSize: 30,
          unselectedLabelStyle:
              const TextStyle(color: Colors.black, fontSize: 14),
          selectedItemColor: Colors.blue,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              label: 'Home',
              icon: Icon(Icons.home_outlined),
            ),
            BottomNavigationBarItem(
              label: 'Tasks',
              icon: Icon(Icons.task_alt_rounded),
            ),
          ],
        ),
      ),
      body: Center(
        child: _pages[_currentIndex],
      ),
    );
  }

  _handleBottomBarTap(int index) {
    setState(() {
      _currentIndex = index;
      print(_currentIndex);
    });
  }
}
