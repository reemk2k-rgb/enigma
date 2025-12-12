import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'dart:io';

class EncryptionSuccessPage extends StatelessWidget {
  final String encryptedText;
  final String encryptionKey;
  final String algorithm;

  const EncryptionSuccessPage({
    super.key,
    required this.encryptedText,
    required this.encryptionKey,
    required this.algorithm,
  });

  // ---------------------- CONTENT DOWNLOAD ----------------------
  Future<void> _downloadContent(BuildContext context) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File("${directory.path}/encrypted_content.txt");
      await file.writeAsString(encryptedText);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Content saved at: ${file.path}")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to save content")),
      );
    }
  }

  // ---------------------- KEY DOWNLOAD ----------------------
  Future<void> _downloadKey(BuildContext context) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File("${directory.path}/encryption_key.txt");
      await file.writeAsString(encryptionKey);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Key saved at: ${file.path}")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to save key")),
      );
    }
  }

  // ---------------------- COPY CONTENT ----------------------
  Future<void> _copyContent(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: encryptedText));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Content copied")),
    );
  }

  // ---------------------- COPY KEY ----------------------
  Future<void> _copyKey(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: encryptionKey));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Key copied")),
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

              // ---------------------- CONTENT BOX + COPY ICON ----------------------
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFF66C8C8)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: SelectableText(
                        encryptedText,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy, color: Color(0xFF66C8C8)),
                      onPressed: () => _copyContent(context),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ---------------------- SHARE + DOWNLOAD CONTENT ----------------------
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => Share.share(encryptedText),
                      icon: const Icon(Icons.share, color: Color(0xFF66C8C8)),
                      label: const Text("Share Content"),
                      style: _btn,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _downloadContent(context),
                      icon: const Icon(Icons.download, color: Color(0xFF66C8C8)),
                      label: const Text("Download"),
                      style: _btn,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 35),

              const Text(
                "Your Key",
                style: TextStyle(
                  color: Color(0xFF66C8C8),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              // ---------------------- KEY BOX + COPY ICON ----------------------
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFF66C8C8)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: SelectableText(
                        encryptionKey,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy, color: Color(0xFF66C8C8)),
                      onPressed: () => _copyKey(context),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ---------------------- SHARE + DOWNLOAD KEY ----------------------
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => Share.share(encryptionKey),
                      icon: const Icon(Icons.share, color: Color(0xFF66C8C8)),
                      label: const Text("Share Key"),
                      style: _btn,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _downloadKey(context),
                      icon: const Icon(Icons.download, color: Color(0xFF66C8C8)),
                      label: const Text("Download"),
                      style: _btn,
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

  ButtonStyle get _btn => ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFF2E2E2E),
    side: const BorderSide(color: Color(0xFF66C8C8)),
  );
}
