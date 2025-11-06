import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'email_page.dart';
import 'terms_and_conditions_page.dart';
import 'privacy_policy_page.dart';

class ProfileDetailsPage extends StatelessWidget {
  const ProfileDetailsPage({super.key});

  // ✅ دالة تفحص من الـ backend إذا المستخدم مسجل أو لا
  Future<void> _checkLoginStatus(BuildContext context) async {
    try {
      final url = Uri.parse('https://your-backend.com/api/checkLogin'); // 🔗 غيّرها برابطك
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final bool loggedIn = data['loggedIn'] ?? false;

        if (loggedIn) {
          // ✅ المستخدم مسجل دخول — انتقل مباشرة للصفحة الرئيسية
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Welcome back!'),
              backgroundColor: Color(0xFF2E2E2E),
            ),
          );
          // هنا تقدر توجهه إلى MainLayoutNormal مثلاً
          // Navigator.push(context, MaterialPageRoute(builder: (_) => const MainLayoutNormal()));
        } else {
          // 🔁 المستخدم غير مسجل → انتقل إلى صفحة الإيميل
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const EmailPage()),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Server error, try again later.'),
            backgroundColor: Color(0xFF2E2E2E),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Connection error: $e'),
          backgroundColor: const Color(0xFF2E2E2E),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2E2E2E),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 100),

            // ✅ تسجيل الدخول / إنشاء الحساب (يرتبط بالـ backend)
            _ProfileOptionRow(
              icon: Icons.person_outline,
              text: 'Login / Create account',
              onTap: () => _checkLoginStatus(context),
            ),

            const Divider(color: Color(0xFF66C8C8)),

            // سياسة الخصوصية
            _ProfileOptionRow(
              icon: Icons.lock_outline,
              text: 'Privacy Policy',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PrivacyPolicyPage()),
                );
              },
            ),

            const Divider(color: Color(0xFF66C8C8)),

            // الشروط والأحكام
            _ProfileOptionRow(
              icon: Icons.description,
              text: 'Terms and Conditions',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TermsAndConditionsPage()),
                );
              },
            ),

            const Divider(color: Color(0xFF66C8C8)),
          ],
        ),
      ),
    );
  }
}

class _ProfileOptionRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const _ProfileOptionRow({
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF66C8C8)),
            const SizedBox(width: 20),
            Text(
              text,
              style: const TextStyle(
                color: Color(0xFF66C8C8),
                fontSize: 18,
              ),
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios,
                color: Color(0xFF66C8C8), size: 16),
          ],
        ),
      ),
    );
  }
}
