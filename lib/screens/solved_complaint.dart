import 'package:flutter/material.dart';

class SolvedComplaintScreen extends StatelessWidget {
  const SolvedComplaintScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121212),
      appBar: AppBar(
        title: Text("Solved Complaints"),
        backgroundColor: Colors.pink,
      ),
      body: Center(
        child: Text(
          "No solved complaints yet.",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
