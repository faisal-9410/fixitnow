import 'package:cloud_firestore/cloud_firestore.dart';
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

  @override
  Widget build(BuildContext context) {
    final complaintsStream = FirebaseFirestore.instance
        .collection('complaints')
        .where('assignedTeam', isEqualTo: widget.teamName)
        .snapshots();

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
      body: StreamBuilder<QuerySnapshot>(
        stream: complaintsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final teamComplaints = snapshot.data!.docs;
          final priorityComplaints = teamComplaints
              .where((doc) => doc['priority'] == true)
              .toList();

          return Column(
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
                        showAll = true;
                        showPriority = false;
                      }),
                    ),
                    _buildBox(
                      title: 'Priority Complaints',
                      count: priorityComplaints.length,
                      icon: Icons.warning_amber_rounded,
                      color: Colors.redAccent,
                      onTap: () => setState(() {
                        showPriority = true;
                        showAll = false;
                      }),
                    ),
                  ],
                ),
              ),
              if (showAll || showPriority)
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount:
                        (showPriority ? priorityComplaints : teamComplaints)
                            .length,
                    itemBuilder: (context, index) {
                      final doc = (showPriority
                          ? priorityComplaints
                          : teamComplaints)[index];
                      return Card(
                        color: Colors.white10,
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          title: Text(
                            doc['title'],
                            style: const TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            "Room: ${doc['room']} • ID: ${doc.id}",
                            style: const TextStyle(color: Colors.white70),
                          ),
                          trailing: doc['priority']
                              ? const Icon(
                                  Icons.priority_high,
                                  color: Colors.red,
                                )
                              : null,
                        ),
                      );
                    },
                  ),
                ),
            ],
          );
        },
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
              Text(
                title,
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
              const SizedBox(height: 6),
              Text(
                '$count',
                style: const TextStyle(fontSize: 14, color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
