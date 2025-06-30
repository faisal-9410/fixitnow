import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GuestComplaintScreen extends StatefulWidget {
  final String mobile;

  const GuestComplaintScreen({super.key, required this.mobile});

  @override
  State<GuestComplaintScreen> createState() => _GuestComplaintScreenState();
}

class _GuestComplaintScreenState extends State<GuestComplaintScreen> {
  final TextEditingController guestNameController = TextEditingController();
  final TextEditingController crRollController = TextEditingController();
  final TextEditingController issueController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  bool isSubmitting = false;
  String errorMessage = '';

  Future<void> _submitComplaint() async {
    final guestName = guestNameController.text.trim();
    final crRoll = crRollController.text.trim();
    final issue = issueController.text.trim();
    final location = locationController.text.trim();

    if (guestName.isEmpty ||
        crRoll.isEmpty ||
        issue.isEmpty ||
        location.isEmpty) {
      setState(() {
        errorMessage = 'Please fill in all fields.';
      });
      return;
    }

    setState(() {
      isSubmitting = true;
      errorMessage = '';
    });

    try {
      final complaintData = {
        'guestName': guestName,
        'crRoll': crRoll,
        'issue': issue,
        'location': location,
        'guestPhone': widget.mobile,
        'timestamp': FieldValue.serverTimestamp(),
        'status': 'Pending',
        'assignedTeam': '',
        'priority': false,
        'userType': 'guest',
      };

      await FirebaseFirestore.instance
          .collection('complaints')
          .add(complaintData);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Complaint submitted successfully')),
      );

      guestNameController.clear();
      crRollController.clear();
      issueController.clear();
      locationController.clear();
    } catch (e) {
      setState(() {
        errorMessage = 'Error submitting complaint: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          isSubmitting = false;
        });
      }
    }
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
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
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(), // Dismiss keyboard
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _buildTextField(guestNameController, 'Your Name'),
              const SizedBox(height: 16),
              _buildTextField(crRollController, 'CR Roll Number'),
              const SizedBox(height: 16),
              _buildTextField(
                issueController,
                'Issue Description',
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              _buildTextField(locationController, 'Location (Room/Area)'),
              const SizedBox(height: 20),
              if (errorMessage.isNotEmpty)
                Text(errorMessage, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 10),
              isSubmitting
                  ? const CircularProgressIndicator()
                  : ElevatedButton.icon(
                      onPressed: _submitComplaint,
                      icon: const Icon(Icons.send),
                      label: const Text("Submit Complaint"),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                        backgroundColor: Colors.pink,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
