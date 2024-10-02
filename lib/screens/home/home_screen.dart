import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Icon(
              Icons.menu_rounded,
              size: 30,
            ),
            const Spacer(),
            const Icon(
              Icons.people_outline_rounded,
              size: 30,
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
