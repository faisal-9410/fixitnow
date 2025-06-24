import 'package:flutter/material.dart';

class TeamDashboardScreen extends StatefulWidget {
  final String teamName;

  const TeamDashboardScreen({super.key, required this.teamName});

  @override
  State<TeamDashboardScreen> createState() => _TeamDashboardScreenState();
}

class _TeamDashboardScreenState extends State<TeamDashboardScreen> {
  bool showAll = false;
  bool showPriority = false;

  final List<Map<String, dynamic>> allComplaints = [
    {
      'id': 'C0001',
      'title': 'Projector not working',
      'room': '305',
      'priority': true,
      'assignedTeam': 'Projector'
    },
    {
      'id': 'C0002',
      'title': 'Fan making noise',
      'room': '204',
      'priority': false,
      'assignedTeam': 'Electric'
    },
    {
      'id': 'C0003',
      'title': 'Water leakage',
      'room': 'Lab 2',
      'priority': true,
      'assignedTeam': 'Water'
    },
    {
      'id': 'C0004',
      'title': 'Computer not booting',
      'room': '203',
      'priority': false,
      'assignedTeam': 'Computer'
    },
  ];

  @override
  Widget build(BuildContext context) {
    final teamComplaints = allComplaints
        .where((c) => c['assignedTeam'] == widget.teamName)
        .toList();

    final priorityComplaints =
    teamComplaints.where((c) => c['priority'] == true).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: Text("${widget.teamName} Team Dashboard"),
        backgroundColor: Colors.pinkAccent,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.pinkAccent),
              child: Center(
                child: Text(
                  '${widget.teamName} Team',
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Sign Out'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildBox(
                  title: 'All Complaints',
                  count: teamComplaints.length,
                  icon: Icons.list_alt,
                  color: const Color(0xFF6C63FF),
                  onTap: () => setState(() {
                    showAll = !showAll;
                    showPriority = false;
                  }),
                ),
                _buildBox(
                  title: 'Priority Complaints',
                  count: priorityComplaints.length,
                  icon: Icons.warning_amber_rounded,
                  color: Colors.redAccent,
                  onTap: () => setState(() {
                    showPriority = !showPriority;
                    showAll = false;
                  }),
                ),
              ],
            ),
          ),

          // Complaint List below
          if (showAll || showPriority)
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: (showPriority ? priorityComplaints : teamComplaints)
                    .length,
                itemBuilder: (context, index) {
                  final complaint = (showPriority
                      ? priorityComplaints
                      : teamComplaints)[index];

                  return Card(
                    color: Colors.white10,
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      title: Text(
                        complaint['title'],
                        style: const TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        "Room: ${complaint['room']} • ID: ${complaint['id']}",
                        style: const TextStyle(color: Colors.white70),
                      ),
                      trailing: complaint['priority']
                          ? const Icon(Icons.priority_high, color: Colors.red)
                          : null,
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBox({
    required String title,
    required int count,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black54,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 48, color: Colors.white),
              const SizedBox(height: 10),
              Text(title,
                  style: const TextStyle(fontSize: 16, color: Colors.white)),
              const SizedBox(height: 6),
              Text('$count',
                  style: const TextStyle(fontSize: 14, color: Colors.white70)),
            ],
          ),
        ),
      ),
    );
  }
}
