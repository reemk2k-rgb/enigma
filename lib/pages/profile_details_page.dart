import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';

class ProfileDetailsPage extends StatefulWidget {
  const ProfileDetailsPage({super.key});

  @override
  State<ProfileDetailsPage> createState() => _ProfileDetailsPageState();
}

class _ProfileDetailsPageState extends State<ProfileDetailsPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  String _selectedGender = 'Male';
  bool isLoading = true;

  // ============================
  // 🔥 Load Profile from Backend
  // ============================
  Future<void> _loadProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");

      if (token == null) return;

      final url = Uri.parse("${baseUrl}auth/profile");

      final response = await http.get(
        url,
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final user = data["user"];

        setState(() {
          _nameController.text = user["name"] ?? "";
          _mobileController.text = user["phone"] ?? "";
          _emailController.text = user["email"] ?? "";
          _ageController.text = user["age"] ?? "";
          _selectedGender = user["gender"] ?? "Male";
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  // ============================
  // 🔥 Update Profile
  // ============================
  Future<void> _updateProfile() async {
    final name = _nameController.text.trim();
    final phone = _mobileController.text.trim();
    final age = _ageController.text.trim();
    final gender = _selectedGender;

    // ==== Validation ====
    if (phone.isEmpty) {
      _error("Mobile number cannot be empty");
      return;
    }

    if (!phone.startsWith("966")) {
      _error("Saudi number must start with 966");
      return;
    }

    if (phone.length != 12 || int.tryParse(phone) == null) {
      _error("Invalid Saudi number — must be 966XXXXXXXXX");
      return;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");
      if (token == null) return;

      final url = Uri.parse("${baseUrl}auth/profile/update");

      final response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "name": name,
          "phone": phone,
          "age": age,
          "gender": gender,
        }),
      );

      if (response.statusCode == 200) {
        _success("Profile updated successfully");
      } else {
        _error("Update failed (${response.statusCode})");
      }
    } catch (e) {
      _error("Connection error");
    }
  }

  void _error(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  void _success(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: const Color(0xFF2E2E2E),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  // ============================
  // UI
  // ============================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2E2E2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E2E2E),
        elevation: 0,
        title: const Text(
          'My Profile',
          style: TextStyle(color: Color(0xFF66C8C8)),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF66C8C8)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF66C8C8)))
          : Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel('Name'),
            _buildTextField(controller: _nameController),

            const SizedBox(height: 20),
            _buildLabel('Mobile number'),
            _buildTextField(controller: _mobileController, keyboardType: TextInputType.phone),

            const SizedBox(height: 20),
            _buildLabel('Email address'),
            _buildTextField(controller: _emailController, keyboardType: TextInputType.emailAddress),

            const SizedBox(height: 20),
            _buildLabel('Age'),
            _buildTextField(controller: _ageController, keyboardType: TextInputType.number),

            const SizedBox(height: 20),
            _buildLabel('Gender'),
            Row(
              children: [
                _buildGenderOption('Male'),
                const SizedBox(width: 20),
                _buildGenderOption('Female'),
              ],
            ),

            const SizedBox(height: 30),
            _buildButton(
              text: 'Update',
              color: const Color(0xFF66C8C8),
              onPressed: _updateProfile,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Color(0xFF66C8C8),
        fontSize: 16,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      decoration: const InputDecoration(
        filled: true,
        fillColor: Color(0xFF3A3A3A),
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF66C8C8)),
        ),
      ),
    );
  }

  Widget _buildGenderOption(String gender) {
    return Row(
      children: [
        Radio<String>(
          activeColor: const Color(0xFF66C8C8),
          value: gender,
          groupValue: _selectedGender,
          onChanged: (value) {
            setState(() {
              _selectedGender = value!;
            });
          },
        ),
        Text(
          gender,
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildButton({
    required String text,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        onPressed: onPressed,
        child: Text(text, style: const TextStyle(fontSize: 16)),
      ),
    );
  }
}