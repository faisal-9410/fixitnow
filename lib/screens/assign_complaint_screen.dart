import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AssignComplaintScreen extends StatelessWidget {
  const AssignComplaintScreen({super.key});

  // Fetch both guest and CR complaints where assignedTeam is still empty
  Future<List<QueryDocumentSnapshot>> fetchAllUnassignedComplaints() async {
    final guestSnapshot = await FirebaseFirestore.instance
        .collection('complaints')
        .where('assignedTeam', isEqualTo: '')
        .get();

    final crSnapshot = await FirebaseFirestore.instance
        .collection('cr_complaints')
        .where('assignedTeam', isEqualTo: '')
        .get();

    return [...guestSnapshot.docs, ...crSnapshot.docs];
  }

  // Assign team to the complaint (can be from either collection)
  Future<void> assignTeam(DocumentReference docRef, String team) async {
    await docRef.update({'assignedTeam': team, 'status': 'Assigned'});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Assign Complaints"),
        backgroundColor: Colors.pink[700],
      ),
      body: FutureBuilder<List<QueryDocumentSnapshot>>(
        future: fetchAllUnassignedComplaints(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No new complaints."));
          }

          final complaints = snapshot.data!;

          return ListView.builder(
            itemCount: complaints.length,
            itemBuilder: (context, index) {
              final doc = complaints[index];
              final data = doc.data() as Map<String, dynamic>;
              final isGuest = data['userType'] == 'guest';

              final issueText = data['issue'] ?? data['title'] ?? 'No title';
              final location = data['location'] ?? data['room_location'] ?? 'Unknown';
              final reportedBy = data['userName'] ?? data['guestName'] ?? 'Unknown';

              return Card(
                color: isGuest ? Colors.red[100] : Colors.white,
                margin: const EdgeInsets.all(12),
                child: ListTile(
                  title: Text(
                    "Issue: $issueText",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Location: $location"),
                      Text("Reported by: $reportedBy"),
                      const SizedBox(height: 8),
                      const Text("Assign to team:"),
                      DropdownButton<String>(
                        isExpanded: true,
                        value: null,
                        hint: const Text("Select a team"),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            assignTeam(doc.reference, newValue);
                          }
                        },
                        items: const [
                          DropdownMenuItem(value: 'Electric', child: Text('Electric')),
                          DropdownMenuItem(value: 'Water', child: Text('Water')),
                          DropdownMenuItem(value: 'Furniture', child: Text('Furniture')),
                          DropdownMenuItem(value: 'Projector', child: Text('Projector')),
                          DropdownMenuItem(value: 'Computer', child: Text('Computer')),
                        ],
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
