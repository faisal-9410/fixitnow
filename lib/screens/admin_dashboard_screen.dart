import 'package:flutter/material.dart';
import 'assign_complaint_screen.dart';
import 'manage_teams_screen.dart';
import 'admin_cr_list_screen.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
        backgroundColor: Colors.pink[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _AdminTile(
              label: 'Assign Complaints',
              icon: Icons.assignment,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AssignComplaintScreen(),
                ),
              ),
            ),
            _AdminTile(
              label: 'Manage Users/Teams',
              icon: Icons.group,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ManageTeamsScreen()),
              ),
            ),
            _AdminTile(
              label: 'CR List',
              icon: Icons.list,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AdminCRListScreen(),
                  ),
                );
              },
            ),

            _AdminTile(
              label: 'Logout',
              icon: Icons.logout,
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _AdminTile extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _AdminTile({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.deepPurple[800],
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.white),
            const SizedBox(height: 12),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
