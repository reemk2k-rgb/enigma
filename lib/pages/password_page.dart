import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:login1/main_layout_normal.dart';
import 'package:login1/pages/new_user_profile_page.dart';

class PasswordPage extends StatelessWidget {
  final String email;

  const PasswordPage({super.key, required this.email});

  bool _isNewUser(String email) {
    return email.endsWith("new.com"); // مثال فقط، تقدر تغيّره حسب نظامك
  }

  bool _isValidPassword(String password) {
    final passwordRegex =
    RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');
    return passwordRegex.hasMatch(password);
  }

  Future<void> _handleAuth(
      BuildContext context, bool newUser, String email, String password) async {
    try {
      final url = Uri.parse(
        newUser
            ? 'https://your-backend.com/api/register' // 🟢 مسار التسجيل
            : 'https://your-backend.com/api/login', // 🔵 مسار تسجيل الدخول
      );

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              newUser ? 'Account created successfully!' : 'Login successful!',
              style: const TextStyle(color: Color(0xFF66C8C8)),
            ),
            backgroundColor: const Color(0xFF2E2E2E),
          ),
        );

        if (newUser) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  NewUserProfilePage(email: email, password: password),
            ),
          );
        } else {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const MainLayoutNormal()),
                (route) => false,
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              data['message'] ?? 'Authentication failed!',
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
            'Error connecting to server: $e',
            style: const TextStyle(color: Color(0xFF66C8C8)),
          ),
          backgroundColor: const Color(0xFF2E2E2E),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController confirmPasswordController =
    TextEditingController();
    final bool newUser = _isNewUser(email);

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              newUser
                  ? "Hi, New Friend 👋\nLet's set up your password!"
                  : "Welcome Back 👋\nEnter your password",
              style: const TextStyle(
                color: Color(0xFF66C8C8),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            TextField(
              enabled: false,
              controller: TextEditingController(text: email),
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
              controller: passwordController,
              obscureText: true,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: "Enter your password",
                hintStyle: TextStyle(color: Color(0xFF66C8C8)),
                filled: true,
                fillColor: Colors.black26,
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF66C8C8)),
                ),
              ),
            ),

            if (newUser) ...[
              const SizedBox(height: 20),
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: "Confirm password",
                  hintStyle: TextStyle(color: Color(0xFF66C8C8)),
                  filled: true,
                  fillColor: Colors.black26,
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF66C8C8)),
                  ),
                ),
              ),
            ],

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () async {
                final password = passwordController.text.trim();

                if (password.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Please enter a password.',
                        style: TextStyle(color: Color(0xFF66C8C8)),
                      ),
                      backgroundColor: Color(0xFF2E2E2E),
                    ),
                  );
                  return;
                }

                if (newUser &&
                    password != confirmPasswordController.text.trim()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Passwords do not match.',
                        style: TextStyle(color: Color(0xFF66C8C8)),
                      ),
                      backgroundColor: Color(0xFF2E2E2E),
                    ),
                  );
                  return;
                }

                if (newUser && !_isValidPassword(password)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Password must contain:\n• At least 8 characters\n• Uppercase and lowercase letters\n• A number\n• A special symbol',
                        style: TextStyle(color: Color(0xFF66C8C8)),
                      ),
                      backgroundColor: Color(0xFF2E2E2E),
                      duration: Duration(seconds: 5),
                    ),
                  );
                  return;
                }

                await _handleAuth(context, newUser, email, password);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E2E2E),
                side: const BorderSide(color: Color(0xFF66C8C8)),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: Text(
                newUser ? "Create Account" : "Login",
                style: const TextStyle(
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