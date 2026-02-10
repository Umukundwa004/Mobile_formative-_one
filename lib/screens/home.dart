import 'package:flutter/material.dart';
import 'dashboard.dart';
import 'assignments.dart';
import 'schedule.dart';
import 'announcements.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const AssignmentsScreen(),
    const ScheduleScreen(),
    const AnnouncementsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    final iconSize = isSmallScreen ? 20.0 : 22.0;
    final fontSize = isSmallScreen ? 9.0 : 10.0;

    return Scaffold(
      backgroundColor: const Color(0xFF1A2C5A),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF1A2C5A),
        selectedItemColor: const Color(0xFFFFB800),
        unselectedItemColor: Colors.white54,
        selectedLabelStyle: TextStyle(fontSize: fontSize),
        unselectedLabelStyle: TextStyle(fontSize: fontSize),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined, size: iconSize),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_outlined, size: iconSize),
            label: 'Assignments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule, size: iconSize),
            label: 'Schedule',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.announcement_outlined, size: iconSize),
            label: 'Announcements',
          ),
        ],
      ),
    );
  }
}
