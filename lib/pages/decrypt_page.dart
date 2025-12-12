import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  // ---------------- OPTIONS POPUPS ---------------- //

  void _openWifiPopup() {
    final passController = TextEditingController();

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF2E2E2E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Wi-Fi Password (Encrypted Input)",
                style: TextStyle(
                    color: Color(0xFF66C8C8),
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: passController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: "Encrypted Wi-Fi JSON",
                  labelStyle: TextStyle(color: Color(0xFF66C8C8)),
                  filled: true,
                  fillColor: Colors.black26,
                ),
              ),
              const SizedBox(height: 25),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    textController.text = passController.text.trim();
                  });
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E2E2E),
                    side: const BorderSide(color: Color(0xFF66C8C8))),
                child: const Text("Use",
                    style: TextStyle(color: Color(0xFF66C8C8))),
              ),
            ],
          ),
        );
      },
    );
  }

  void _openUrlPopup() {
    final urlController = TextEditingController();

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF2E2E2E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Encrypted URL",
                style: TextStyle(
                    color: Color(0xFF66C8C8),
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: urlController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: "Paste encrypted URL JSON",
                  labelStyle: TextStyle(color: Color(0xFF66C8C8)),
                  filled: true,
                  fillColor: Colors.black26,
                ),
              ),
              const SizedBox(height: 25),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    textController.text = urlController.text.trim();
                  });
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E2E2E),
                    side: const BorderSide(color: Color(0xFF66C8C8))),
                child: const Text("Use URL",
                    style: TextStyle(color: Color(0xFF66C8C8))),
              ),
            ],
          ),
        );
      },
    );
  }

  void _pickEncryptedFile() async {
    final result = await FilePicker.platform.pickFiles(withData: true);

    if (result != null) {
      final fileBytes = result.files.first.bytes!;
      final base64Content = base64Encode(fileBytes);
      final jsonFile = '''{ "base64": "$base64Content"}''';

      setState(() {
        textController.text = jsonFile;
      });
    }
  }

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
                leading:
                const Icon(Icons.wifi, color: Color(0xFF66C8C8)),
                title: const Text("Wi-Fi",
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  _openWifiPopup();
                },
              ),
              ListTile(
                leading:
                const Icon(Icons.link, color: Color(0xFF66C8C8)),
                title: const Text("URL",
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  _openUrlPopup();
                },
              ),
              ListTile(
                leading: const Icon(Icons.insert_drive_file,
                    color: Color(0xFF66C8C8)),
                title: const Text("File",
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  _pickEncryptedFile();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // ---------------- FILE SAVE ---------------- //

  Future<File> _saveFileFromBase64(String b64, String fileName) async {
    final bytes = base64Decode(b64);
    final dir = await getApplicationDocumentsDirectory();
    final file = File("${dir.path}/$fileName");
    await file.writeAsBytes(bytes);
    return file;
  }

  // ---------------- DECRYPT ---------------- //

  Future<void> _decryptAction() async {
    if (textController.text.isEmpty || keyController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("You must enter encrypted text and key."),
        backgroundColor: Colors.redAccent,
      ));
      return;
    }

    setState(() => isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final url = Uri.parse("${baseUrl}crypto/decrypt");

      final response = await http.post(url,
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
          body: jsonEncode({
            "encrypted": textController.text.trim(),
            "key_b64": keyController.text.trim(),
            "algorithm": "AUTO",
          }));

      final data = jsonDecode(response.body);

      final decrypted = data["decrypted"];

      // ---------------- FILE DETECTION ---------------- //

      try {
        final obj = jsonDecode(decrypted);

        if (obj is Map && obj.containsKey("base64")) {
          final fileName = (obj["filename"] as String?) ?? "decrypted_file";
          final b64 = obj["base64"] as String;

          final file = await _saveFileFromBase64(b64, fileName);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DecryptionSuccessPage(
                filePath: file.path,
                decryptedText: null,
              ),
            ),
          );
          return;
        }
      } catch (_) {}

      // ---------------- WIFI ---------------- //
      try {
        final obj = jsonDecode(decrypted);
        if (obj is Map && obj.containsKey("password")) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  DecryptionSuccessPage(decryptedText: obj["password"]),
            ),
          );
          return;
        }
      } catch (_) {}

      // ---------------- TEXT ---------------- //
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              DecryptionSuccessPage(decryptedText: decrypted),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Connection error: $e"),
        backgroundColor: Colors.redAccent,
      ));
    } finally {
      setState(() => isLoading = false);
    }
  }

  // ---------------- UI ---------------- //

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2E2E2E),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 60, 24, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
                alignment: Alignment.topLeft,
                child: Image.asset('assets/images/enigma_key.png', width: 80)),
            const SizedBox(height: 40),

            // TEXT INPUT
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black26,
                border: Border.all(color: Color(0xFF66C8C8)),
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
                    maxLines: null,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'Paste encrypted text here...',
                      hintStyle: TextStyle(color: Color(0xFF66C8C8)),
                      filled: true,
                      fillColor: Colors.black26,
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            const Text("Key",
                style: TextStyle(
                    color: Color(0xFF66C8C8),
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: keyController,
              obscureText: true,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Enter key used for encryption',
                hintStyle: const TextStyle(color: Color(0xFF66C8C8)),
                filled: true,
                fillColor: Colors.black26,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8)),
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
                    side:
                    const BorderSide(color: Color(0xFF66C8C8))),
                icon: const Icon(Icons.lock_open,
                    color: Color(0xFF66C8C8)),
                label: const Text(
                  'Decrypt',
                  style: TextStyle(
                      color: Color(0xFF66C8C8),
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}