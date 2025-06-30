import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TeamDetailsScreen extends StatelessWidget {
  final String teamName;

  const TeamDetailsScreen({super.key, required this.teamName});

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.redAccent;
      case 'in progress':
        return Colors.orangeAccent;
      case 'completed':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final complaintsStream = FirebaseFirestore.instance
        .collection('complaints')
        .where('assignedTeam', isEqualTo: teamName)
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        title: Text('$teamName Team Dashboard'),
        backgroundColor: Colors.pink[700],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: complaintsStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final complaints = snapshot.data!.docs;

          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🧾 Team Header Card
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  color: Colors.pink[100],
                  child: ListTile(
                    title: Text(
                      '$teamName Team',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('Total complaints: ${complaints.length}'),
                  ),
                ),

                const SizedBox(height: 12),

                // 🗂️ Complaint List View
                Expanded(
                  child: complaints.isEmpty
                      ? const Center(
                          child: Text('No complaints assigned to this team.'),
                        )
                      : ListView.builder(
                          itemCount: complaints.length,
                          itemBuilder: (context, index) {
                            final doc = complaints[index];
                            final status = doc['status'] ?? 'Unknown';
                            final complaintId = doc['id'] ?? 'Cxxxx';
                            final title = doc['title'] ?? 'No Title';

                            return Card(
                              margin: const EdgeInsets.only(bottom: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 3,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      complaintId,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      title,
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 5),
                                          decoration: BoxDecoration(
                                            color: _getStatusColor(status),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Text(
                                            status,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
