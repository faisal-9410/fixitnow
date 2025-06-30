import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TeamComplaintDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> data;
  final String docId;

  const TeamComplaintDetailsScreen({
    super.key,
    required this.data,
    required this.docId,
  });

  void markAsCompleted(BuildContext context) async {
    await FirebaseFirestore.instance.collection('complaints').doc(docId).update(
      {'status': 'Completed'},
    );
    if (context.mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final status = data['status'] ?? 'Unknown';
    final isCompleted = status.toLowerCase() == 'completed';

    return Scaffold(
      appBar: AppBar(
        title: const Text("Complaint Details"),
        backgroundColor: Colors.pink[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            buildRow("Complaint ID", data['id']),
            buildRow("Issue", data['issue']),
            buildRow("Location", data['location']),
            buildRow("Description", data['description']),
            buildRow("Status", status),
            buildRow("Priority", data['priority'] == true ? 'Yes' : 'No'),
            const SizedBox(height: 20),
            if (!isCompleted)
              ElevatedButton.icon(
                icon: const Icon(Icons.check),
                label: const Text("Mark as Completed"),
                onPressed: () => markAsCompleted(context),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
              )
            else
              const Center(
                child: Icon(Icons.check_circle, size: 48, color: Colors.green),
              ),
          ],
        ),
      ),
    );
  }

  Widget buildRow(String title, dynamic value) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(title),
        subtitle: Text(value?.toString() ?? 'N/A'),
      ),
    );
  }
}
