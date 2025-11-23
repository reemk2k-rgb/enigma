import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

  // ✅ رابط السيرفر الثابت (Render)
  final String baseUrl = "https://enigma-09np.onrender.com/";

  // 🛰️ اختبار الاتصال بالسيرفر (backend) - بدون إظهار رسالة للمستخدم
  Future<void> testConnection() async {
    try {
      await http.get(Uri.parse("${baseUrl}ping"));
    } catch (e) {
      // نطبع الخطأ في الكونسول فقط (وليس للمستخدم)
      debugPrint("Backend connection error: $e");
    }
  }

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
              setState(() {
                _selectedIndex = 0;
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
  void initState() {
    super.initState();

    // 🔄 يختبر الاتصال في الخلفية فقط (بدون إشعار للمستخدم)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      testConnection();
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