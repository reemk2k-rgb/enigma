import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DecryptionSuccessPage extends StatelessWidget {
  final String decryptedText;

  const DecryptionSuccessPage({super.key, required this.decryptedText});

  Future<void> _downloadText(BuildContext context) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File("${directory.path}/decrypted_text.txt");
      await file.writeAsString(decryptedText);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("File saved at: ${file.path}")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to save file")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2E2E2E),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: Color(0xFF66C8C8), size: 80),
            const SizedBox(height: 20),
            const Text(
              "Decryption Successful!",
              style: TextStyle(
                color: Color(0xFF66C8C8),
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFF66C8C8)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: SelectableText(
                decryptedText,
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () => Share.share(decryptedText),
                  icon: const Icon(Icons.share, color: Color(0xFF66C8C8)),
                  label: const Text("Share"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E2E2E),
                    side: const BorderSide(color: Color(0xFF66C8C8)),
                  ),
                ),
                const SizedBox(width: 20),
                ElevatedButton.icon(
                  onPressed: () => _downloadText(context),
                  icon: const Icon(Icons.download, color: Color(0xFF66C8C8)),
                  label: const Text("Download"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E2E2E),
                    side: const BorderSide(color: Color(0xFF66C8C8)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
