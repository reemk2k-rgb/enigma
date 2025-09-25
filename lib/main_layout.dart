import 'package:flutter/material.dart';
import 'pages/profile_page.dart';
import 'pages/awareness_page.dart';
import 'pages/decrypt_page.dart';
import 'pages/encrypt_page_guest.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 3;

  final List<Widget> _pages = const [
    ProfilePage(),
    AwarenessInformationPage(),
    DecryptPage(),
    GuestPage(),
  ];

  void _onItemTapped(int index) {
    if (index == 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'You need an account to decrypt content. Join us now to unlock unlimited cryptography features!!',
            style: TextStyle(color: Color(0xFF66C8C8)),
          ),
          action: SnackBarAction(
            label: 'sign in or create account',
            textColor: const Color(0xFF66C8C8),
            onPressed: () {
              // This is the correct navigation logic
              setState(() {
                _selectedIndex = 0; // Navigates to the ProfilePage
              });
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
          backgroundColor: const Color(0xFF2E2E2E),
        ),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
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