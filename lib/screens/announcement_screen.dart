import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AnnouncementScreen extends StatelessWidget {
  const AnnouncementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final announcementStream = FirebaseFirestore.instance
        .collection('announcements')
        .where('target', whereIn: ['team', 'all'])
        .orderBy('timestamp', descending: true)
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Important Announcements"),
        backgroundColor: Colors.pink[700],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: announcementStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No announcements available."));
          }

          final announcements = snapshot.data!.docs;

          return ListView.builder(
            itemCount: announcements.length,
            itemBuilder: (context, index) {
              final doc = announcements[index];
              final data = doc.data() as Map<String, dynamic>;

              final message = data['message'] ?? 'No message';
              final target = data['target'] ?? 'all';
              final timestamp = data['timestamp'] as Timestamp;
              final expired = data['expired'] ?? false;

              return Card(
                margin: const EdgeInsets.all(12),
                child: ListTile(
                  title: Text(message),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Target: $target"),
                      Text("Posted: ${timestamp.toDate()}"),
                      if (expired is bool && expired)
                        const Text(
                          "❌ Expired",
                          style: TextStyle(color: Colors.red),
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
