import 'package:flutter/material.dart';

class AwarenessInformationPage extends StatelessWidget {
  const AwarenessInformationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2E2E2E),
      body: const Center(
        child: Text(
          'This is the Awareness Information Page',
          style: TextStyle(color: Color(0xFF66C8C8), fontSize: 20),
        ),
      ),
    );
  }
}
