import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:login1/constants.dart';

class AwarenessInformationPage extends StatefulWidget {
  const AwarenessInformationPage({super.key});

  @override
  State<AwarenessInformationPage> createState() =>
      _AwarenessInformationPageState();
}

class _AwarenessInformationPageState extends State<AwarenessInformationPage> {
  String? awarenessText;
  bool isLoading = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchAwarenessData();
  }

  Future<void> fetchAwarenessData() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final url = Uri.parse('$baseUrl/awareness/info');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          setState(() {
            awarenessText = data['message'] ?? 'No awareness content found.';
          });
        } else {
          setState(() {
            errorMessage = data['error'] ?? 'Failed to load content.';
          });
        }
      } else {
        setState(() {
          errorMessage = 'Server error (${response.statusCode}).';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error while connecting to server: $e';
      });
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2E2E2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E2E2E),
        title: const Text(
          "Awareness Information",
          style: TextStyle(color: Color(0xFF66C8C8)),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator(color: Color(0xFF66C8C8))
            : errorMessage != null
            ? Text(
          errorMessage!,
          style:
          const TextStyle(color: Colors.redAccent, fontSize: 16),
          textAlign: TextAlign.center,
        )
            : Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            awarenessText ??
                'This is the Awareness Information Page',
            style: const TextStyle(
              color: Color(0xFF66C8C8),
              fontSize: 18,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}