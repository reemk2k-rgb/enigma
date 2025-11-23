import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'reset_password_page.dart';

class ResetCodePage extends StatefulWidget {
  final String email;

  const ResetCodePage({super.key, required this.email});

  @override
  State<ResetCodePage> createState() => _ResetCodePageState();
}

class _ResetCodePageState extends State<ResetCodePage> {
  final List<TextEditingController> _controllers =
  List.generate(5, (_) => TextEditingController());

  Timer? _timer;
  int _secondsLeft = 300; // 5 minutes
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft == 0) {
        timer.cancel();
      } else {
        setState(() {
          _secondsLeft--;
        });
      }
    });
  }

  String get _code =>
      _controllers.map((controller) => controller.text).join();

  Future<void> _verifyCode() async {
    if (_code.length != 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Enter the 5-digit code",
            style: TextStyle(color: Color(0xFF66C8C8)),
          ),
          backgroundColor: Color(0xFF2E2E2E),
        ),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      final response = await http.post(
        Uri.parse("https://enigma-09np.onrender.com/auth/verify-reset-code"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": widget.email,
          "code": _code,
        }),
      );

      setState(() => _loading = false);

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data["success"] == true) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResetPasswordPage(
              email: widget.email,
              code: _code,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              data["error"] ?? "Invalid code",
              style: const TextStyle(color: Color(0xFF66C8C8)),
            ),
            backgroundColor: const Color(0xFF2E2E2E),
            duration: const Duration(seconds: 3), // ✅ بدل damage
          ),
        );
      }
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Error: $e",
            style: const TextStyle(color: Color(0xFF66C8C8)),
          ),
          backgroundColor: const Color(0xFF2E2E2E),
        ),
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final minutes = _secondsLeft ~/ 60;
    final seconds = _secondsLeft % 60;

    return Scaffold(
      backgroundColor: const Color(0xFF2E2E2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E2E2E),
        iconTheme: const IconThemeData(color: Color(0xFF66C8C8)),
        title: const Text(
          "Enter Code",
          style: TextStyle(color: Color(0xFF66C8C8)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),

            const Text(
              "Enter the 5-digit code sent to your email",
              style: TextStyle(color: Color(0xFF66C8C8), fontSize: 16),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 25),

            Text(
              "$minutes:${seconds.toString().padLeft(2, '0')}",
              style: const TextStyle(
                color: Colors.redAccent,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                5,
                    (index) => SizedBox(
                  width: 45,
                  child: TextField(
                    controller: _controllers[index],
                    maxLength: 1,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Colors.white, fontSize: 20),
                    decoration: const InputDecoration(
                      counterText: "",
                      filled: true,
                      fillColor: Colors.black26,
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty && index < 4) {
                        FocusScope.of(context).nextFocus();
                      }
                    },
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _secondsLeft == 0 || _loading ? null : _verifyCode,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E2E2E),
                  side: const BorderSide(color: Color(0xFF66C8C8)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: _loading
                    ? const CircularProgressIndicator(color: Color(0xFF66C8C8))
                    : const Text(
                  "Verify",
                  style: TextStyle(
                    color: Color(0xFF66C8C8),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}