import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drape_shoppe_crm/screens/home/pages/home_page.dart';
import 'package:drape_shoppe_crm/screens/home/pages/tasks_page.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final List<String> userNames = [];
  int _currentIndex = 0;
  final List<Widget> _pages = [
    HomePage(),
    TasksPage(),
    HomePage(),
    TasksPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SizedBox(
        height: 75,
        child: BottomNavigationBar(
          onTap: _handleBottomBarTap,
          currentIndex: _currentIndex,
          iconSize: 30,
          unselectedLabelStyle: TextStyle(color: Colors.black, fontSize: 14),
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
            BottomNavigationBarItem(
              label: 'Home',
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(
                Icons.home_filled,
                color: Colors.blue,
              ),
            ),
            BottomNavigationBarItem(
              label: 'Home',
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(
                Icons.home_filled,
                color: Colors.blue,
              ),
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
    });
  }
}
