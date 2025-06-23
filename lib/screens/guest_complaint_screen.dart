import 'package:flutter/material.dart';

class GuestComplaintScreen extends StatefulWidget {
  const GuestComplaintScreen({super.key});

  @override
  State<GuestComplaintScreen> createState() => _GuestComplaintScreenState();
}

class _GuestComplaintScreenState extends State<GuestComplaintScreen> {
  int complaintCounter = 1;
  final TextEditingController guestNameController = TextEditingController();
  final TextEditingController crRollController = TextEditingController();
  final TextEditingController complaintTitleController =
      TextEditingController();
  final TextEditingController roomLocationController = TextEditingController();

  String generateComplaintID() {
    return "C${complaintCounter.toString().padLeft(4, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Guest Complaint Form"),
        backgroundColor: Colors.pink[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ListView(
          children: [
            Text(
              "Complaint ID: ${generateComplaintID()}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildTextField(guestNameController, "Your Name (Guest)"),
            _buildTextField(crRollController, "Absent CR's Roll Number"),
            _buildTextField(complaintTitleController, "Complaint Title"),
            _buildTextField(roomLocationController, "Room/Location"),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
              onPressed: () {
                // Submit as guest complaint
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Submitted ${generateComplaintID()}")),
                );
                setState(() {
                  complaintCounter++;
                });
              },
              child: const Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
