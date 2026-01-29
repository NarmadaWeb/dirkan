import 'package:flutter/material.dart';
import 'package:dirkan/widgets/custom_bottom_nav.dart';
import 'package:dirkan/screens/home_screen.dart';
import 'package:dirkan/screens/manage_screen.dart';
import 'package:dirkan/screens/profile_screen.dart';
import 'package:dirkan/screens/add_edit_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const Center(child: Text('Chat Feature Coming Soon', style: TextStyle(color: Colors.grey))), // Chat Placeholder
    const SizedBox(), // Add Placeholder (handled by onTap)
    const ManageScreen(),
    const ProfileScreen(),
  ];

  void _onTabTapped(int index) {
    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AddEditScreen()),
      );
    } else {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}
