import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lottie/lottie.dart'; // Add this dependency for attractive animations
import 'package:flutter_spinkit/flutter_spinkit.dart'; // For loading indicators

import '../../auth_services.dart';
import '../Login/login_screen.dart';
import 'email_screen.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> with SingleTickerProviderStateMixin {
  final TextEditingController _phoneController = TextEditingController();
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
  static const Color footerShade = Color(0xFFF5F5F5);

  @override
  void initState() {
    super.initState();

    // Setup animations
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
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

  Future<void> _registerWithPhone(String phoneNumber) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_phone', phoneNumber);
      await Future.delayed(const Duration(seconds: 2)); // Simulate network delay
      await AuthService.register();

      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const LoginScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              var curve = Curves.easeInOut;
              var tween = Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: curve));
              return FadeTransition(opacity: animation.drive(tween), child: child);
            },
            transitionDuration: const Duration(milliseconds: 600),
          ),
        );
      }
    } catch (e) {
      // Show error snackbar
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registration failed: ${e.toString()}'),
            backgroundColor: Colors.red.shade700,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
        title: Text(
          'Get Started',
          style: _archivoTextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 30),

                          // Mobile phone illustration
                          SizedBox(
                            height: 150,
                            child: Lottie.network(
                              'https://assets8.lottiefiles.com/packages/lf20_t9mjka5s.json',
                              fit: BoxFit.contain,
                            ),
                          ),

                          const SizedBox(height: 30),
                          Text(
                            'Please enter your mobile number to proceed further',
                            textAlign: TextAlign.center,
                            style: _archivoTextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: grayText,
                            ),
                          ),
                          const SizedBox(height: 32),
                          _buildPhoneInput(),
                          const SizedBox(height: 20),
                          TextButton.icon(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const EmailSignInPage()),
                            ),
                            icon: const Icon(Icons.email_outlined, size: 18, color: primaryColor),
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
                          const SizedBox(height: 80),
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
                      SpinKitDoubleBounce(
                        color: primaryColor,
                        size: 60.0,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Registering...',
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

  Widget _buildPhoneInput() {
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
              border: Border.all(color: _isValid ? primaryColor : Colors.grey.shade400, width: 1.5),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: _isValid ? primaryColor.withOpacity(0.1) : Colors.transparent,
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
                const VerticalDivider(color: primaryColor, thickness: 1, width: 1),
                Expanded(
                  child: TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.number,
                    maxLength: 10,
                    decoration: InputDecoration(
                      counterText: '',
                      hintText: 'Enter Mobile Number',
                      hintStyle: _archivoTextStyle(fontSize: 16, color: Colors.grey.shade400),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      suffixIcon: _isValid
                          ? Icon(Icons.check_circle, color: Colors.green.shade600)
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
        boxShadow: _isValid
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
        onPressed: _isValid && !_isLoading
            ? () {
          final phone = '+91${_phoneController.text.trim()}';
          _registerWithPhone(phone);
        }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: _isValid ? primaryColor : Colors.grey.shade300,
          disabledBackgroundColor: Colors.grey.shade200,
          elevation: _isValid ? 0 : 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: _isLoading
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
              'Continue',
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

  Widget _buildFooter() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: footerShade,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.shield, size: 20, color: primaryColor.withValues(alpha: 0.7)),
              const SizedBox(width: 8),
              Text(
                'Your data is safe with us',
                style: _archivoTextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('•', style: _archivoTextStyle(fontSize: 14, color: grayText)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'We do not sell or trade your data',
                  style: _archivoTextStyle(fontSize: 14, color: grayText),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('•', style: _archivoTextStyle(fontSize: 14, color: grayText)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Your information is fully encrypted',
                  style: _archivoTextStyle(fontSize: 14, color: grayText),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: Colors.grey, height: 1),
          const SizedBox(height: 16),
          InkWell(
            onTap: () {},
            child: Text(
              'Privacy Policy',
              style: _archivoTextStyle(fontSize: 14, color: primaryColor)
                  .copyWith(decoration: TextDecoration.underline),
            ),
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: () {},
            child: Text(
              'Terms & Conditions',
              style: _archivoTextStyle(fontSize: 14, color: primaryColor)
                  .copyWith(decoration: TextDecoration.underline),
            ),
          ),
        ],
      ),
    );
  }
}