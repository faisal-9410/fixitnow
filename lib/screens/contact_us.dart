import 'package:flutter/material.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121212),
      appBar: AppBar(title: Text("Contact Us"), backgroundColor: Colors.pink),
      body: Center(
        child: Text(
          "support@fixitnow.com",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
