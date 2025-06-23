import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text("About Us"),
        backgroundColor: Colors.pinkAccent,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Background faded logo
          Opacity(
            opacity: 0.1,
            child: Center(
              child: Image.asset(
                'assets/images/mist_logo.png', // ✅ Make sure this image exists
                width: 300,
              ),
            ),
          ),
          // Content on top
          Center(
            child: Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.pinkAccent),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    "FixItNow - MIST Classroom Issue Reporting System",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    "FixItNow is a complaint reporting app designed for students at MIST. "
                    "Class Representatives can report issues related to classroom infrastructure such as lights, fans, projectors, furniture, and computers. "
                    "The Admin panel assigns tasks to relevant departments and tracks completion.",
                    style: TextStyle(fontSize: 14, color: Colors.white70),
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Developed as part of the CSE Software Development Project II at the Military Institute of Science and Technology (MIST).",
                    style: TextStyle(fontSize: 13, color: Colors.white60),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
