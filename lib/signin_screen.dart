import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'BottomNavBar.dart';
import 'email_signin_screen.dart';
import 'otp_screen.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _phoneController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isValid = false;
  bool _isLoading = false;

  // Animation controller for elements
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Theme colors
  static const Color primaryColor = Color(0xFF004D40);
  static const Color secondaryColor = Color(0xFF00796B);
  static const Color accentColor = Color(0xFF26A69A);
  static const Color grayText = Color(0xFF4A4A4A);
  static const Color footerShade = Color(0xFFF3F3F3);

  @override
  void initState() {
    super.initState();

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

    // Phone validation listener
    _phoneController.addListener(() {
      final phone = _phoneController.text.trim();
      setState(() {
        _isValid = RegExp(r"^[0-9]{10}$").hasMatch(phone);
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  /// Initiates phone number verification and navigates to PhoneVerifyScreen
  /// when the OTP is sent.
  void _verifyPhoneNumber(String phoneNumber) async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber, // Expected format: +919876543210
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Optional: Automatically sign the user in on Android.
          await _auth.signInWithCredential(credential);
          // Navigate to the home screen after auto verification.
          if (mounted) {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder:
                    (context, animation, secondaryAnimation) =>
                        BottomNavBarDemo(),
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
        },
        verificationFailed: (FirebaseAuthException e) {
          // Display or log the error as needed.
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
        },
        codeSent: (String verificationId, int? resendToken) {
          // Once the code is sent, navigate to the PhoneVerifyScreen and pass the verificationId.
          setState(() {
            _isLoading = false;
          });
          if (mounted) {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder:
                    (context, animation, secondaryAnimation) =>
                        PhoneVerifyScreen(verificationID: verificationId),
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
                settings: RouteSettings(arguments: phoneNumber),
                transitionDuration: const Duration(milliseconds: 500),
              ),
            );
          }
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Handle timeout if needed.
          setState(() {
            _isLoading = false;
          });
        },
        timeout: const Duration(seconds: 60),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occurred: ${e.toString()}'),
            backgroundColor: Colors.red.shade700,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.all(12),
          ),
        );
      }
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: Text(
          'Get Started',
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
                      child: Column(
                        children: [
                          const SizedBox(height: 30),

                          // Mobile phone illustration (Flutter built-in)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: SizedBox(
                              height: 150,
                              child: _buildPhoneAnimation(),
                            ),
                          ),

                          const SizedBox(height: 30),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24.0,
                            ),
                            child: Text(
                              'Please enter your mobile number to proceed further',
                              textAlign: TextAlign.center,
                              style: _archivoTextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: grayText,
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                          _buildPhoneInput(),
                          const SizedBox(height: 20),
                          TextButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EmailSignInPage(),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.email_outlined,
                              size: 18,
                              color: primaryColor,
                            ),
                            label: Text(
                              'Use Email Instead',
                              style: _archivoTextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: primaryColor,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildSubmitButton(),
                          const SizedBox(height: 40),
                          _buildFooter(),
                        ],
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
              color: Colors.black.withValues(alpha: 0.5),
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
                        'Sending OTP...',
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

  // Custom phone animation using Flutter's built-in widgets
  Widget _buildPhoneAnimation() {
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
                child: Icon(Icons.phone_android, size: 64, color: primaryColor),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPhoneInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: TweenAnimationBuilder<double>(
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
                      child: Text(
                        '+91',
                        style: _archivoTextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ),
                  const VerticalDivider(
                    color: primaryColor,
                    thickness: 1,
                    width: 1,
                  ),
                  Expanded(
                    child: TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.number,
                      maxLength: 10,
                      decoration: InputDecoration(
                        counterText: '',
                        hintText: 'Enter Mobile Number',
                        hintStyle: _archivoTextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade400,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
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
                      style: _archivoTextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
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
          onPressed:
              _isValid && !_isLoading
                  ? () {
                    final phoneNumber = "+91${_phoneController.text.trim()}";
                    _verifyPhoneNumber(phoneNumber);
                  }
                  : null,
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
                        'Get OTP',
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
