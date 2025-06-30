import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateAnnouncementScreen extends StatefulWidget {
  const CreateAnnouncementScreen({super.key});

  @override
  State<CreateAnnouncementScreen> createState() =>
      _CreateAnnouncementScreenState();
}

class _CreateAnnouncementScreenState extends State<CreateAnnouncementScreen> {
  final TextEditingController _messageController = TextEditingController();
  String? _selectedTarget;
  bool _expired = false;

  final List<String> _targets = ['all', 'admin', 'cr', 'team'];

  void _submit() async {
    final message = _messageController.text.trim();
    if (message.isEmpty || _selectedTarget == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    await FirebaseFirestore.instance.collection('announcements').add({
      'message': message,
      'target': _selectedTarget,
      'expired': _expired,
      'timestamp': FieldValue.serverTimestamp(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Announcement created')),
    );

    _messageController.clear();
    setState(() {
      _selectedTarget = null;
      _expired = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Announcement"),
        backgroundColor: Colors.pink[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                labelText: 'Announcement Message',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Target Audience',
                border: OutlineInputBorder(),
              ),
              value: _selectedTarget,
              onChanged: (value) {
                setState(() {
                  _selectedTarget = value;
                });
              },
              items: _targets
                  .map((target) => DropdownMenuItem(
                        value: target,
                        child: Text(target.toUpperCase()),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Checkbox(
                  value: _expired,
                  onChanged: (val) {
                    setState(() {
                      _expired = val!;
                    });
                  },
                ),
                const Text("Mark as expired"),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _submit,
              icon: const Icon(Icons.check),
              label: const Text("Post Announcement"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink[700],
                foregroundColor: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}
