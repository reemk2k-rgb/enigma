import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'main_layout.dart';
import 'pages/email_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // ✅ دالة الاتصال بالسيرفر عند الضغط على Guest
  Future<void> _connectAsGuest(BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:5000/crypto/encrypt/guest'), // غيّر IP حسب السيرفر
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'text': 'connected'}),
      );

      if (response.statusCode == 200) {
        // ✅ الاتصال ناجح — الانتقال إلى MainLayout
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainLayout()),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Connected as Guest'),
            backgroundColor: Color(0xFF2E2E2E),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Connection failed (${response.statusCode})',
              style: const TextStyle(color: Color(0xFF66C8C8)),
            ),
            backgroundColor: const Color(0xFF2E2E2E),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error: $e',
            style: const TextStyle(color: Color(0xFF66C8C8)),
          ),
          backgroundColor: const Color(0xFF2E2E2E),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2E2E2E),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/images/enigma_key.png',
              width: 200,
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: 200,
              height: 50,
              child: ElevatedButton(
                // ✅ تم التبديل إلى الاتصال الفعلي
                onPressed: () => _connectAsGuest(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E2E2E),
                  side: const BorderSide(color: Color(0xFF66F0F0), width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Guest',
                  style: TextStyle(
                    color: Color(0xFF66C8C8),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Color(0xFF66F0F0),
                        blurRadius: 10,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 200,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const EmailPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E2E2E),
                  side: const BorderSide(color: Color(0xFF66F0F0), width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Normal user',
                  style: TextStyle(
                    color: Color(0xFF66C8C8),
                    fontSize: 18,
                    fontWeight: FontWeight.
                    bold,
                    shadows: [
                      Shadow(
                        color: Color(0xFF66F0F0),
                        blurRadius: 10,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}