import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_serviices.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({Key? key}) : super(key: key);

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    // Pre-fill admin credentials for testing
    _emailController.text = AuthService.adminEmail;
    _passwordController.text = AuthService.adminPassword;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _attemptLogin() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // Use the admin credentials directly from AuthService
      print(
        "Attempting admin login with: ${_emailController.text.trim()} / ${_passwordController.text}",
      );
      print(
        "Should match: ${AuthService.adminEmail} / ${AuthService.adminPassword}",
      );

      final isEmailMatch =
          _emailController.text.trim() == AuthService.adminEmail;
      final isPasswordMatch =
          _passwordController.text == AuthService.adminPassword;

      print("Email match: $isEmailMatch, Password match: $isPasswordMatch");

      if (isEmailMatch && isPasswordMatch) {
        // First try to authenticate with Firebase if possible
        try {
          final userCredential = await AuthService.signInWithEmail(
            _emailController.text.trim(),
            _passwordController.text,
            isAdmin: true,
          );

          print(
            "Admin login successful with Firebase Auth: ${userCredential.user?.uid}",
          );

          // If we have a user, update the database to mark as admin
          if (userCredential.user != null) {
            await FirebaseDatabase.instance
                .ref()
                .child('Users')
                .child(userCredential.user!.uid)
                .update({
                  'isAdmin': true,
                  'adminSince': ServerValue.timestamp,
                  'email': AuthService.adminEmail,
                });
          }
        } catch (e) {
          // If Firebase auth fails, still allow local admin access
          print(
            "Firebase Auth failed but continuing with local admin auth: $e",
          );
        }

        // Save admin status to shared preferences using multiple keys for redundancy
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('is_admin', true);
        await prefs.setBool('isAdmin', true);
        await prefs.setString('userEmail', AuthService.adminEmail);
        await prefs.setBool('_isLoggedIn', true);
        await prefs.setInt(
          'lastLoginTime',
          DateTime.now().millisecondsSinceEpoch,
        );

        // Call the AuthService login method to ensure consistent data
        await AuthService.login();

        print("Admin status saved to preferences successfully");

        if (!mounted) return;

        // Navigate to admin dashboard
        Navigator.pushReplacementNamed(context, '/admin');
        return;
      }

      setState(() {
        _errorMessage = 'Invalid admin credentials';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Login'),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 40),
            // Admin icon
            Icon(
              Icons.admin_panel_settings,
              size: 80,
              color: Colors.deepPurple,
            ),
            const SizedBox(height: 20),
            // Title
            const Text(
              'Admin Panel Access',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 8),
            // Subtitle
            const Text(
              'Enter your admin credentials to continue',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 40),
            // Email field
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Admin Email',
                hintText: 'Enter admin email',
                prefixIcon: const Icon(Icons.email, color: Colors.deepPurple),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Colors.deepPurple,
                    width: 2,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Password field
            TextField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: 'Enter admin password',
                prefixIcon: const Icon(Icons.lock, color: Colors.deepPurple),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility : Icons.visibility_off,
                    color: Colors.deepPurple,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Colors.deepPurple,
                    width: 2,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Error message
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),
            const SizedBox(height: 10),
            // Admin credentials hint
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                children: [
                  Text(
                    'Admin credentials:',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[800],
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Email: ${AuthService.adminEmail}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[800]),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Password: ${AuthService.adminPassword}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[800]),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Login button
            ElevatedButton(
              onPressed: _isLoading ? null : _attemptLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 3,
              ),
              child:
                  _isLoading
                      ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        ),
                      )
                      : const Text(
                        'Login as Admin',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
            ),
            const SizedBox(height: 20),
            // Back to normal login
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Return to Application',
                style: TextStyle(
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
