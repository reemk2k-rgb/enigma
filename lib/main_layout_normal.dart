import 'package:flutter/material.dart';
import 'pages/normal_profile_page.dart';        // بدلاً من guest profile
import 'pages/awareness_page.dart';
import 'pages/decrypt_page.dart';
import 'pages/encrypt_page_normal.dart';

class MainLayoutNormal extends StatefulWidget {
  const MainLayoutNormal({super.key});

  @override
  State<MainLayoutNormal> createState() => _MainLayoutNormalState();
}

class _MainLayoutNormalState extends State<MainLayoutNormal> {
  int _selectedIndex = 3;

  final List<Widget> _pages = const [
    NormalUserProfilePage(), // بدل ProfilePage
    AwarenessInformationPage(),
    DecryptPage(),
    EncryptPageNormal(), // أنشأتها سابقًا للـ Normal User
  ];


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF2E2E2E),
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF66C8C8),
        unselectedItemColor: Colors.grey.shade400,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.psychology), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.lock_open), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.lock), label: ''),
        ],
      ),
    );
  }
}
