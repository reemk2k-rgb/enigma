import 'package:flutter/material.dart';
import 'package:login1/main_layout_normal.dart';

class PasswordPage extends StatelessWidget {
  final String email;

  const PasswordPage({super.key, required this.email});

  /// دالة بسيطة للتحقق إذا الإيميل جديد أو موجود
  /// لاحقًا تقدر تربطها بقاعدة بيانات أو Firebase
  bool _isNewUser(String email) {
    // مثال: أي إيميل ينتهي بـ "new.com" نعتبره مستخدم جديد
    return email.endsWith("new.com");
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController passwordController = TextEditingController();
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
                  ? "Hi, New Friend! Set Your Password"
                  : "Welcome back! Enter your Password",
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
                hintText: "Password",
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
            ElevatedButton(
              onPressed: () {
                if (passwordController.text.isEmpty) {
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

                if (newUser) {
                  print("Account created for: $email");
                } else {
                  print("User logged in with: $email");
                }

                // التوجيه إلى واجهة المستخدم العادي
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const MainLayoutNormal()),
                      (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E2E2E),
                side: const BorderSide(color: Color(0xFF66C8C8)),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: Text(
                newUser ? "Create a New Account" : "Login",
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
