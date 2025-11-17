import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'profile_details_page.dart';
import 'privacy_policy_page.dart';
import 'terms_and_conditions_page.dart';
import '../main_layout_normal.dart';
import '../constants.dart';
import 'package:login1/main_layout.dart';

class NormalUserProfilePage extends StatelessWidget {
  const NormalUserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2E2E2E),
      body: Column(
        children: [
          const SizedBox(height: 100),

          _buildOption(
            context,
            icon: Icons.person_outline,
            text: 'My Profile',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfileDetailsPage(),
                ),
              );
            },
          ),

          const Divider(color: Color(0xFF66C8C8)),

          _buildOption(
            context,
            icon: Icons.lock_outline,
            text: 'Privacy Policy',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PrivacyPolicyPage(),
                ),
              );
            },
          ),

          const Divider(color: Color(0xFF66C8C8)),

          _buildOption(
            context,
            icon: Icons.description,
            text: 'Terms and Conditions',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TermsAndConditionsPage(),
                ),
              );
            },
          ),

          const Divider(color: Color(0xFF66C8C8)),

          _buildOption(
            context,
            icon: Icons.logout,
            text: 'Logout',
            onTap: () {
              _showLogoutConfirmation(context);
            },
          ),

          const Divider(color: Color(0xFF66C8C8)),
        ],
      ),
    );
  }

  Widget _buildOption(
      BuildContext context, {
        required IconData icon,
        required String text,
        required VoidCallback onTap,
      }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
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

  // نافذة تأكيد تسجيل الخروج
  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2E2E2E),
          title: const Text(
            'Confirm Logout',
            style: TextStyle(color: Color(0xFF66C8C8)),
          ),
          content: const Text(
            'Are you sure you want to logout?',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel',
                  style: TextStyle(color: Color(0xFF66C8C8))),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: const Text('Logout',
                  style: TextStyle(color: Colors.redAccent)),
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                await _logoutFromBackend(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _logoutFromBackend(BuildContext context) async {
    try {
      final url = Uri.parse('${baseUrl}auth/logout');
      await http.post(url);

      // رجوع لصفحة القيست
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MainLayout()),
            (route) => false,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Logged out successfully',
            style: TextStyle(color: Color(0xFF66C8C8)),
          ),
          backgroundColor: Color(0xFF2E2E2E),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logout failed: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }
}
