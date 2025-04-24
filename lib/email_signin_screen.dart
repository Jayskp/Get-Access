import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:getaccess/BottomNavBar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth_serviices.dart';

class EmailSignInPage extends StatefulWidget {
  const EmailSignInPage({Key? key}) : super(key: key);

  @override
  _EmailSignInPageState createState() => _EmailSignInPageState();
}

class _EmailSignInPageState extends State<EmailSignInPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isValid = false;
  bool _showError = false;
  bool _isLoading = false;
  String _errorMessage = '';
  bool _isSignUp = false; // Determines if we're signing up or signing in
  bool _isAdminLogin = false;

  // Theme colors - matching with SignUpPage
  static const Color primaryColor = Color(0xFF004D40);
  // static const Color secondaryColor = Color(0xFF00796B);
  // static const Color accentColor = Color(0xFF26A69A);
  static const Color grayText = Color(0xFF4A4A4A);
  static const Color footerShade = Color(0xFFF3F3F3);

  // Animation controllers
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateInput);
    _passwordController.addListener(_validateInput);

    // Setup animations
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    // Start the animations
    _animationController.forward();

    // Check for existing user to determine if signing up or signing in
    _checkExistingUser();
  }

  Future<void> _checkExistingUser() async {
    setState(() => _isLoading = true);
    try {
      final userInfo = await AuthService.getCurrentUser();
      if (userInfo['email'] != null) {
        setState(() => _isSignUp = false);
      } else {
        setState(() => _isSignUp = true);
      }
    } catch (e) {
      setState(() => _isSignUp = true);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _validateInput() {
    setState(() {
      _showError = false;
      final bool emailValid = RegExp(
        r"^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$",
      ).hasMatch(_emailController.text.trim());
      final bool passwordValid = _passwordController.text.length >= 6;
      _isValid = emailValid && passwordValid;
    });
  }

  Future<void> _submit() async {
    if (_isValid) {
      setState(() {
        _isLoading = true;
        _showError = false;
      });

      try {
        // Use the AuthService
        UserCredential userCredential;

        if (_isAdminLogin) {
          if (_isSignUp) {
            // Register as admin (requires special handling)
            userCredential = await AuthService.signUpAsAdmin(
              _emailController.text.trim(),
              _passwordController.text,
            );
          } else {
            // Sign in as admin
            userCredential = await AuthService.signInAsAdmin(
              _emailController.text.trim(),
              _passwordController.text,
            );
          }
        } else {
          // Regular sign in or sign up
          userCredential = await AuthService.signInWithEmail(
            _emailController.text.trim(),
            _passwordController.text,
            isSignUp: _isSignUp,
            isAdmin: false, // Not admin
          );
        }

        if (userCredential.user != null) {
          // Navigate to main app after successful authentication
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder:
                  (context, animation, secondaryAnimation) =>
                      BottomNavBarDemo(isAdmin: _isAdminLogin),
              transitionsBuilder: (
                context,
                animation,
                secondaryAnimation,
                child,
              ) {
                var curve = Curves.easeInOut;
                var tween = Tween(
                  begin: 0.0,
                  end: 1.0,
                ).chain(CurveTween(curve: curve));
                return FadeTransition(
                  opacity: animation.drive(tween),
                  child: child,
                );
              },
              transitionDuration: const Duration(milliseconds: 600),
            ),
          );
        }
      } on FirebaseAuthException catch (e) {
        setState(() {
          _showError = true;
          _errorMessage = _getErrorMessage(e.code);
        });

        print("Firebase Auth Error: ${e.code} - ${e.message}");
      } catch (e) {
        setState(() {
          _showError = true;
          _errorMessage = "An unexpected error occurred. Please try again.";
        });

        print("General Error: $e");
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        _showError = true;
        _errorMessage = 'Please enter valid email and password';
      });
    }
  }

  String _getErrorMessage(String code) {
    switch (code) {
      // Add admin-specific errors
      case 'not-admin':
        return 'This account is not registered as an admin.';
      case 'admin-not-approved':
        return 'Your admin account is pending approval.';
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
      case 'network-request-failed':
        return 'Network error. Please check your internet connection.';
      case 'too-many-requests':
        return 'Too many unsuccessful login attempts. Please try again later.';
      default:
        return 'Authentication failed. Please try again.';
    }
  }

  TextStyle _archivoTextStyle({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.normal,
    Color color = Colors.black,
  }) {
    return GoogleFonts.archivo(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: 0.2,
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          _isSignUp ? 'Sign up with Email' : 'Sign in with Email',
          style: _archivoTextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
      ),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          children: [
                            const SizedBox(height: 30),

                            // Email illustration (Flutter built-in)
                            _buildEmailAnimation(),

                            const SizedBox(height: 30),
                            Text(
                              'Please enter your email and password\nto proceed further',
                              textAlign: TextAlign.center,
                              style: _archivoTextStyle(
                                fontSize: 16,
                                color: grayText,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 32),

                            // Email TextField
                            _buildAnimatedTextField(
                              controller: _emailController,
                              hintText: 'Enter your Email',
                              isPassword: false,
                              keyboardType: TextInputType.emailAddress,
                              prefixIcon: Icons.email_outlined,
                            ),

                            const SizedBox(height: 16),

                            // Password TextField
                            _buildAnimatedTextField(
                              controller: _passwordController,
                              hintText: 'Enter your Password',
                              isPassword: true,
                              keyboardType: TextInputType.visiblePassword,
                              prefixIcon: Icons.lock_outline,
                            ),

                            if (_isSignUp) ...[
                              // Only show admin checkbox when signing up
                              CheckboxListTile(
                                title: Text(
                                  _isSignUp
                                      ? 'Sign up as admin'
                                      : 'Sign in as admin',
                                  style: _archivoTextStyle(
                                    fontSize: 14,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                value: _isAdminLogin,
                                onChanged: (bool? value) {
                                  setState(() {
                                    _isAdminLogin = value ?? false;
                                  });
                                },
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                activeColor: Colors.red.shade600,
                                checkColor: Colors.white,
                                contentPadding: EdgeInsets.zero,
                                secondary:
                                    _isAdminLogin
                                        ? Icon(
                                          Icons.admin_panel_settings,
                                          color: Colors.red.shade600,
                                        )
                                        : null,
                              ),

                              if (_isAdminLogin)
                                Container(
                                  margin: const EdgeInsets.only(
                                    top: 8.0,
                                    bottom: 12.0,
                                  ),
                                  padding: const EdgeInsets.all(12.0),
                                  decoration: BoxDecoration(
                                    color: Colors.red.shade50,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: Colors.red.shade200,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.info_outline,
                                            color: Colors.red.shade700,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Text(
                                              'Admin Login',
                                              style: _archivoTextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.red.shade800,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Predefined admin credentials:',
                                        style: _archivoTextStyle(
                                          fontSize: 13,
                                          color: Colors.red.shade800,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Email: admin@getaccess.com',
                                        style: _archivoTextStyle(
                                          fontSize: 12,
                                          color: Colors.red.shade700,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Password: admin@123',
                                        style: _archivoTextStyle(
                                          fontSize: 12,
                                          color: Colors.red.shade700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],

                            if (_showError)
                              Padding(
                                padding: const EdgeInsets.only(top: 12.0),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.red.shade50,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: Colors.red.shade200,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.error_outline,
                                        color: Colors.red.shade700,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          _errorMessage,
                                          style: _archivoTextStyle(
                                            color: Colors.red.shade700,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                            const SizedBox(height: 24),

                            // Submit Button
                            _buildSubmitButton(),

                            // Toggle between sign in and sign up
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _isSignUp = !_isSignUp;
                                  _showError = false;
                                });
                              },
                              child: Text(
                                _isSignUp
                                    ? 'Already have an account? Sign in'
                                    : 'Need an account? Sign up',
                                style: _archivoTextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),

                            const SizedBox(height: 24),

                            // Use Phone Instead
                            Center(
                              child: TextButton.icon(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(
                                  Icons.phone_android,
                                  size: 18,
                                  color: primaryColor,
                                ),
                                label: Text(
                                  'Use Phone Instead',
                                  style: _archivoTextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: primaryColor,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 40),

                            // Footer
                            _buildFooter(),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Overlay loading indicator
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SpinKitDoubleBounce(color: primaryColor, size: 60.0),
                      const SizedBox(height: 20),
                      Text(
                        _isSignUp ? 'Creating account...' : 'Signing in...',
                        style: _archivoTextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Custom email animation
  Widget _buildEmailAnimation() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 1200),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Center(
          child: Transform.scale(
            scale: value,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(Icons.email, size: 64, color: primaryColor),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedTextField({
    required TextEditingController controller,
    required String hintText,
    required bool isPassword,
    required TextInputType keyboardType,
    required IconData prefixIcon,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.9, end: 1.0),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              border: Border.all(
                color:
                    controller.text.isNotEmpty
                        ? primaryColor
                        : Colors.grey.shade400,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color:
                      controller.text.isNotEmpty
                          ? primaryColor.withOpacity(0.1)
                          : Colors.transparent,
                  blurRadius: 8,
                  spreadRadius: 0,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.05),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10.5),
                      bottomLeft: Radius.circular(10.5),
                    ),
                  ),
                  child: Center(
                    child: Icon(prefixIcon, size: 22, color: primaryColor),
                  ),
                ),
                const VerticalDivider(
                  color: primaryColor,
                  thickness: 1,
                  width: 1,
                ),
                Expanded(
                  child: TextField(
                    controller: controller,
                    keyboardType: keyboardType,
                    obscureText: isPassword,
                    decoration: InputDecoration(
                      hintText: hintText,
                      hintStyle: _archivoTextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade400,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      suffixIcon:
                          controller.text.isNotEmpty && !_showError
                              ? AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                                child: Icon(
                                  Icons.check_circle,
                                  color: Colors.green.shade600,
                                ),
                              )
                              : null,
                    ),
                    style: _archivoTextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow:
            _isValid
                ? [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
                : null,
      ),
      child: ElevatedButton(
        onPressed: _isValid && !_isLoading ? _submit : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: _isValid ? Colors.black : Colors.grey.shade300,
          disabledBackgroundColor: Colors.grey.shade200,
          elevation: _isValid ? 0 : 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child:
            _isLoading
                ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                  ),
                )
                : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _isSignUp ? 'Sign Up' : 'Sign In',
                      style: _archivoTextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(_isSignUp ? Icons.person_add : Icons.login, size: 18),
                  ],
                ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      width: double.infinity,
      color: footerShade,
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFooterItem('Does not sell or trade your data'),
          const SizedBox(height: 8),
          _buildFooterItem('Is ISO 27001 certified for information security'),
          const SizedBox(height: 8),
          _buildFooterItem('Encrypts and secures your data'),
          const SizedBox(height: 8),
          _buildFooterItem(
            'Is certified GDPR ready, the gold standard in data privacy',
          ),

          const SizedBox(height: 16),
          const Divider(color: Colors.grey, height: 1),
          const SizedBox(height: 16),

          InkWell(
            onTap: () {},
            child: Text(
              'Privacy Policy',
              style: _archivoTextStyle(
                fontSize: 14,
                color: primaryColor,
              ).copyWith(decoration: TextDecoration.underline),
            ),
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: () {},
            child: Text(
              'Terms & Conditions',
              style: _archivoTextStyle(
                fontSize: 14,
                color: primaryColor,
              ).copyWith(decoration: TextDecoration.underline),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildFooterItem(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 4),
          width: 6,
          height: 6,
          decoration: const BoxDecoration(
            color: grayText,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: _archivoTextStyle(fontSize: 14, color: grayText),
          ),
        ),
      ],
    );
  }
}
