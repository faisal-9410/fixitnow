import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'team_dashboard_screen.dart';

class ManageTeamsScreen extends StatelessWidget {
  const ManageTeamsScreen({super.key});

  Future<Map<String, Map<String, int>>> _fetchTeamStats() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('complaints')
        .get();

    Map<String, Map<String, int>> stats = {};

    for (var doc in snapshot.docs) {
      String team = doc['assignedTeam'] ?? 'Unknown';
      String status = doc['status'] ?? 'pending';

      stats.putIfAbsent(team, () => {"total": 0, "pending": 0, "completed": 0});
      stats[team]!['total'] = stats[team]!['total']! + 1;

      if (status == 'pending') {
        stats[team]!['pending'] = stats[team]!['pending']! + 1;
      } else if (status == 'completed') {
        stats[team]!['completed'] = stats[team]!['completed']! + 1;
      }
    }

    return stats;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Teams"),
        backgroundColor: Colors.pink[700],
      ),
      body: FutureBuilder<Map<String, Map<String, int>>>(
        future: _fetchTeamStats(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No data available."));
          }

          final stats = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: stats.entries.map((entry) {
              final name = entry.key;
              final data = entry.value;
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  title: Text(name),
                  subtitle: Text(
                    "Total: ${data['total']}, Pending: ${data['pending']}, Completed: ${data['completed']}",
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TeamDashboardScreen(teamName: name),
                      ),
                    );
                  },
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
