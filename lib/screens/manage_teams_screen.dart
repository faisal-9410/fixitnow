import 'package:flutter/material.dart';

class ManageTeamsScreen extends StatelessWidget {
  const ManageTeamsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> teams = [
      {
        "name": "Electric Team",
        "total": 5,
        "pending": 2,
        "completed": 3,
      },
      {
        "name": "Projector Team",
        "total": 3,
        "pending": 1,
        "completed": 2,
      },
      {
        "name": "Computer Team",
        "total": 4,
        "pending": 0,
        "completed": 4,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Teams"),
        backgroundColor: Colors.pink[700],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: teams.length,
        itemBuilder: (context, index) {
          final team = teams[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              title: Text(team['name']),
              subtitle: Text(
                "Total: ${team['total']}, Pending: ${team['pending']}, Completed: ${team['completed']}",
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TeamDetailsScreen(teamName: team['name']),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class TeamDetailsScreen extends StatelessWidget {
  final String teamName;

  const TeamDetailsScreen({super.key, required this.teamName});

  @override
  Widget build(BuildContext context) {
    final dummyComplaints = [
      "Complaint A resolved",
      "Complaint B pending",
      "Complaint C resolved"
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('$teamName - Complaints'),
        backgroundColor: Colors.pink[700],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: dummyComplaints.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              title: Text(dummyComplaints[index]),
            ),
          );
        },
      ),
    );
  }
}
