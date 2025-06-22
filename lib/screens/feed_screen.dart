import 'package:flutter/material.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Feed"),
        backgroundColor: Colors.pink[400],
      ),
      body: const Center(
        child: Text(
          "News Feed / Announcement area coming soon...",
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
      backgroundColor: const Color(0xFF121212),
    );
  }
}
