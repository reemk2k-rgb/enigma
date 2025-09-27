import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'dart:io';

class EncryptionSuccessPage extends StatelessWidget {
  final String encryptedText;

  const EncryptionSuccessPage({super.key, required this.encryptedText});

  Future<void> _downloadText(BuildContext context) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File("${directory.path}/encrypted_text.txt");
      await file.writeAsString(encryptedText);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("File saved at: ${file.path}")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to save file")),
      );
    }
  }

  Future<void> _copyToClipboard(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: encryptedText));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Copied to Clipboard")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2E2E2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E2E2E),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF66C8C8)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle, color: Color(0xFF66C8C8), size: 80),
              const SizedBox(height: 20),
              const Text(
                "Encryption Successful!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF66C8C8),
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFF66C8C8)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SelectableText(
                  encryptedText,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 30),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 20,
                runSpacing: 10,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => Share.share(encryptedText),
                    icon: const Icon(Icons.share, color: Color(0xFF66C8C8)),
                    label: const Text("Share"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2E2E2E),
                      side: const BorderSide(color: Color(0xFF66C8C8)),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _downloadText(context),
                    icon: const Icon(Icons.download, color: Color(0xFF66C8C8)),
                    label: const Text("Download"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2E2E2E),
                      side: const BorderSide(color: Color(0xFF66C8C8)),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _copyToClipboard(context),
                    icon: const Icon(Icons.copy, color: Color(0xFF66C8C8)),
                    label: const Text("Copy"),
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
      ),
    );
  }
}
