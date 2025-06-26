import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GuestComplaintScreen extends StatefulWidget {
  const GuestComplaintScreen({super.key});

  @override
  State<GuestComplaintScreen> createState() => _GuestComplaintScreenState();
}

class _GuestComplaintScreenState extends State<GuestComplaintScreen> {
  int complaintCounter = 1;

  final TextEditingController guestNameController = TextEditingController();
  final TextEditingController guestPhoneController = TextEditingController();
  final TextEditingController crRollController = TextEditingController();
  final TextEditingController complaintTitleController =
      TextEditingController();
  final TextEditingController roomLocationController = TextEditingController();
  final TextEditingController complaintDetailsController =
      TextEditingController();

  String generateComplaintID() {
    return "C${complaintCounter.toString().padLeft(4, '0')}";
  }

  void submitComplaint() {
    String guestName = guestNameController.text.trim();
    String phone = guestPhoneController.text.trim();
    String crRoll = crRollController.text.trim();
    String title = complaintTitleController.text.trim();
    String room = roomLocationController.text.trim();

    if (guestName.isEmpty ||
        phone.isEmpty ||
        crRoll.isEmpty ||
        title.isEmpty ||
        room.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all required fields")),
      );
      return;
    }

    _showOtpDialog();
  }

  void _showOtpDialog() {
    final TextEditingController otpController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text("OTP Verification"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("An OTP has been sent to your provided mobile number."),
            const SizedBox(height: 10),
            TextField(
              controller: otpController,
              decoration: const InputDecoration(labelText: "Enter OTP"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // cancel
            },
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (otpController.text.trim() == "123456") {
                Navigator.pop(context); // Close dialog
                _storeComplaintInFirestore(); // Real Firebase submission
              } else {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text("Invalid OTP")));
              }
            },
            child: const Text("Verify"),
          ),
        ],
      ),
    );
  }

  Future<void> _storeComplaintInFirestore() async {
    String complaintID = generateComplaintID();

    try {
      await FirebaseFirestore.instance.collection('guest_complaints').add({
        'complaint_id': complaintID,
        'guest_name': guestNameController.text.trim(),
        'guest_phone': guestPhoneController.text.trim(),
        'cr_roll': crRollController.text.trim(),
        'title': complaintTitleController.text.trim(),
        'room_location': roomLocationController.text.trim(),
        'details': complaintDetailsController.text.trim(),
        'status': 'Pending',
        'submitted_at': FieldValue.serverTimestamp(),
      });

      _showFinalConfirmation();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to submit complaint")),
      );
    }
  }

  void _showFinalConfirmation() {
    String complaintID = generateComplaintID();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Complaint Submitted"),
        content: Text(
          "Complaint $complaintID submitted successfully.\n\n⚠️ You are accountable for the provided information. Misuse or false complaints will be tracked and reported.",
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // close dialog
              setState(() {
                complaintCounter++;
                guestNameController.clear();
                guestPhoneController.clear();
                crRollController.clear();
                complaintTitleController.clear();
                roomLocationController.clear();
                complaintDetailsController.clear();
              });
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
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
            _buildTextField(guestNameController, "Guest Name *"),
            _buildTextField(guestPhoneController, "Mobile Number *"),
            _buildTextField(crRollController, "Absent CR's Roll Number *"),
            _buildTextField(complaintTitleController, "Complaint Title *"),
            _buildTextField(roomLocationController, "Room / Location *"),
            _buildTextField(
              complaintDetailsController,
              "Details (optional)",
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
              onPressed: submitComplaint,
              child: const Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
