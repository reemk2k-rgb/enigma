import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:login1/main_layout_normal.dart';
import 'package:login1/pages/forgot_password_page.dart';

class PasswordPage extends StatefulWidget {
  final String email;

  const PasswordPage({super.key, required this.email});

  @override
  State<PasswordPage> createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  String selectedGender = 'Female';

  final storage = const FlutterSecureStorage();

  bool? isNewUser;
  bool loading = true;

  // ================================================
  // ✅ إصلاح check-email — الآن يعمل 100% بشكل صحيح
  // ================================================
  Future<void> _checkUserStatus() async {
    try {
      final url = Uri.parse('https://enigma-09np.onrender.com/auth/check-email');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"email": widget.email}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          isNewUser = !(data["exists"] ?? false);
          loading = false;
        });
      } else {
        setState(() {
          isNewUser = true;
          loading = false;
        });
      }
    } catch (e) {
      setState(() {
        isNewUser = true;
        loading = false;
      });
    }
  }

  bool _isValidPassword(String password) {
    final passwordRegex = RegExp(
        r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');
    return passwordRegex.hasMatch(password);
  }

  Future<void> _handleAuth(
      BuildContext context,
      bool newUser,
      String email,
      String password,
      String? confirmPassword,
      ) async {
    try {
      final url = Uri.parse(
        newUser
            ? 'https://enigma-09np.onrender.com/auth/register'
            : 'https://enigma-09np.onrender.com/auth/login',
      );

      final Map<String, dynamic> body = {
        "email": email,
        "password": password,
      };

      if (newUser) {
        body["confirm_password"] = confirmPassword ?? "";
        body["name"] = nameController.text.trim();
        body["age"] = ageController.text.trim();
        body["phone"] = "0${phoneController.text.trim()}";
        body["gender"] = selectedGender;
      }

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (data["token"] != null) {
          await storage.write(key: 'jwt', value: data["token"]);

          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', data["token"]);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              newUser ? 'Account created successfully!' : 'Login successful!',
              style: const TextStyle(color: Color(0xFF66C8C8)),
            ),
            backgroundColor: const Color(0xFF2E2E2E),
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
              data['error'] ?? data['message'] ?? 'Authentication failed!',
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
  void initState() {
    super.initState();
    _checkUserStatus();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        backgroundColor: Color(0xFF2E2E2E),
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF66C8C8)),
        ),
      );
    }

    final bool newUser = isNewUser ?? true;

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
              Text(
                newUser
                    ? "Hi, New Friend 👋\nLet's create your account!"
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

              if (newUser) ...[
                TextField(
                  controller: nameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: "Enter your name",
                    hintStyle: TextStyle(color: Color(0xFF66C8C8)),
                    filled: true,
                    fillColor: Colors.black26,
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),

                TextField(
                  controller: ageController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: "Enter your age",
                    hintStyle: TextStyle(color: Color(0xFF66C8C8)),
                    filled: true,
                    fillColor: Colors.black26,
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),

                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.number,
                  maxLength: 9,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    prefixText: "+966 ",
                    prefixStyle: TextStyle(color: Color(0xFF66C8C8)),
                    counterText: "",
                    hintText: "5XXXXXXXX",
                    hintStyle: TextStyle(color: Color(0xFF66C8C8)),
                    filled: true,
                    fillColor: Colors.black26,
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    if (value.startsWith('0')) {
                      phoneController.text = value.substring(1);
                      phoneController.selection = TextSelection.fromPosition(
                        TextPosition(offset: phoneController.text.length),
                      );
                    }

                    phoneController.text =
                        phoneController.text.replaceAll(RegExp(r'[^0-9]'), '');

                    phoneController.selection = TextSelection.fromPosition(
                      TextPosition(offset: phoneController.text.length),
                    );
                  },
                ),
                const SizedBox(height: 20),

                DropdownButtonFormField<String>(
                  value: selectedGender,
                  dropdownColor: const Color(0xFF2E2E2E),
                  decoration: const InputDecoration(
                    labelText: "Select Gender",
                    labelStyle: TextStyle(color: Color(0xFF66C8C8)),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF66C8C8)),
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: "Female",
                      child: Text("Female", style: TextStyle(color: Colors.white)),
                    ),
                    DropdownMenuItem(
                      value: "Male",
                      child: Text("Male", style: TextStyle(color: Colors.white)),
                    ),
                  ],
                  onChanged: (value) => setState(() => selectedGender = value!),
                ),
                const SizedBox(height: 20),
              ],

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
                ),
              ),

              if (newUser) ...[
                const SizedBox(height: 20),
                TextField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: "Confirm your password",
                    hintStyle: TextStyle(color: Color(0xFF66C8C8)),
                    filled: true,
                    fillColor: Colors.black26,
                    border: OutlineInputBorder(),
                  ),
                ),
              ],

              if (!newUser) ...[
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ForgotPasswordPage()),
                    );
                  },
                  child: const Text(
                    "Forgot Password?",
                    style: TextStyle(color: Color(0xFF66C8C8)),
                  ),
                ),
              ],

              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: () async {
                  final password = passwordController.text.trim();
                  final confirmPassword = confirmPasswordController.text.trim();

                  if (password.isEmpty) {
                    ScaffoldMessenger.of(context).
                    showSnackBar(
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

                  if (newUser && password != confirmPassword) {
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
                          'Password must contain:\n• At least 8 characters\n• Uppercase and lowercase letters\n• A number\n• A special symbol @  \$  !  %  *  ?  &',
                          style: TextStyle(color: Color(0xFF66C8C8)),
                        ),
                        backgroundColor: Color(0xFF2E2E2E),
                        duration: Duration(seconds: 5),
                      ),
                    );
                    return;
                  }

                  if (newUser) {
                    final phoneInput = phoneController.text.trim();

                    if (phoneInput.length != 9 ||
                        !RegExp(r'^[0-9]+$').hasMatch(phoneInput)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Phone number must be 9 digits after +966.',
                            style: TextStyle(color: Color(0xFF66C8C8)),
                          ),
                          backgroundColor: Color(0xFF2E2E2E),
                        ),
                      );
                      return;
                    }
                  }

                  await _handleAuth(
                    context,
                    newUser,
                    widget.email,
                    password,
                    confirmPassword,
                  );
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
      ),
    );
  }
}