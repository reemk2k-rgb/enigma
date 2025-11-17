import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:login1/constants.dart';
import 'package:login1/pages/EncryptionSuccessPageGuest.dart';

class GuestPage extends StatefulWidget {
  const GuestPage({super.key});

  @override
  State<GuestPage> createState() => _GuestPageState();
}

class _GuestPageState extends State<GuestPage> {
  final TextEditingController _textController = TextEditingController();
  int attemptsLeft = 3;
  bool isLoading = false;

  Future<void> _encryptText() async {
    final text = _textController.text.trim();

    // ⛔ نص فاضي
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter some text."),
          backgroundColor: Color(0xFF2E2E2E),
        ),
      );
      return;
    }

    // ⛔ حد الكلمات
    final wordCount = text.split(RegExp(r'\s+')).length;
    if (wordCount > 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("You can only encrypt up to 100 words."),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    // ⛔ تخطى المحاولات
    if (attemptsLeft <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("You have reached the maximum number of attempts."),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final url = Uri.parse('${baseUrl}crypto/encrypt/guest');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "content": text,
          "method": "AES-CBC" // 🔐 نختار AES للضيوف افتراضياً
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success'] == true) {
          final encrypted = data['encrypted'];   // ✔ الاسم الصحيح من الباك
          final key = data['key_b64'];          // ✔ مفتاح التشفير
          final algo = data['algorithm'];       // ✔ نوع الخوارزمية

          setState(() => attemptsLeft -= 1);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EncryptionSuccessPageGuest(
                encryptedText: encrypted,
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(data['error'] ?? 'Encryption failed.'),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
            Text('Server error: ${response.statusCode.toString()}'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error connecting to server: $e"),
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
        padding: const EdgeInsets.fromLTRB(24, 100, 24, 40),
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
            const SizedBox(height: 80),

            TextField(
              controller: _textController,
              maxLength: 500,
              maxLines: 5,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Write/paste your text up to 100 words',
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
            Text(
              'Attempts Left: $attemptsLeft',
              style: const TextStyle(
                color: Color(0xFF66C8C8),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 20),

            Center(
              child: ElevatedButton.icon(
                onPressed: isLoading ? null : _encryptText,
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
                icon: isLoading
                    ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    color: Color(0xFF66C8C8),
                    strokeWidth: 2,
                  ),
                )
                    : const Icon(Icons.lock, color: Color(0xFF66C8C8)),
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