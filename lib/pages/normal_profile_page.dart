import 'package:flutter/material.dart';
import 'profile_details_page.dart';
import 'privacy_policy_page.dart';
import 'terms_and_conditions_page.dart';
import '../main_layout.dart'; // <-- تأكد أنه مستورد

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
                MaterialPageRoute(builder: (context) => const ProfileDetailsPage()),
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
                MaterialPageRoute(builder: (context) => const PrivacyPolicyPage()),
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
                MaterialPageRoute(builder: (context) => const TermsAndConditionsPage()),
              );
            },
          ),
          const Divider(color: Color(0xFF66C8C8)),

          // 🔻 زر تسجيل الخروج مع تأكيد
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

  Widget _buildOption(BuildContext context,
      {required IconData icon, required String text, required VoidCallback onTap}) {
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
            const Icon(Icons.arrow_forward_ios, color: Color(0xFF66C8C8), size: 16),
          ],
        ),
      ),
    );
  }

  // 🔻 دالة عرض نافذة تأكيد قبل تسجيل الخروج
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
              child: const Text('Cancel', style: TextStyle(color: Color(0xFF66C8C8))),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // تغلق النافذة فقط
              },
            ),
            TextButton(
              child: const Text('Logout', style: TextStyle(color: Colors.redAccent)),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // تغلق النافذة
                // 🔁 ترجع إلى وضع الزائر
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const MainLayout()),
                      (route) => false,
                );


                Future.delayed(Duration(milliseconds: 300), () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Logged out successfully',
                        style: TextStyle(color: Color(0xFF66C8C8)),
                      ),
                      backgroundColor: Color(0xFF2E2E2E),
                      duration: Duration(seconds: 2),
                    ),
                  );
                });
              },
            ),
          ],
        );
      },
    );
  }
}
