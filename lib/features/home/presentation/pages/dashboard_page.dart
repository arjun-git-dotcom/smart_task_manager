import 'package:flutter/material.dart';
import 'package:smart_task_manager/features/home/presentation/pages/home_page.dart';
import 'package:smart_task_manager/features/profile/presentation/pages/profile_page.dart';

class DashboardPage extends StatefulWidget {
  final String userId;
  const DashboardPage({super.key, required this.userId});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentIndex = 0;

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(          
        index: _currentIndex,
        children: [
          HomePage(userId: widget.userId),
          ProfilePage(uid: widget.userId),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations:const [
          NavigationDestination(
            icon: Icon(Icons.task_alt_outlined),
            selectedIcon: Icon(Icons.task_alt),
            label: 'Tasks',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}