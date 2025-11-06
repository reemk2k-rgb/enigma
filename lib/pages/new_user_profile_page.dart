import 'package:flutter/material.dart';
import 'package:login1/main_layout_normal.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NewUserProfilePage extends StatefulWidget {
  final String email;
  final String password;

  const NewUserProfilePage({
    super.key,
    required this.email,
    required this.password,
  });

  @override
  State<NewUserProfilePage> createState() => _NewUserProfilePageState();
}

class _NewUserProfilePageState extends State<NewUserProfilePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  String? selectedGender;
  bool _isLoading = false;

  Future<void> _createAccount() async {
    if (nameController.text.isEmpty ||
        mobileController.text.isEmpty ||
        ageController.text.isEmpty ||
        selectedGender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please fill all fields before continuing.',
            style: TextStyle(color: Color(0xFF66C8C8)),
          ),
          backgroundColor: Color(0xFF2E2E2E),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:5000/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "name": nameController.text,
          "email": widget.email,
          "password": widget.password,
          "confirm_password": widget.password,
          "phone": mobileController.text,
          "age": ageController.text,
          "gender": selectedGender,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201 && data["token"] != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Account created successfully!"),
            backgroundColor: Color(0xFF2E2E2E),
          ),
        );

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MainLayoutNormal()),
              (route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              data["error"] ?? "Registration failed",
              style: const TextStyle(color: Color(0xFF66C8C8)),
            ),
            backgroundColor: const Color(0xFF2E2E2E),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Error: $e",
            style: const TextStyle(color: Color(0xFF66C8C8)),
          ),
          backgroundColor: const Color(0xFF2E2E2E),
        ),
      );
    } finally {
      setState(() => _isLoading = false);
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
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Complete Your Profile",
                style: TextStyle(
                  color: Color(0xFF66C8C8),
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),

              TextField(
                enabled: false,
                controller: TextEditingController(text: widget.email),
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: "Email",
                  labelStyle: TextStyle(color: Color(0xFF66C8C8)),
                  filled: true,
                  fillColor: Colors.black26,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              TextField(
                controller: nameController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: "Full Name",
                  hintStyle: TextStyle(color: Color(0xFF66C8C8)),
                  filled: true,
                  fillColor: Colors.black26,
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF66C8C8)),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              TextField(
                controller: ageController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: "Age",
                  hintStyle: TextStyle(color: Color(0xFF66C8C8)),
                  filled: true,
                  fillColor: Colors.black26,
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF66C8C8)),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              TextField(
                controller: mobileController,
                keyboardType: TextInputType.phone,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: "Mobile Number",
                  hintStyle: TextStyle(color: Color(0xFF66C8C8)),
                  filled: true,
                  fillColor: Colors.black26,
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF66C8C8)),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              DropdownButtonFormField<String>(
                value: selectedGender,
                dropdownColor: const Color(0xFF2E2E2E),
                decoration: InputDecoration(
                  labelText: "Select Gender",
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
                items: const [
                  DropdownMenuItem(
                    value: "Male",
                    child: Text("Male", style: TextStyle(color: Colors.white)),
                  ),
                  DropdownMenuItem(
                    value: "Female",
                    child: Text("Female", style: TextStyle(color: Colors.white)),
                  ),
                ],
                onChanged: (value) => setState(() => selectedGender = value),
              ),
              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: _isLoading ? null : _createAccount,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E2E2E),
                  side: const BorderSide(color: Color(0xFF66C8C8)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Color(0xFF66C8C8))
                    : const Text(
                  "Save & Continue",
                  style: TextStyle(
                    color: Color(0xFF66C8C8),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}