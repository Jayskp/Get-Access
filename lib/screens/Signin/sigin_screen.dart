import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../auth_services.dart';
import '../Login/login_screen.dart';
import 'email_screen.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _phoneController = TextEditingController();
  bool _valid = false, _loading = false;

  TextStyle _archivo(double size, [FontWeight w = FontWeight.normal, Color c = Colors.black87]) {
    return GoogleFonts.archivo(fontSize: size, fontWeight: w, color: c);
  }

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(() {
      setState(() {
        _valid = RegExp(r"^[0-9]{10}$").hasMatch(_phoneController.text.trim());
      });
    });
  }

  Future<void> _register() async {
    if (!_valid) return;
    setState(() => _loading = true);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_phone', '+91${_phoneController.text.trim()}');
    await AuthService.register();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Create Account', style: _archivo(24, FontWeight.bold)),
                  const SizedBox(height: 16),
                  Text(
                    'Enter your phone number',
                    style: _archivo(16, FontWeight.w400, Colors.grey[700]!),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.number,
                    maxLength: 10,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[100],
                      hintText: 'Mobile number',
                      counterText: '',
                      hintStyle: _archivo(14, FontWeight.w400, Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      prefix: const Padding(
                        padding: EdgeInsets.only(left: 12),
                        child: Text('+91', style: TextStyle(fontSize: 16)),
                      ),
                    ),
                  ),
                  if (_loading) ...[
                    const SizedBox(height: 16),
                    const CircularProgressIndicator(),
                  ] else ...[
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _valid ? _register : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black87,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text('Continue', style: _archivo(16, FontWeight.w600, Colors.white)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const EmailSignInPage()),
                      ),
                      child: Text('Use Email Instead', style: _archivo(14, FontWeight.w500, Colors.blue[700]!)),
                    ),
                  ]
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
