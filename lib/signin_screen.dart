import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'BottomNavBar.dart';
import 'email_signin_screen.dart';
import 'otp_screen.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _phoneController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isValid = false;

  static const Color primaryColor = Color(0xFF004D40);
  static const Color grayText = Color(0xFF4A4A4A);
  static const Color footerShade = Color(0xFFF3F3F3);

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(() {
      final phone = _phoneController.text.trim();
      setState(() {
        // Ensure phone has exactly 10 digits (all numeric).
        _isValid = RegExp(r"^[0-9]{10}$").hasMatch(phone);
      });
    });
  }

  /// Initiates phone number verification and navigates to PhoneVerifyScreen
  /// when the OTP is sent.
  void _verifyPhoneNumber(String phoneNumber) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber, // Expected format: +919876543210
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Optional: Automatically sign the user in on Android.
        await _auth.signInWithCredential(credential);
        // You can navigate to the home screen after auto verification.
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BottomNavBarDemo()),
        );
      },
      verificationFailed: (FirebaseAuthException e) {
        // Display or log the error as needed.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Verification failed: ${e.message}")),
        );
      },
      codeSent: (String verificationId, int? resendToken) {
        // Once the code is sent, navigate to the PhoneVerifyScreen and pass the verificationId.
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PhoneVerifyScreen(verificationID: verificationId),
            // You can also pass the phone number via arguments if needed.
            settings: RouteSettings(arguments: phoneNumber),
          ),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // You can handle timeout if needed.
      },
      timeout: const Duration(seconds: 60),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: const BackButton(color: Colors.black),
        title: const Text(
          'Get Started',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 40),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  'Please enter your mobile number to\nproceed further',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: grayText,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    border: Border.all(color: primaryColor, width: 1.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          '+91',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ),
                      const VerticalDivider(
                        width: 1,
                        thickness: 1,
                        color: primaryColor,
                      ),
                      Expanded(
                        child: TextField(
                          controller: _phoneController,
                          keyboardType: TextInputType.number,
                          maxLength: 10,
                          decoration: const InputDecoration(
                            counterText: '',
                            hintText: 'Enter Mobile Number',
                            hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 12),
                          ),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EmailSignInPage()),
                  );
                },
                child: const Text(
                  'Use Email',
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _isValid
                        ? () {
                      // Concatenate the country code and phone number
                      final phoneNumber = "+91" + _phoneController.text.trim();
                      _verifyPhoneNumber(phoneNumber);
                    }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isValid ? Colors.black : Colors.grey.shade300,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child: const Text(
                      'Submit',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 210),
              // Footer Section
              Container(
                width: double.infinity,
                color: footerShade,
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Row(
                      children: [
                        Icon(Icons.shield, size: 20, color: grayText),
                        SizedBox(width: 8),
                        Text(
                          'mygate',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: grayText,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '• ',
                          style: TextStyle(fontSize: 14, color: grayText),
                        ),
                        Expanded(
                          child: Text(
                            'Does not sell or trade your data',
                            style: TextStyle(fontSize: 14, color: grayText),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '• ',
                          style: TextStyle(fontSize: 14, color: grayText),
                        ),
                        Expanded(
                          child: Text(
                            'Is ISO 27001 certified for information security',
                            style: TextStyle(fontSize: 14, color: grayText),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '• ',
                          style: TextStyle(fontSize: 14, color: grayText),
                        ),
                        Expanded(
                          child: Text(
                            'Encrypts and secures your data',
                            style: TextStyle(fontSize: 14, color: grayText),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '• ',
                          style: TextStyle(fontSize: 14, color: grayText),
                        ),
                        Expanded(
                          child: Text(
                            'Is certified GDPR ready, the gold standard in data privacy',
                            style: TextStyle(fontSize: 14, color: grayText),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Privacy Policy',
                      style: TextStyle(
                        color: primaryColor,
                        decoration: TextDecoration.underline,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Terms & Conditions',
                      style: TextStyle(
                        color: primaryColor,
                        decoration: TextDecoration.underline,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 8),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}