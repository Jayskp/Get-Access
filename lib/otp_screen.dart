import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'BottomNavBar.dart';
import 'auth_serviices.dart';

class PhoneVerifyScreen extends StatefulWidget {
  final String verificationID;
  final bool isAdmin;

  const PhoneVerifyScreen({
    Key? key,
    required this.verificationID,
    this.isAdmin = false,
  }) : super(key: key);

  @override
  _PhoneVerifyScreenState createState() => _PhoneVerifyScreenState();
}

class _PhoneVerifyScreenState extends State<PhoneVerifyScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _otpController = TextEditingController();
  late String _verificationId;
  bool _isLoading = false;
  String _errorMessage = '';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isValid = false;
  bool _isAdminLogin = false;

  // Animation controller for elements
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Theme colors
  static const Color primaryColor = Color(0xFF004D40);
  static const Color secondaryColor = Color(0xFF00796B);
  static const Color accentColor = Color(0xFF26A69A);
  static const Color grayText = Color(0xFF4A4A4A);

  @override
  void initState() {
    super.initState();
    _verificationId = widget.verificationID;
    _isAdminLogin = widget.isAdmin;

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

    // OTP validation listener
    _otpController.addListener(() {
      final otp = _otpController.text.trim();
      setState(() {
        _isValid = otp.length == 6;
      });
    });
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

      // Get the phone number from route arguments
      final phoneNumber =
          ModalRoute.of(context)?.settings.arguments as String? ?? '';

      UserCredential userCredential;

      if (_isAdminLogin) {
        // Sign in or register as admin using phone
        userCredential = await AuthService.verifyPhoneCodeAsAdmin(
          _verificationId,
          smsCode,
          phoneNumber.replaceAll('+91', ''),
        );
      } else {
        // Regular sign in or registration
        userCredential = await AuthService.verifyPhoneCode(
          _verificationId,
          smsCode,
          phoneNumber.replaceAll('+91', ''),
        );
      }

      if (mounted) {
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
        _errorMessage = e.message ?? 'OTP verification failed.';
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Verification failed: ${e.message}"),
            backgroundColor: Colors.red.shade700,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.all(12),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _otpController.dispose();
    super.dispose();
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
  Widget build(BuildContext context) {
    // Get the phone number from route arguments if available
    final phoneNumber =
        ModalRoute.of(context)?.settings.arguments as String? ?? '';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: Text(
          'Verify OTP',
          style: _archivoTextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: false,
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
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 30),

                            // OTP verification illustration
                            Center(child: _buildOtpAnimation()),

                            const SizedBox(height: 30),

                            // Phone number and instructions
                            Center(
                              child: Text(
                                'OTP Verification',
                                style: _archivoTextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            const SizedBox(height: 16),

                            Center(
                              child: Text(
                                'Enter the 6-digit code sent to',
                                textAlign: TextAlign.center,
                                style: _archivoTextStyle(
                                  fontSize: 16,
                                  color: grayText,
                                ),
                              ),
                            ),

                            const SizedBox(height: 4),

                            Center(
                              child: Text(
                                phoneNumber,
                                textAlign: TextAlign.center,
                                style: _archivoTextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: primaryColor,
                                ),
                              ),
                            ),

                            const SizedBox(height: 32),

                            // OTP Input field
                            _buildOtpInput(),

                            if (_errorMessage.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  _errorMessage,
                                  style: _archivoTextStyle(
                                    fontSize: 14,
                                    color: Colors.red.shade700,
                                  ),
                                ),
                              ),

                            const SizedBox(height: 20),

                            // Admin login option
                            CheckboxListTile(
                              title: Text(
                                'Sign in as admin',
                                style: _archivoTextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              value: _isAdminLogin,
                              onChanged: (bool? value) {
                                setState(() {
                                  _isAdminLogin = value ?? false;
                                });
                              },
                              controlAffinity: ListTileControlAffinity.leading,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                      'Use the OTP sent to the admin phone 9876543210',
                                      style: _archivoTextStyle(
                                        fontSize: 13,
                                        color: Colors.red.shade700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            const SizedBox(height: 32),

                            // Verify button
                            _buildVerifyButton(),

                            const SizedBox(height: 24),

                            // Resend OTP option
                            Center(
                              child: Column(
                                children: [
                                  Text(
                                    "Didn't receive the OTP?",
                                    style: _archivoTextStyle(
                                      fontSize: 14,
                                      color: grayText,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  TextButton(
                                    onPressed: () {
                                      // Resend OTP functionality would go here
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: const Text(
                                            "OTP resent successfully!",
                                          ),
                                          backgroundColor:
                                              Colors.green.shade700,
                                          behavior: SnackBarBehavior.floating,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          margin: const EdgeInsets.all(12),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      "RESEND OTP",
                                      style: _archivoTextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: primaryColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
                        'Verifying OTP...',
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

  // OTP verification animation
  Widget _buildOtpAnimation() {
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
                child: Icon(Icons.lock_outlined, size: 64, color: primaryColor),
              ),
            ),
          ),
        );
      },
    );
  }

  // OTP input field
  Widget _buildOtpInput() {
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
                color: _isValid ? primaryColor : Colors.grey.shade400,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color:
                      _isValid
                          ? primaryColor.withOpacity(0.1)
                          : Colors.transparent,
                  blurRadius: 8,
                  spreadRadius: 0,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              textAlign: TextAlign.center,
              style: _archivoTextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                counterText: '',
                hintText: '6-digit code',
                hintStyle: _archivoTextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade400,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                suffixIcon:
                    _isValid
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
            ),
          ),
        );
      },
    );
  }

  // Verify button
  Widget _buildVerifyButton() {
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
        onPressed: _isValid && !_isLoading ? _submitOTP : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: _isValid ? Colors.black : Colors.grey.shade300,
          disabledBackgroundColor: Colors.grey.shade200,
          elevation: _isValid ? 0 : 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Verify & Proceed',
              style: _archivoTextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward, size: 18),
          ],
        ),
      ),
    );
  }
}
