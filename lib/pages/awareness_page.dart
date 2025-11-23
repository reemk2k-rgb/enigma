
import 'package:flutter/material.dart';

class AwarenessInformationPage extends StatelessWidget {
  const AwarenessInformationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2E2E2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E2E2E),
        title: const Text(
          'Awareness Information',
          style: TextStyle(color: Color(0xFF66C8C8)),
        ),
        centerTitle: true, // يجعل العنوان في المنتصف
        automaticallyImplyLeading: false, // ✅ يمنع ظهور زر الرجوع
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              icon: Icons.security,
              title: 'Security Awareness',
              content: '''
- Do not share encryption keys or passwords with anyone.
- Store encrypted files in a secure location.
- Avoid using the app for illegal or harmful activities.
''',
            ),
            _buildSection(
              icon: Icons.privacy_tip,
              title: 'Data Privacy',
              content: '''
- We do not request sensitive information unless necessary.
- Do not enter financial data or passwords in non-secure fields.
''',
            ),
            _buildSection(
              icon: Icons.rule,
              title: 'Usage Guidelines',
              content: '''
- ENIGMA is for personal and security purposes only.
- Ensure that encrypted data does not violate any laws.
''',
            ),
            _buildSection(
              icon: Icons.warning,
              title: 'Risks',
              content: '''
- Losing your key or password means you cannot decrypt your data.
- We are not responsible for data loss due to misuse.
''',
            ),
            _buildSection(
              icon: Icons.check_circle,
              title: 'Best Practices',
              content: '''
- Use strong passwords for your account.
- Keep the app updated for the latest security features.
''',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required IconData icon, required String title, required String content}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF66C8C8), size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF66C8C8),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  content,
                  style: const TextStyle(
                    color: Color(0xFF66C8C8),
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
