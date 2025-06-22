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
              title: Text(
                team['name'],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                "Total: ${team['total']} | Pending: ${team['pending']} | Completed: ${team['completed']}",
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // You can navigate to a detailed team screen in future
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Showing details for ${team['name']}")),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
