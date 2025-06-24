import 'package:flutter/material.dart';

class FileComplaintScreen extends StatefulWidget {
  const FileComplaintScreen({super.key});

  @override
  State<FileComplaintScreen> createState() => _FileComplaintScreenState();
}

class _FileComplaintScreenState extends State<FileComplaintScreen> {
  int complaintCounter = 1;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController roomController = TextEditingController();
  final TextEditingController crRollController = TextEditingController();
  final TextEditingController designationController = TextEditingController();

  bool isPriority = false; // ✅ New field for emergency flag

  String generateComplaintID() {
    return "C${complaintCounter.toString().padLeft(4, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("File Complaint"),
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
            _buildTextField(titleController, "Complaint Title"),
            _buildTextField(roomController, "Room/Location"),
            _buildTextField(crRollController, "CR Roll Number"),
            _buildTextField(designationController, "Designation"),

            // ✅ Priority Toggle
            CheckboxListTile(
              title: const Text("Mark as Emergency (High Priority)"),
              value: isPriority,
              onChanged: (value) {
                setState(() {
                  isPriority = value!;
                });
              },
            ),

            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
              onPressed: () {
                // Normally: store this complaint into database or list
                String id = generateComplaintID();
                String title = titleController.text;
                String room = roomController.text;
                String roll = crRollController.text;
                String designation = designationController.text;

                // For now, just simulate storing
                print("Submitted complaint $id:");
                print("  Title: $title");
                print("  Room: $room");
                print("  CR Roll: $roll");
                print("  Designation: $designation");
                print("  Priority: $isPriority");

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Submitted $id (Priority: $isPriority)")),
                );

                setState(() {
                  complaintCounter++;
                  titleController.clear();
                  roomController.clear();
                  crRollController.clear();
                  designationController.clear();
                  isPriority = false;
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
