import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:login1/constants.dart';
import 'pages/normal_profile_page.dart';
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
    NormalUserProfilePage(),
    AwarenessInformationPage(),
    DecryptPage(),
    EncryptPageNormal(),
  ];

  @override
  void initState() {
    super.initState();
    checkServerConnection(); // 🔥 اختبار الاتصال عند التشغيل
  }

  Future<void> checkServerConnection() async {
    try {
      final response = await http.get(Uri.parse('${baseUrl}ping')); // ✅ الرابط الصحيح
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('✅ Backend connected: ${data['message']}');
      } else {
        print('⚠️ Connection failed: ${response.statusCode}');
      }
    } catch (e) {
      print('🚫 Error connecting to backend: $e');
    }
  }

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