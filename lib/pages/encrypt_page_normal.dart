import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:login1/constants.dart';
import 'package:login1/pages/encryption_success_page.dart';

class EncryptPageNormal extends StatefulWidget {
  const EncryptPageNormal({super.key});

  @override
  State<EncryptPageNormal> createState() => _EncryptPageNormalState();
}

class _EncryptPageNormalState extends State<EncryptPageNormal> {
  String? selectedEncryption;
  final TextEditingController _textController = TextEditingController();
  bool isLoading = false;


  final List<String> encryptionTypes = [
    "AES-CBC",
    "ChaCha-Poly1305",
    "Hybrid Encryption (Recommended)",
  ];


  // ---------------------------------------------------------
  // POPUP: WIFI PASSWORD
  // ---------------------------------------------------------
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
                "Wi-Fi Password",
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
                  labelText: "Wi-Fi Password",
                  labelStyle: TextStyle(color: Color(0xFF66C8C8)),
                  filled: true,
                  fillColor: Colors.black26,
                ),
              ),

              const SizedBox(height: 25),

              ElevatedButton(
                onPressed: () {
                  final wifiJson =
                      '{"password": "${passController.text.trim()}"}';

                  setState(() {
                    _textController.text = wifiJson;
                  });

                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E2E2E),
                    side: const BorderSide(color: Color(0xFF66C8C8))),
                child: const Text("Use Password",
                    style: TextStyle(color: Color(0xFF66C8C8))),
              ),
            ],
          ),
        );
      },
    );
  }

  // ---------------------------------------------------------
  // POPUP: URL
  // ---------------------------------------------------------
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
                "Encrypt URL",
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
                  labelText: "Enter URL",
                  labelStyle: TextStyle(color: Color(0xFF66C8C8)),
                  filled: true,
                  fillColor: Colors.black26,
                ),
              ),

              const SizedBox(height: 25),

              ElevatedButton(
                onPressed: () {
                  final urlJson =
                      '{"url": "${urlController.text.trim()}"}';

                  setState(() {
                    _textController.text = urlJson;
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

  // ---------------------------------------------------------
  // POPUP: FILE PICKER → BASE64
  // ---------------------------------------------------------
  void _pickFile() async {
    FilePickerResult? result =
    await FilePicker.platform.pickFiles(withData: true);

    if (result != null) {
      final fileBytes = result.files.first.bytes!;
      final fileName = result.files.first.name;

      final base64File = base64Encode(fileBytes);

      final jsonFile = '''
{
  "filename": "$fileName",
  "base64": "$base64File"
}
''';

      setState(() {
        _textController.text = jsonFile;
      });
    }
  }

  // ---------------------------------------------------------
  // OPTIONS POPUP (WiFi / URL / File)
  // ---------------------------------------------------------
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
                title: const Text("Wi-Fi Password",
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
                leading:
                const Icon(Icons.insert_drive_file, color: Color(0xFF66C8C8)),
                title: const Text("File",
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  _pickFile();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // ---------------------------------------------------------
  // SEND TO BACKEND
  // ---------------------------------------------------------
  Future<void> _encryptText() async {
    if (_textController.text.isEmpty || selectedEncryption == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please enter data and select encryption type'),
            backgroundColor: Colors.redAccent),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('You must login first'),
              backgroundColor: Colors.redAccent),
        );
        return;
      }

      final url = Uri.parse("${baseUrl}crypto/encrypt");

      String algo = selectedEncryption!;
      if (algo == "ChaCha-Poly1305") algo = "CHACHA20-POLY1305";
      if (algo == "Hybrid Encryption") algo = "HYBRID";

      final response = await http.post(url,
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
          body: jsonEncode({
            "data_type": "text",
            "content": _textController.text,
            "algorithm": algo,
          }));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EncryptionSuccessPage(
              encryptedText: data["encrypted"],
              encryptionKey: data["key_b64"],
              algorithm: data["algorithm"],
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Server error: ${response.statusCode}"),
              backgroundColor: Colors.redAccent),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Error: $e"),
            backgroundColor: Colors.redAccent),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  // ---------------------------------------------------------
  // UI
  // ---------------------------------------------------------
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
              child: Image.asset('assets/images/enigma_key.png', width: 80),
            ),
            const SizedBox(height: 40),

            // TEXT FIELD
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
                      icon: const Icon(Icons.add, color: Color(0xFF66C8C8)),
                      onPressed: _showOptions,
                    ),
                  ),
                  const SizedBox(height: 10),

                  TextField(
                    controller: _textController,
                    maxLength: 2000,
                    maxLines: 5,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: "Write or paste your data here...",
                      hintStyle: TextStyle(color: Color(0xFF66C8C8)),
                      filled: true,
                      fillColor: Colors.black26,
                      border:
                      OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF66C8C8))),
                      focusedBorder:
                      OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF66C8C8))),
                      counterStyle: TextStyle(color: Color(0xFF66C8C8)),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ENCRYPT TYPE DROPDOWN
            DropdownButtonFormField<String>(
              value: selectedEncryption,
              dropdownColor: const Color(0xFF2E2E2E),
              decoration: const InputDecoration(
                labelText: 'Select encryption type',
                labelStyle: TextStyle(color: Color(0xFF66C8C8)),
                enabledBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF66C8C8))),
                focusedBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF66C8C8))),
              ),
              items: encryptionTypes
                  .map((t) => DropdownMenuItem(
                  value: t,
                  child: Text(t, style: const TextStyle(color: Colors.white))))
                  .toList(),
              onChanged: (v) => setState(() => selectedEncryption = v),
            ),

            const SizedBox(height: 30),

            Center(
              child: ElevatedButton.icon(
                onPressed: isLoading ? null : _encryptText,
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E2E2E),
                    side: const BorderSide(color: Color(0xFF66C8C8))),
                icon: isLoading
                    ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                      color: Color(0xFF66C8C8), strokeWidth: 2),
                )
                    : const Icon(Icons.lock, color: Color(0xFF66C8C8)),
                label: const Text(
                  "Encrypt",
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