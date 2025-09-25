import 'package:flutter/material.dart';
import 'email_page.dart';
import 'terms_and_conditions_page.dart';
import 'privacy_policy_page.dart'; // <-- Add this import

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2E2E2E),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 100),
            _ProfileOptionRow(
              icon: Icons.person_outline,
              text: 'Login / create account',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EmailPage()),
                );
              },
            ),
            const Divider(color: Color(0xFF66C8C8)),
            _ProfileOptionRow(
              icon: Icons.lock_outline,
              text: 'Privacy Policy',
              onTap: () {
                // This navigates to the new Privacy Policy page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PrivacyPolicyPage()),
                );
              },
            ),
            const Divider(color: Color(0xFF66C8C8)),
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