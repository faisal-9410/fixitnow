import 'package:flutter/material.dart';

class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFEFEF), // Light ash background
      appBar: AppBar(
        backgroundColor: Colors.pink[700],
        title: const Text("My Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/user.png'),
            ),
            const SizedBox(height: 20),
            const Text(
              "Abdullah Faisal",
              style: TextStyle(
                color: Colors.black87,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Class Representative",
              style: TextStyle(color: Colors.black54, fontSize: 16),
            ),
            const SizedBox(height: 20),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 12,
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.email, color: Colors.pink),
                      title: const Text(
                        "abdullahfaisal@gmail.com",
                        style: TextStyle(color: Colors.black87),
                      ),
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.phone_android,
                        color: Colors.pink,
                      ),
                      title: const Text(
                        "+8801769009410",
                        style: TextStyle(color: Colors.black87),
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.school, color: Colors.pink),
                      title: const Text(
                        "Department: CSE",
                        style: TextStyle(color: Colors.black87),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
