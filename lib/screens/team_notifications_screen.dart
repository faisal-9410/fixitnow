import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TeamNotificationsScreen extends StatefulWidget {
  const TeamNotificationsScreen({super.key});

  @override
  State<TeamNotificationsScreen> createState() =>
      _TeamNotificationsScreenState();
}

class _TeamNotificationsScreenState extends State<TeamNotificationsScreen> {
  @override
  void initState() {
    super.initState();
    _markNotificationsAsSeen();
  }

  Future<void> _markNotificationsAsSeen() async {
    final snapshot = await FirebaseFirestore.instance
        .collectionGroup('team_notifications')
        .where('seen', isEqualTo: false)
        .get();

    for (var doc in snapshot.docs) {
      await doc.reference.update({'seen': true});
    }
  }

  @override
  Widget build(BuildContext context) {
    final notificationsStream = FirebaseFirestore.instance
        .collectionGroup('team_notifications')
        .orderBy('timestamp', descending: true)
        .limit(10)
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Team Notifications"),
        backgroundColor: Colors.pink[700],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: notificationsStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(child: Text("No notifications."));
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  title: Text("Complaint ID: ${data['complaintId']}"),
                  subtitle: Text("Assigned to: ${data['team']}"),
                  trailing: Text(
                    (data['timestamp'] as Timestamp)
                        .toDate()
                        .toString()
                        .split('.')
                        .first,
                    style: const TextStyle(fontSize: 12),
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
