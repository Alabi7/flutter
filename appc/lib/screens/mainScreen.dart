import 'package:flutter/material.dart';
import '../widgets/custom_bottom_navigation.dart';
import 'alarmScreen.dart';
import 'routineScreen.dart';
import 'focusScreen.dart';
import 'reportScreen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    AlarmScreen(),
    RoutineScreen(),
    FocusScreen(),
    ReportScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: CustomBottomNavigation(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}