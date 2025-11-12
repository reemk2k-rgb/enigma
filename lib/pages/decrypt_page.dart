import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:login1/constants.dart';
import 'package:login1/pages/decryption_success_page.dart';

class DecryptPage extends StatefulWidget {
  const DecryptPage({super.key});

  @override
  State<DecryptPage> createState() => _DecryptPageState();
}

class _DecryptPageState extends State<DecryptPage> {
  final TextEditingController keyController = TextEditingController();
  final TextEditingController textController = TextEditingController();

  bool isLoading = false;

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
                leading: const Icon(Icons.insert_drive_file, color: Color(0xFF66C8C8)),
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

  Future<void> _decryptAction() async {
    if (textController.text.isEmpty || keyController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("You must enter the encrypted text and the key."),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      // ✅ ربط حقيقي مع السيرفر في Render
      final url = Uri.parse('${baseUrl}crypto/decrypt');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'data_type': 'text',
          'encrypted': textController.text,
          'key_b64': keyController.text,
          'algorithm': 'AES', // مؤقت إلى أن تضيفي اختيار الخوارزمية لاحقاً
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DecryptionSuccessPage(
                decryptedText: data['decrypted'],
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${data['error'] ?? 'Decryption failed'}'),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Server error (${response.statusCode})'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Connection error: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      setState(() => isLoading = false);
    }
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

            // 🔐 صندوق النص المشفر
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
                      hintText: 'Paste the encrypted text here',
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
                hintText: 'Enter the key used for encryption',
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
              child: isLoading
                  ? const CircularProgressIndicator(color: Color(0xFF66C8C8))
                  : ElevatedButton.icon(
                onPressed: _decryptAction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E2E2E),
                  side: const BorderSide(color: Color(0xFF66C8C8)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                      vertical: 12, horizontal: 24),
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