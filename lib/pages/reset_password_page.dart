import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'password_page.dart';

class ResetPasswordPage extends StatefulWidget {
  final String email;
  final String code;

  const ResetPasswordPage({
    super.key,
    required this.email,
    required this.code,
  });

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();

  bool isLoading = false;

  Future<void> resetPassword() async {
    final password = passwordController.text.trim();
    final confirm = confirmController.text.trim();

    // ==============================
    // 🔐 نفس شروط PasswordPage بالضبط
    // ==============================
    final passwordRegex = RegExp(
        r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');

    if (!passwordRegex.hasMatch(password)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Color(0xFF2E2E2E),
          duration: Duration(seconds: 5),
          content: Text(
            "Password must contain:\n• At least 8 characters\n• Uppercase + lowercase\n• A number\n• A special symbol",
            style: TextStyle(color: Color(0xFF66C8C8)),
          ),
        ),
      );
      return;
    }

    if (password != confirm) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Color(0xFF2E2E2E),
          content: Text(
            "Passwords do not match",
            style: TextStyle(color: Color(0xFF66C8C8)),
          ),
        ),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final response = await http.post(
        Uri.parse("https://enigma-09np.onrender.com/auth/reset-password/app"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": widget.email,
          "code": widget.code,
          "new_password": password,
        }),
      );

      setState(() => isLoading = false);

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data["success"] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Color(0xFF2E2E2E),
            content: Text(
              "Password changed successfully!",
              style: TextStyle(color: Color(0xFF66C8C8)),
            ),
          ),
        );

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => PasswordPage(email: widget.email),
          ),
              (route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: const Color(0xFF2E2E2E),
            content: Text(
              data["error"] ?? "Something went wrong",
              style: const TextStyle(color: Color(0xFF66C8C8)),
            ),
          ),
        );
      }
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFF2E2E2E),
          content: Text(
            "Error: $e",
            style: const TextStyle(color: Color(0xFF66C8C8)),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2E2E2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E2E2E),
        iconTheme: const IconThemeData(color: Color(0xFF66C8C8)),
        title: const Text(
          "Reset Password",
          style: TextStyle(color: Color(0xFF66C8C8)),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 30),

            TextField(
              controller: passwordController,
              obscureText: true,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: "New Password",
                hintStyle: TextStyle(color: Color(0xFF66C8C8)),
                filled: true,
                fillColor: Colors.black26,
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: confirmController,
              obscureText: true,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: "Confirm Password",
                hintStyle: TextStyle(color: Color(0xFF66C8C8)),
                filled: true,
                fillColor: Colors.black26,
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 40),

            ElevatedButton(
              onPressed: isLoading ? null : resetPassword,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E2E2E),
                side: const BorderSide(color: Color(0xFF66C8C8)),
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 40),
              ),
              child: isLoading
                  ? const CircularProgressIndicator(color: Color(0xFF66C8C8))
                  : const Text(
                "Reset Password",
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
    );
  }
}
