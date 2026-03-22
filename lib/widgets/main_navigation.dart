import 'package:flutter/material.dart';
import '../widgets/bottom_nav.dart';
import '../screens/home_screen.dart';
import '../screens/history_screen.dart';
import '../screens/setup_screen.dart';
import '../screens/settings_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0; // Default to home/analyze screen

  final List<Widget> _screens = [
    const HomeScreen(), // 0: Suriin
    const HistoryScreen(), // 1: Kasaysayan
    const SetupScreen(), // 2: Setup
    const SettingsScreen(), // 3: Settings
  ];

  void _onItemTapped(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNav(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}