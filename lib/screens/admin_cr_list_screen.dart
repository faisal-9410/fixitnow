import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_screen.dart';

class AdminCRListScreen extends StatelessWidget {
  const AdminCRListScreen({super.key});

  // ✅ Corrected to fetch from 'user' collection and only CRs with approval
  Stream<QuerySnapshot> getCRsFromFirestore() {
    return FirebaseFirestore.instance
        .collection('user')
        .where('role', isEqualTo: 'cr')
        .where(
          'approved',
          whereIn: [true, 'true'],
        ) // Support both bool & string
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registered Class Representatives"),
        backgroundColor: Colors.pink[700],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.pink),
              child: Text(
                'Admin Menu',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Sign Out'),
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: getCRsFromFirestore(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No CRs found."));
          }

          final crList = snapshot.data!.docs;

          return ListView.builder(
            itemCount: crList.length,
            itemBuilder: (context, index) {
              final cr = crList[index].data() as Map<String, dynamic>;

              return Card(
                color: Colors.white10,
                margin: const EdgeInsets.all(12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  title: Text(
                    cr['name'] ?? 'N/A',
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "MIST Roll: ${cr['mist_roll'] ?? ''}",
                        style: TextStyle(color: Colors.grey[300]),
                      ),
                      Text(
                        "Level: ${cr['level'] ?? ''} | Section: ${cr['section'] ?? ''} | Dept: ${cr['department'] ?? ''}",
                        style: TextStyle(color: Colors.grey[300]),
                      ),
                      Text(
                        "Email: ${cr['email'] ?? ''}",
                        style: TextStyle(color: Colors.grey[300]),
                      ),
                      Text(
                        "Phone: ${cr['mobile'] ?? ''}",
                        style: TextStyle(color: Colors.grey[300]),
                      ),
                    ],
                  ),
                  leading: const CircleAvatar(
                    backgroundImage: AssetImage('assets/user.png'),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
