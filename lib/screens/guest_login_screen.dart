import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'otp_verification_screen.dart';

class GuestLoginScreen extends StatefulWidget {
  const GuestLoginScreen({super.key});

  @override
  State<GuestLoginScreen> createState() => _GuestLoginScreenState();
}

class _GuestLoginScreenState extends State<GuestLoginScreen> {
  final TextEditingController phoneController = TextEditingController();
  bool isLoading = false;
  String error = '';

  Future<void> _sendOTP() async {
    final String phone = phoneController.text.trim();

    if (phone.isEmpty || !RegExp(r'^\+8801\d{9}$').hasMatch(phone)) {
      setState(() {
        error = 'Please enter a valid Bangladeshi number like +8801XXXXXXXXX';
      });
      return;
    }

    setState(() {
      isLoading = true;
      error = '';
    });

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Optionally sign in the user automatically
        await FirebaseAuth.instance.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        setState(() {
          error = 'Verification failed: ${e.message}';
        });
      },
      codeSent: (String verificationId, int? resendToken) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => OTPVerificationScreen(
              mobile: phone,
              verificationId: verificationId,
            ),
          ),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Guest Login"),
        backgroundColor: Colors.pink[700],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text(
                "Enter your mobile number to proceed",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  labelText: 'Phone (e.g., +8801XXXXXXXXX)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              if (error.isNotEmpty)
                Text(
                  error,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: 20),
              isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pinkAccent,
                        minimumSize: const Size(double.infinity, 48),
                      ),
                      onPressed: _sendOTP,
                      child: const Text("Send OTP"),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
