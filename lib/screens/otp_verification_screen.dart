import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'guest_complaint_screen.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String verificationId;
  final String mobile;

  const OTPVerificationScreen({
    super.key,
    required this.verificationId,
    required this.mobile,
  });

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final TextEditingController otpController = TextEditingController();
  bool isVerifying = false;
  String error = '';

  Future<void> _verifyOTP() async {
    final smsCode = otpController.text.trim();

    if (smsCode.length != 6) {
      setState(() {
        error = 'Please enter a valid 6-digit OTP';
      });
      return;
    }

    setState(() {
      isVerifying = true;
      error = '';
    });

    final credential = PhoneAuthProvider.credential(
      verificationId: widget.verificationId,
      smsCode: smsCode,
    );

    try {
      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );

      final uid = userCredential.user?.uid;
      if (uid == null) {
        setState(() {
          isVerifying = false;
          error = 'Verification failed: No user UID found.';
        });
        return;
      }

      // ✅ Save guest verification info to Firestore
      await FirebaseFirestore.instance
          .collection('verified_guests')
          .doc(uid)
          .set({
            'mobile': widget.mobile,
            'verifiedAt': Timestamp.now(),
            'userType': 'guest',
          });

      if (!mounted) return;

      // ✅ Navigate to Guest Complaint Screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => GuestComplaintScreen(mobile: widget.mobile),
        ),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        isVerifying = false;
        error = 'OTP verification failed: ${e.message}';
      });
    } catch (e) {
      setState(() {
        isVerifying = false;
        error = 'Unexpected error occurred: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verify OTP"),
        backgroundColor: Colors.pink[700],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(), // dismiss keyboard
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text(
                "Enter the 6-digit OTP sent to your mobile",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: otpController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'OTP',
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
              isVerifying
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink,
                        minimumSize: const Size(double.infinity, 48),
                      ),
                      onPressed: _verifyOTP,
                      child: const Text("Verify & Proceed"),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
