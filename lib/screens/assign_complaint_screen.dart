import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AssignComplaintScreen extends StatefulWidget {
  const AssignComplaintScreen({super.key});

  @override
  State<AssignComplaintScreen> createState() => _AssignComplaintScreenState();
}

class _AssignComplaintScreenState extends State<AssignComplaintScreen> {
  final List<String> teams = [
    'Electric Team',
    'Water Team',
    'Building Team',
    'Furniture Team',
    'Projector Team',
    'Computer Team',
  ];

  Future<void> assignTeam(String docId, String team, bool isPriority) async {
    try {
      await FirebaseFirestore.instance
          .collection('guest_complaints')
          .doc(docId)
          .update({
            'assigned_team': team,
            'priority': isPriority,
            'status': 'Assigned',
            'timestamp_assigned': FieldValue.serverTimestamp(),
          });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Assigned to $team ${isPriority ? "(PRIORITY)" : ""}'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to assign complaint')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Assign Complaints"),
        backgroundColor: Colors.pink[700],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('guest_complaints')
            .where('status', isEqualTo: 'Pending')
            .orderBy('submitted_at', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());

          final complaints = snapshot.data!.docs;

          if (complaints.isEmpty) {
            return const Center(child: Text('No pending complaints.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: complaints.length,
            itemBuilder: (context, index) {
              final doc = complaints[index];
              final data = doc.data() as Map<String, dynamic>;

              bool isPriority = data['priority'] ?? false;

              return Card(
                color: data['user_type'] == 'guest'
                    ? Colors.orange[100]
                    : Colors.white,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  title: Text("${data['title']} (${data['room_location']})"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("ID: ${data['complaint_id']}"),
                      Text("Status: ${data['status']}"),
                      Row(
                        children: [
                          const Text("Mark as Priority"),
                          StatefulBuilder(
                            builder: (context, setCheckboxState) => Checkbox(
                              value: isPriority,
                              onChanged: (value) {
                                setCheckboxState(() => isPriority = value!);
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  trailing: DropdownButton<String>(
                    hint: const Text("Assign"),
                    value: null,
                    onChanged: (team) {
                      if (team != null) assignTeam(doc.id, team, isPriority);
                    },
                    items: teams.map((team) {
                      return DropdownMenuItem(
                        value: team,
                        child: Text(
                          team,
                          style: const TextStyle(color: Colors.black),
                        ),
                      );
                    }).toList(),
                    dropdownColor: Colors.white,
                    iconEnabledColor: Colors.black,
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
