import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'guest_complaint_screen.dart';

class GuestEmailLoginScreen extends StatefulWidget {
  @override
  _GuestEmailLoginScreenState createState() => _GuestEmailLoginScreenState();
}

class _GuestEmailLoginScreenState extends State<GuestEmailLoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _loading = false;

  Future<void> _loginGuest() async {
    setState(() => _loading = true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => GuestComplaintScreen()),
      );
    } on FirebaseAuthException catch (e) {
      String msg = "Login failed";
      if (e.code == 'user-not-found') {
        msg = "Account not found. Please register.";
      } else if (e.code == 'wrong-password') {
        msg = "Incorrect password.";
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    } finally {
      setState(() => _loading = false);
    }
  }

  void _registerRedirect() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Need an account?"),
        content: const Text(
          "Ask admin/CR to create guest credentials or use guest@mist.com for demo.",
        ),
        actions: [
          TextButton(
            child: const Text("OK"),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Guest Email Login"),
        backgroundColor: Colors.pink[400],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: "Email",
                labelStyle: TextStyle(color: Colors.white),
                filled: true,
                fillColor: Colors.white10,
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Password",
                labelStyle: TextStyle(color: Colors.white),
                filled: true,
                fillColor: Colors.white10,
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _loading ? null : _loginGuest,
              child: _loading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Login"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink[400],
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: _registerRedirect,
              child: const Text("Need an account?"),
            ),
          ],
        ),
      ),
    );
  }
}
