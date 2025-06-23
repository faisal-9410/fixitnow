import 'package:flutter/material.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text("Contact Us"),
        backgroundColor: Colors.pinkAccent,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Faded background logo
          Opacity(
            opacity: 0.1,
            child: Center(
              child: Image.asset(
                'assets/images/mist_logo.png', // Make sure this image exists
                width: 300,
              ),
            ),
          ),
          // Main contact info card
          Center(
            child: Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color.fromRGBO(
                  255,
                  255,
                  255,
                  0.1,
                ), // White with 10% opacity
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.pinkAccent),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(
                      0,
                      0,
                      0,
                      0.3,
                    ), // Black with 30% opacity
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    "FixItNow - Contact Information",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 15),
                  Text(
                    "📧 Email: support@fixitnow.com",
                    style: TextStyle(fontSize: 14, color: Colors.white70),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "📞 Phone: +880 1769-001111",
                    style: TextStyle(fontSize: 14, color: Colors.white70),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "🏫 Address: Dept. of CSE, MIST, Mirpur Cantonment, Dhaka, Bangladesh",
                    style: TextStyle(fontSize: 14, color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 15),
                  Text(
                    "We value your feedback and are here to support you with any classroom issue reporting.",
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
