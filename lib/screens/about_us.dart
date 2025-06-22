import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121212),
      appBar: AppBar(title: Text("About Us"), backgroundColor: Colors.pink),
      body: Center(
        child: Text(
          "FixItNow helps students report classroom issues.",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
