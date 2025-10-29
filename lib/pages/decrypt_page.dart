import 'package:flutter/material.dart';
import 'package:login1/pages/decryption_success_page.dart';

class DecryptPage extends StatefulWidget {
  const DecryptPage({super.key});

  @override
  State<DecryptPage> createState() => _DecryptPageState();
}

class _DecryptPageState extends State<DecryptPage> {
  final TextEditingController keyController = TextEditingController();
  final TextEditingController textController = TextEditingController();

  void _showOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF2E2E2E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.image, color: Color(0xFF66C8C8)),
                title:
                const Text("Image", style: TextStyle(color: Colors.white)),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading:
                const Icon(Icons.insert_drive_file, color: Color(0xFF66C8C8)),
                title: const Text("File", style: TextStyle(color: Colors.white)),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.link, color: Color(0xFF66C8C8)),
                title: const Text("URL", style: TextStyle(color: Colors.white)),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.wifi, color: Color(0xFF66C8C8)),
                title: const Text("Wi-Fi", style: TextStyle(color: Colors.white)),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  void _decryptAction() {
    if (keyController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("You should enter the key."),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    String decryptedText =
        "example_decrypted_data"; // Replace with your real decryption logic

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            DecryptionSuccessPage(decryptedText: decryptedText),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2E2E2E),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 60, 24, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Image.asset(
                'assets/images/enigma_key.png',
                width: 80,
              ),
            ),
            const SizedBox(height: 40),

            // Box with + button and text field
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black26,
                border: Border.all(color: const Color(0xFF66C8C8)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      onPressed: _showOptions,
                      icon: const Icon(Icons.add, color: Color(0xFF66C8C8)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: textController,
                    maxLength: 200,
                    maxLines: 5,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'Paste your encrypted text',
                      hintStyle: TextStyle(color: Color(0xFF66C8C8)),
                      filled: true,
                      fillColor: Colors.black26,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF66C8C8)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF66C8C8)),
                      ),
                      counterStyle: TextStyle(color: Color(0xFF66C8C8)),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Key field
            const Text(
              "Key",
              style: TextStyle(
                color: Color(0xFF66C8C8),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: keyController,
              obscureText: true,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Enter your key',
                hintStyle: const TextStyle(color: Color(0xFF66C8C8)),
                filled: true,
                fillColor: Colors.black26,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFF66C8C8)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFF66C8C8)),
                ),
              ),
            ),

            const SizedBox(height: 30),

            Center(
              child: ElevatedButton.icon(
                onPressed: _decryptAction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E2E2E),
                  side: const BorderSide(color: Color(0xFF66C8C8)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                ),
                icon: const Icon(Icons.lock_open, color: Color(0xFF66C8C8)),
                label: const Text(
                  'Decrypt',
                  style: TextStyle(
                    color: Color(0xFF66C8C8),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Color(0xFF66C8C8),
                        blurRadius: 10,
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
