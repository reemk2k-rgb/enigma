
import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2E2E2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E2E2E),
        title: const Text(
          'Privacy Policy',
          style: TextStyle(color: Color(0xFF66C8C8)),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF66C8C8)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView( // ✅ أزلنا const هنا
        padding: const EdgeInsets.all(24.0),
        child: Text(
          '''
Privacy Policy for ENIGMA

ENIGMA values your privacy and is committed to protecting your personal information. This policy explains how we collect, use, and safeguard your data.

Information We Collect:
- Name
- Email address
- Phone number
- Age
- Gender

How We Collect Data:
- During account registration
- While using the app’s features

Purpose of Data Collection:
- Provide and improve our services
- Ensure secure encryption and decryption functionality

Data Sharing:
We do NOT share your personal data with third parties.

Data Protection:
We implement industry-standard security measures, including:
- Data encryption
- SSL protocols

User Rights:
You may update or modify your personal information at any time.

Contact Us:
If you have questions about this policy, contact us at:
Email: enigma02025@gmail.com
          ''',
          style: const TextStyle(
            color: Color(0xFF66C8C8),
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
