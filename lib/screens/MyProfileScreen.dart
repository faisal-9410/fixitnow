import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String name = '';
  String email = '';
  String roll = '';
  String department = '';
  String level = '';
  String section = '';
  String mobile = '';
  String userType = '';

  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      final doc = await FirebaseFirestore.instance
          .collection('user')
          .doc(user.uid)
          .get();

      final data = doc.data();
      if (data != null) {
        setState(() {
          name = data['name'] ?? '';
          email = user.email ?? '';
          roll = data['roll'] ?? '';
          department = data['department'] ?? '';
          level = data['level'] ?? '';
          section = data['section'] ?? '';
          mobile = data['mobile'] ?? '';
          userType = data['userType'] ?? '';
          _loading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading profile: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: Colors.pink[700],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // 🔷 Gradient Header with Avatar and Name
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF43C6AC), Color(0xFF191654)],
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
                        backgroundImage: AssetImage('assets/user.png'),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        userType.toUpperCase(),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // 📋 Profile Details Cards
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    children: [
                      _buildInfoCard(Icons.perm_identity, "MIST Roll", roll),
                      _buildInfoCard(Icons.apartment, "Department", department),
                      _buildInfoCard(Icons.grade, "Level", level),
                      _buildInfoCard(Icons.group, "Section", section),
                      _buildInfoCard(Icons.phone, "Mobile", mobile),
                      _buildInfoCard(Icons.email, "Email", email),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildInfoCard(IconData icon, String title, String value) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.pink[700]),
        title: Text(title),
        subtitle: Text(value.isNotEmpty ? value : 'N/A'),
      ),
    );
  }
}
