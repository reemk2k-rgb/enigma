import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class DecryptionSuccessPage extends StatelessWidget {
  final String? decryptedText; // نص فقط
  final String? filePath; // ملف PDF

  const DecryptionSuccessPage({
    super.key,
    this.decryptedText,
    this.filePath,
  });

  Future<void> _downloadFile(BuildContext context) async {
    try {
      if (decryptedText != null) {
        // حفظ النص في ملف
        final directory = await getApplicationDocumentsDirectory();
        final file = File("${directory.path}/decrypted_text.txt");
        await file.writeAsString(decryptedText!);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("File saved at: ${file.path}")),
        );
      } else if (filePath != null) {
        // نسخ ملف PDF إلى مجلد التطبيق
        final original = File(filePath!);
        final directory = await getApplicationDocumentsDirectory();
        final newFile = File("${directory.path}/decrypted_file.pdf");
        await original.copy(newFile.path);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("PDF saved at: ${newFile.path}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to save file")),
      );
    }
  }

  Future<void> _copyToClipboard(BuildContext context) async {
    if (decryptedText != null) {
      await Clipboard.setData(ClipboardData(text: decryptedText!));
    } else if (filePath != null) {
      await Clipboard.setData(ClipboardData(text: filePath!));
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Copied to Clipboard")),
    );
  }

  void _shareContent() {
    if (decryptedText != null) {
      Share.share(decryptedText!);
    } else if (filePath != null) {
      Share.shareXFiles([XFile(filePath!)]);
    }
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
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Icon(Icons.check_circle,
                    color: Color(0xFF66C8C8), size: 80),
                const SizedBox(height: 20),
                const Text(
                  "Decryption Successful!",
                  style: TextStyle(
                    color: Color(0xFF66C8C8),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),

                if (decryptedText != null)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFF66C8C8)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: SelectableText(
                      decryptedText!,
                      style: const TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),

                if (filePath != null)
                  Column(
                    children: [
                      const Text(
                        "Saved File:",
                        style: TextStyle(
                          color: Color(0xFF66C8C8),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        filePath!,
                        style: const TextStyle(
                          color: Colors.white70,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),

                const SizedBox(height: 30),

                // 🔴 رسالة الخطأ إذا الناتج فاضي
                if ((decryptedText == null || decryptedText!.trim().isEmpty) &&
                    (filePath == null || filePath!.trim().isEmpty))
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Text(
                      "If output is empty. Check that the key and input are correct",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.redAccent,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 20,
                  runSpacing: 10,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _shareContent,
                      icon: const Icon(Icons.share, color: Color(0xFF66C8C8)),
                      label: const Text("Share"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E2E2E),
                        side: const BorderSide(color: Color(0xFF66C8C8)),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _downloadFile(context),
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
      ),
    );
  }
}
