import 'package:flutter/material.dart';
import 'package:login1/main_layout_normal.dart';

class NewUserProfilePage extends StatefulWidget {
  final String email;
  final String password; // ✅ Password from previous page

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
  final TextEditingController ageController = TextEditingController(); // ✅ Added age controller
  String? selectedGender;

  void _createAccount() {
    if (nameController.text.isEmpty ||
        mobileController.text.isEmpty ||
        ageController.text.isEmpty || // ✅ Check age
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

    print('✅ Account Created:');
    print('Email: ${widget.email}');
    print('Password: ${widget.password}');
    print('Name: ${nameController.text}');
    print('Mobile: ${mobileController.text}');
    print('Age: ${ageController.text}'); // ✅ Print age
    print('Gender: $selectedGender');

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const MainLayoutNormal()),
          (route) => false,
    );
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

              // Email (read-only)
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

              // Name
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

              // Age ✅
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

              // Mobile
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

              // Gender dropdown
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
                onPressed: _createAccount,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E2E2E),
                  side: const BorderSide(color: Color(0xFF66C8C8)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
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
