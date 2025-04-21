import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'BottomNavBar.dart';

class PhoneVerifyScreen extends StatefulWidget {
  final String verificationID;

  const PhoneVerifyScreen({Key? key, required this.verificationID}) : super(key: key);

  @override
  _PhoneVerifyScreenState createState() => _PhoneVerifyScreenState();
}

class _PhoneVerifyScreenState extends State<PhoneVerifyScreen> {
  final TextEditingController _otpController = TextEditingController();
  late String _verificationId;
  bool _isLoading = false;
  String _errorMessage = '';
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _verificationId = widget.verificationID;
  }

  Future<void> _submitOTP() async {
    final smsCode = _otpController.text.trim();
    if (smsCode.length != 6) {
      setState(() {
        _errorMessage = 'Please enter a valid 6-digit OTP.';
      });
      return;
    }
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: smsCode,
      );
      await _auth.signInWithCredential(credential);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => BottomNavBarDemo()),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message ?? 'OTP verification failed.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Phone'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Text('Enter the OTP sent to your phone'),
            const SizedBox(height: 16),
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: const InputDecoration(
                hintText: 'Enter OTP',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            if (_errorMessage.isNotEmpty)
              Text(
                _errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _submitOTP,
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Verify'),
            ),
          ],
        ),
      ),
    );
  }
}
