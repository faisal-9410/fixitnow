import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TeamAnnouncementScreen extends StatelessWidget {
  final String teamName;

  const TeamAnnouncementScreen({super.key, required this.teamName});

  @override
  Widget build(BuildContext context) {
    final announcementsStream = FirebaseFirestore.instance
        .collection('announcements')
        .where('target', whereIn: ['all', teamName])
        .orderBy('timestamp', descending: true)
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Announcements"),
        backgroundColor: Colors.pink[700],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: announcementsStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());

          final announcements = snapshot.data!.docs;

          if (announcements.isEmpty)
            return const Center(child: Text("No announcements found."));

          return ListView.builder(
            itemCount: announcements.length,
            itemBuilder: (context, index) {
              final data = announcements[index].data() as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: ListTile(
                  title: Text(data['message'] ?? 'No Message'),
                  subtitle: Text("Target: ${data['target']}"),
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
