import 'package:flutter/material.dart';
import 'package:login1/pages/EncryptionSuccessPageGuest.dart'; // <- use your renamed file

class GuestPage extends StatelessWidget {
  const GuestPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _textController = TextEditingController();

    return Scaffold(
      backgroundColor: const Color(0xFF2E2E2E),
      body: Padding(
        // The top padding has been increased to lower the entire content.
        padding: const EdgeInsets.fromLTRB(24, 100, 24, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // The image at the top
            Align(
              alignment: Alignment.topLeft,
              child: Image.asset(
                'assets/images/enigma_key.png',
                width: 80,
              ),
            ),
            const SizedBox(height: 80),

            // The TextField
            TextField(
              controller: _textController,
              maxLength: 100,
              maxLines: 5,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Write/paste your text up to 100',
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
            const SizedBox(height: 10),

            const Text(
              'Maximum Attempts: 3',
              style: TextStyle(
                color: Color(0xFF66C8C8),
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 20),

            // The Encrypt button
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  final text = _textController.text.trim();
                  if (text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Please enter some text.",
                          style: TextStyle(color: Color(0xFF66C8C8)),
                        ),
                        backgroundColor: Color(0xFF2E2E2E),
                      ),
                    );
                    return;
                  }

                  // Simple example encryption (you can replace with your real one)
                  final encryptedText = text.split('').reversed.join();

                  // Navigate to success page — updated to the renamed class
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          EncryptionSuccessPageGuest(encryptedText: encryptedText),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E2E2E),
                  side: const BorderSide(color: Color(0xFF66C8C8)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 24,
                  ),
                ),
                icon: const Icon(Icons.lock, color: Color(0xFF66C8C8)),
                label: const Text(
                  'Encrypt',
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
