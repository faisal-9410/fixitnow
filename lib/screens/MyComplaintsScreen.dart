import 'package:flutter/material.dart';

class MyComplaintsScreen extends StatelessWidget {
  const MyComplaintsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dummyComplaints = [
      {
        'title': 'Broken Chair',
        'location': 'Room 404',
        'status': 'Pending',
        'date': '2025-06-19',
      },
      {
        'title': 'Projector Not Working',
        'location': 'Room 401',
        'status': 'Resolved',
        'date': '2025-06-18',
      },
      {
        'title': 'Fan Noise',
        'location': 'Room 402',
        'status': 'In Progress',
        'date': '2025-06-17',
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('My Complaints'),
        backgroundColor: Colors.pink[700],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: dummyComplaints.length,
        itemBuilder: (context, index) {
          final complaint = dummyComplaints[index];
          return Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 3,
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              title: Text(
                complaint['title']!,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 6),
                  Text(
                    "Location: ${complaint['location']}",
                    style: TextStyle(color: Colors.grey[800], fontSize: 14),
                  ),
                  Text(
                    "Date: ${complaint['date']}",
                    style: TextStyle(color: Colors.grey[800], fontSize: 14),
                  ),
                ],
              ),
              trailing: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: complaint['status'] == 'Resolved'
                      ? Colors.green
                      : (complaint['status'] == 'Pending'
                            ? Colors.orange
                            : Colors.blue),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  complaint['status']!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
