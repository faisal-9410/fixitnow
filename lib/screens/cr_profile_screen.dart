import 'package:flutter/material.dart';

class CRProfileScreen extends StatelessWidget {
  final Map<String, dynamic> crData;

  const CRProfileScreen({super.key, required this.crData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
        backgroundColor: Colors.pink[700],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // 🔷 Gradient Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 40),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF43C6AC), Color(0xFF191654)], // Blue-Green
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage(
                    'assets/user.png',
                  ), // change if dynamic
                ),
                const SizedBox(height: 12),
                Text(
                  crData['name'] ?? 'N/A',
                  style: const TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Class Representative",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 📄 Profile Details
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                _buildInfoCard(
                  Icons.perm_identity,
                  "MIST Roll",
                  crData['mist_roll'],
                ),
                _buildInfoCard(
                  Icons.apartment,
                  "Department",
                  crData['department'],
                ),
                _buildInfoCard(Icons.grade, "Level", crData['level']),
                _buildInfoCard(Icons.group, "Section", crData['section']),
                _buildInfoCard(Icons.phone, "Mobile", crData['mobile']),
                _buildInfoCard(Icons.email, "Email", crData['email']),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(IconData icon, String title, String? value) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.pink[700]),
        title: Text(title),
        subtitle: Text(value ?? 'N/A'),
      ),
    );
  }
}
