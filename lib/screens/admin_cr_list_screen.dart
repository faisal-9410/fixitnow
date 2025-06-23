import 'package:flutter/material.dart';
import 'login_screen.dart';

class AdminCRListScreen extends StatelessWidget {
  const AdminCRListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> crList = [
      {
        'name': 'Abdullah Faisal',
        'mistRoll': '202214003',
        'level': '4',
        'section': 'A',
        'department': 'CSE',
        'email': 'abdullahfaisal@gmail.com',
        'phone': '+8801769009410',
      },
      {
        'name': 'Mustari Labiba',
        'mistRoll': '202214103',
        'level': '4',
        'section': 'B',
        'department': 'CSE',
        'email': 'mustarilabiba@gmail.com',
        'phone': '+8801700112233',
      },
      // Add more CRs as needed
    ];

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
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: crList.length,
        itemBuilder: (context, index) {
          final cr = crList[index];
          return Card(
            color: Colors.white10,
            margin: const EdgeInsets.all(12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              title: Text(
                cr['name']!,
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "MIST Roll: ${cr['mistRoll']}",
                    style: TextStyle(color: Colors.grey[300]),
                  ),
                  Text(
                    "Level: ${cr['level']} | Section: ${cr['section']} | Dept: ${cr['department']}",
                    style: TextStyle(color: Colors.grey[300]),
                  ),
                  Text(
                    "Email: ${cr['email']}",
                    style: TextStyle(color: Colors.grey[300]),
                  ),
                  Text(
                    "Phone: ${cr['phone']}",
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
      ),
    );
  }
}
