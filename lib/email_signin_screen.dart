import 'dart:math';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:getaccess/BottomNavBar.dart';

import '../../auth_serviices.dart';

class EmailSignInPage extends StatefulWidget {
  const EmailSignInPage({Key? key}) : super(key: key);

  @override
  _EmailSignInPageState createState() => _EmailSignInPageState();
}

class _EmailSignInPageState extends State<EmailSignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isValid = false;
  bool _showError = false;
  bool _isLoading = false;
  String _errorMessage = '';
  static const Color primaryColor = Color(0xFF004D40);
  static const Color grayText = Color(0xFF4A4A4A);
  static const Color footerShade = Color(0xFFF3F3F3);

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateInput);
    _passwordController.addListener(_validateInput);
  }

  void _validateInput() {
    setState(() {
      _showError = false;
      final bool emailValid = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$")
          .hasMatch(_emailController.text.trim());
      final bool passwordValid = _passwordController.text.length >= 6;
      _isValid = emailValid && passwordValid;
    });
  }

  void _submit() async {
    if (_isValid) {
      setState(() {
        _isLoading = true;
        _showError = false;
      });

      try {
        await AuthService.signInWithEmail(
          _emailController.text.trim(),
          _passwordController.text,
        );

        Navigator.push(context,MaterialPageRoute(builder: (context)=>BottomNavBarDemo()));
      } on FirebaseAuthException catch (e) {
        setState(() {
          _showError = true;
          _errorMessage = _getErrorMessage(e.code);
        });
      } catch (e) {
        setState(() {
          _showError = true;
          _errorMessage = e.toString();
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        _showError = true;
        _errorMessage = e.toString();
      });
    }
  }

  String _getErrorMessage(String code) {
    switch (code) {
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'user-not-found':
        return 'No account found with this email.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'email-already-in-use':
        return 'This email is already in use by another account.';
      case 'weak-password':
        return 'Password is too weak. Please use at least 6 characters.';
      default:
        return 'Authentication failed. Please try again.';
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const borderColor = Color(0xFF004D40);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Sign in with Email',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w500,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 40),
            Text(
              'Please enter your email to\nproceed further',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: grayText,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 32),
            // Email TextField
            Container(
              height: 56,
              decoration: BoxDecoration(
                border: Border.all(color: borderColor, width: 1.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 16,
                ),
                decoration: const InputDecoration(
                  hintText: 'Enter your Email',
                  hintStyle: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              height: 56,
              decoration: BoxDecoration(
                border: Border.all(color: borderColor, width: 1.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: _passwordController,
                obscureText: true,
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 16,
                ),
                decoration: const InputDecoration(
                  hintText: 'Enter your Password',
                  hintStyle: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
            ),
            if (_showError)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  _errorMessage,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
            const SizedBox(height: 24),
            // Submit Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : (_isValid ? _submit : null),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    _isValid ? Colors.black : Colors.grey.shade300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
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
            const Spacer(),
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Use Phone instead',
                  style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}