import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FileComplaintScreen extends StatefulWidget {
  const FileComplaintScreen({super.key});

  @override
  State<FileComplaintScreen> createState() => _FileComplaintScreenState();
}

class _FileComplaintScreenState extends State<FileComplaintScreen> {
  final TextEditingController locationController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String? selectedProblemType;
  bool isPriority = false;
  bool _isLoading = false;
  String _error = '';

  final List<String> problemTypes = [
    'Light',
    'Fan',
    'Computer',
    'Projector',
    'AC',
    'Others',
  ];

  Future<String> _generateComplaintId() async {
    final counterRef = FirebaseFirestore.instance
        .collection('meta')
        .doc('complaint_counter');

    return FirebaseFirestore.instance.runTransaction((transaction) async {
      final snapshot = await transaction.get(counterRef);
      int currentId = 0;
      if (snapshot.exists) {
        currentId = snapshot.data()?['lastId'] ?? 0;
      }
      final newId = currentId + 1;
      transaction.update(counterRef, {'lastId': newId});
      return 'C${newId.toString().padLeft(4, '0')}';
    });
  }

  Future<void> _submitComplaint() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw 'User not logged in.';

      final userDoc = await FirebaseFirestore.instance
          .collection('user')
          .doc(user.uid)
          .get();

      if (!userDoc.exists) throw 'User record not found.';

      final complaintId = await _generateComplaintId();
      final userData = userDoc.data()!;
      final userType = userData['userType'] ?? 'cr';

      final complaintData = {
        'complaint_id': complaintId,
        'room_location': locationController.text.trim(),
        'problem_type': selectedProblemType,
        'description': descriptionController.text.trim(),
        'status': 'Pending',
        'assignedTeam': '',
        'priority': isPriority,
        'submitted_at': FieldValue.serverTimestamp(),
        'userId': user.uid,
        'userType': userType,
        'cr_roll': userData['mist_roll'] ?? '',
        'designation': userType == 'guest' ? 'Guest' : 'CR',
      };

      await FirebaseFirestore.instance
          .collection('cr_complaints')
          .add(complaintData);

      locationController.clear();
      descriptionController.clear();
      setState(() {
        selectedProblemType = null;
        isPriority = false;
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Complaint submitted successfully')),
      );
    } catch (e) {
      setState(() => _error = '❌ Submission failed: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // 🔁 Replace with CustomAppBar('File Complaint') later
        title: const Text('File Complaint'),
        backgroundColor: Colors.pink[700],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: locationController,
              decoration: const InputDecoration(
                labelText: 'Location',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Problem Type',
                border: OutlineInputBorder(),
              ),
              value: selectedProblemType,
              items: problemTypes
                  .map(
                    (type) => DropdownMenuItem(value: type, child: Text(type)),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() => selectedProblemType = value);
              },
            ),
            const SizedBox(height: 16),
            CheckboxListTile(
              title: const Text('Mark as Priority'),
              value: isPriority,
              onChanged: (value) {
                setState(() => isPriority = value ?? false);
              },
            ),
            const SizedBox(height: 8),
            TextField(
              controller: descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 16),
            if (_error.isNotEmpty)
              Text(_error, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 8),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton.icon(
                    icon: const Icon(Icons.send),
                    label: const Text('Submit'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink[700],
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    onPressed: _submitComplaint,
                  ),
          ],
        ),
      ),
    );
  }
}
