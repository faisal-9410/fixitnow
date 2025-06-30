import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyComplaintsScreen extends StatelessWidget {
  const MyComplaintsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(body: Center(child: Text('User not logged in.')));
    }

    debugPrint("Logged-in UID: ${user.uid}");

    final complaintsStream = FirebaseFirestore.instance
        .collection('cr_complaints')
        .where('userId', isEqualTo: user.uid)
        .orderBy('submitted_at', descending: true)
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Complaints"),
        backgroundColor: Colors.pink[700],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: complaintsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No complaints found."));
          }

          final complaints = snapshot.data!.docs;

          return ListView.builder(
            itemCount: complaints.length,
            itemBuilder: (context, index) {
              final doc = complaints[index];
              final data = doc.data() as Map<String, dynamic>;

              final complaintId = data['complaint_id'] ?? 'Unknown';
              final location = data['room_location'] ?? 'No location';
              final type = data['problem_type'] ?? 'No type';
              final status = data['status'] ?? 'Pending';
              final priority = data['priority'] == true;
              final submittedAt = (data['submitted_at'] as Timestamp?)
                  ?.toDate();
              final completedAt = (data['completed_at'] as Timestamp?)
                  ?.toDate();

              return Card(
                margin: const EdgeInsets.all(12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: Colors.white,
                child: ListTile(
                  leading: const Icon(Icons.report_problem_outlined),
                  title: Text(
                    "$complaintId - $type",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Location: $location"),
                      Text("Status: $status"),
                      if (priority)
                        const Text(
                          "⚠️ Priority Complaint",
                          style: TextStyle(color: Colors.red),
                        ),
                      if (completedAt != null)
                        Text(
                          "✅ Completed on: ${completedAt.toString().split('.').first}",
                        ),
                      if (submittedAt != null)
                        Text(
                          "🕒 Submitted on: ${submittedAt.toString().split('.').first}",
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
