import 'package:flutter/material.dart';

class AssignComplaintScreen extends StatelessWidget {
  const AssignComplaintScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> complaints = [
      {
        "id": "CR305",
        "title": "Projector not working",
        "location": "Room 305",
        "status": "Pending"
      },
      {
        "id": "CR202",
        "title": "Fan broken",
        "location": "Room 202",
        "status": "Pending"
      },
    ];

    final List<String> teams = [
      'Electric Team',
      'Water Team',
      'Building Team',
      'Furniture Team',
      'Projector Team',
      'Computer Team',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Assign Complaint"),
        backgroundColor: Colors.pink[700],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: complaints.length,
        itemBuilder: (context, index) {
          final complaint = complaints[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              title: Text("${complaint['title']} (${complaint['location']})"),
              subtitle: Text("ID: ${complaint['id']} - Status: ${complaint['status']}"),
              trailing: DropdownButton<String>(
                dropdownColor: Colors.white,
                iconEnabledColor: Colors.black,
                hint: const Text("Assign"),
                items: teams.map((String team) {
                  return DropdownMenuItem<String>(
                    value: team,
                    child: Text(
                      team,
                      style: const TextStyle(color: Colors.black),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Assigned to $value")),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
