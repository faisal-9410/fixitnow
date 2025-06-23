import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController mistRollController = TextEditingController();
  final TextEditingController levelController = TextEditingController();
  final TextEditingController sectionController = TextEditingController();
  final TextEditingController deptController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Dummy local print
      print("CR Registered:");
      print("Name: ${nameController.text}");
      print("MIST Roll: ${mistRollController.text}");
      print("Level: ${levelController.text}");
      print("Section: ${sectionController.text}");
      print("Department: ${deptController.text}");
      print("Email: ${emailController.text}");
      print("Mobile: ${mobileController.text}");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Registration successful (Dummy)")),
      );

      Navigator.pop(context); // Go back to login
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("CR Registration"),
        backgroundColor: Colors.pink[700],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              buildField("Name", nameController),
              buildField("MIST Roll No", mistRollController),
              buildField("Level", levelController),
              buildField("Section", sectionController),
              buildField("Department", deptController),
              buildField("Email", emailController),
              buildField("Mobile", mobileController),
              buildField("Password", passwordController, obscure: true),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 32),
                ),
                onPressed: _submitForm,
                child: const Text("Register"),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildField(String label, TextEditingController controller, {bool obscure = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white10,
          labelStyle: const TextStyle(color: Colors.grey),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        style: const TextStyle(color: Colors.black),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please enter $label";
          }
          return null;
        },
      ),
    );
  }
}
