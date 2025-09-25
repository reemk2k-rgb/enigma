import 'package:flutter/material.dart';


class ProfileDetailsPage extends StatefulWidget {
  const ProfileDetailsPage({super.key});

  @override
  State<ProfileDetailsPage> createState() => _ProfileDetailsPageState();
}

class _ProfileDetailsPageState extends State<ProfileDetailsPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  String _selectedGender = 'Male';

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
      body: Padding(
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
              onPressed: () {
                // تنفيذ التحديث، بإمكانك إضافة منطق الحفظ هنا
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profile updated')),
                );
              },
            ),

            const SizedBox(height: 20),

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

  Widget _buildButton({required String text, required Color color, required VoidCallback onPressed}) {
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
