import 'package:flutter/material.dart';
import 'package:login1/pages/encryption_success_page.dart';

class EncryptPageNormal extends StatefulWidget {
  const EncryptPageNormal({super.key});

  @override
  State<EncryptPageNormal> createState() => _EncryptPageNormalState();
}

class _EncryptPageNormalState extends State<EncryptPageNormal> {
  String? selectedEncryption;

  final List<String> encryptionTypes = ["AES", "RSA", "SHA-256", "Custom"];

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
                const Icon(Icons.insert_drive_file, color: Color(0xFF66C8C8)),
                title: const Text("File", style: TextStyle(color: Colors.white)),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading:
                const Icon(Icons.link, color: Color(0xFF66C8C8)),
                title: const Text("URL", style: TextStyle(color: Colors.white)),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading:
                const Icon(Icons.wifi, color: Color(0xFF66C8C8)),
                title:
                const Text("Wi-Fi", style: TextStyle(color: Colors.white)),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
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
                  const TextField(
                    maxLength: 200,
                    maxLines: 5,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Write/paste your text',
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

            DropdownButtonFormField<String>(
              value: selectedEncryption,
              dropdownColor: const Color(0xFF2E2E2E),
              decoration: InputDecoration(
                labelText: "Select Encryption Type",
                labelStyle: const TextStyle(color: Color(0xFF66C8C8)),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFF66C8C8)),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFF66C8C8)),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF66C8C8)),
              items: encryptionTypes
                  .map((type) => DropdownMenuItem(
                value: type,
                child:
                Text(type, style: const TextStyle(color: Colors.white)),
              ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedEncryption = value;
                });
              },
            ),

            const SizedBox(height: 30),

            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  String encryptedText = "example_encrypted_data";
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          EncryptionSuccessPage(encryptedText: encryptedText),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E2E2E),
                  side: const BorderSide(color: Color(0xFF66C8C8)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
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
