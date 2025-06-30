import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'team_complaint_details_screen.dart';

class TeamDashboardScreen extends StatelessWidget {
  final String teamName;

  const TeamDashboardScreen({super.key, required this.teamName});

  void signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    if (context.mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final complaintsStream = FirebaseFirestore.instance
        .collection('complaints')
        .where('assignedTeam', isEqualTo: teamName)
        .orderBy('timestamp', descending: true)
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        title: Text('$teamName Dashboard'),
        backgroundColor: Colors.pink[700],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => signOut(context),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: complaintsStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final complaints = snapshot.data!.docs;

          if (complaints.isEmpty) {
            return const Center(child: Text("No complaints assigned yet."));
          }

          return ListView.builder(
            itemCount: complaints.length,
            itemBuilder: (context, index) {
              final doc = complaints[index];
              final data = doc.data() as Map<String, dynamic>;
              final status = data['status'] ?? 'Unknown';
              final isPriority = data['priority'] == true;

              return Card(
                color: isPriority ? Colors.red[100] : Colors.white,
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  title: Text("Title: ${data['issue'] ?? 'N/A'}"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Location: ${data['location'] ?? 'N/A'}"),
                      Text("Status: $status"),
                      if (isPriority)
                        const Text(
                          "🔥 Priority",
                          style: TextStyle(color: Colors.red),
                        ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TeamComplaintDetailsScreen(
                          data: data,
                          docId: doc.id,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
