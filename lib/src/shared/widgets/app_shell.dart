// lib/src/shared/widgets/app_shell.dart

import 'package:flutter/material.dart';
import 'package:habitflow/src/features/analytics/presentation/analytics_screen.dart';
import 'package:habitflow/src/features/community/presentation/community_screen.dart';
import 'package:habitflow/src/features/focus/presentation/focus_screen.dart';
// FIX: Removed extra 'package'
import 'package:habitflow/src/features/habits/presentation/home_screen.dart';
import 'package:habitflow/src/features/settings/presentation/settings_screen.dart';

class AppShell extends StatefulWidget {
  // FIX: Added initialIndex to fix the error in home_screen.dart
  final int initialIndex;
  const AppShell({super.key, this.initialIndex = 0});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  final List<Widget> _pages = [
    const HomeScreen(),
    const AnalyticsScreen(),
    const FocusScreen(),
    const CommunityScreen(),
    const SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Stats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timer),
            label: 'Focus',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Community',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}