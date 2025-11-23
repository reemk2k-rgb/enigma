
import 'package:flutter/material.dart';

class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2E2E2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E2E2E),
        title: const Text(
          'Terms and Conditions',
          style: TextStyle(color: Color(0xFF66C8C8)),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF66C8C8)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(24.0),
        child: Text(
          '''
Terms and Conditions for ENIGMA

Welcome to ENIGMA. By using our application, you agree to comply with the following terms and conditions. Please read them carefully.

1. Acceptance of Terms
By accessing or using ENIGMA, you agree to these Terms and Conditions. If you do not agree, please discontinue using the app.

2. User Accounts
Guest users have limited access to features.
Normal users have full access after registration.
You are responsible for maintaining the confidentiality of your account information.

3. Permitted Use
ENIGMA is designed for encryption and decryption of text, URLs, Wi-Fi credentials, and files. You agree not to use the app for any illegal or harmful activities.

4. Data Collection
We collect personal information such as:
Name, Email, Phone number, Age, Gender
This data is collected during registration and while using the app’s features.

5. Privacy
Your data is protected under our Privacy Policy. We do not share your information with third parties.

6. Security
We use encryption and SSL protocols to protect your data. However, we cannot guarantee absolute security.

7. Limitation of Liability
ENIGMA is provided “as is.” We are not liable for any damages resulting from the use or inability to use the app.

8. Changes to Terms
We may update these Terms and Conditions at any time. Continued use of ENIGMA means you accept the updated terms.

9. Contact
For questions, contact us at:
Email: enigma02025@gmail.com
          ''',
          style: TextStyle(
            color: Color(0xFF66C8C8),
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
