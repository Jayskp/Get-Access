import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../BottomNavBar.dart';
import '../../auth_serviices.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailOrPhoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isValid = false;
  bool _showError = false;
  bool _isLoading = false;
  String _errorMessage = '';
  bool _useEmail = true;

  static const Color primaryColor = Color(0xFF004D40);
  static const Color grayText = Color(0xFF4A4A4A);

  TextStyle _archivoTextStyle({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.normal,
    Color color = Colors.black,
  }) {
    return GoogleFonts.archivo(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }

  @override
  void initState() {
    super.initState();
    _checkLoginType();
    _emailOrPhoneController.addListener(_validateInput);
    _passwordController.addListener(_validateInput);
  }

  Future<void> _checkLoginType() async {
    final prefs = await SharedPreferences.getInstance();
    final hasEmail = prefs.containsKey('user_email');
    final _ = prefs.containsKey('user_phone');

    setState(() {
      _useEmail = hasEmail;
    });
  }

  void _validateInput() {
    setState(() {
      _showError = false;

      if (_useEmail) {
        final bool emailValid = RegExp(
          r"^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$",
        ).hasMatch(_emailOrPhoneController.text.trim());
        final bool passwordValid = _passwordController.text.length >= 6;
        _isValid = emailValid && passwordValid;
      } else {
        final bool phoneValid = RegExp(
          r"^\+91[0-9]{10}$",
        ).hasMatch(_emailOrPhoneController.text.trim());
        _isValid = phoneValid;
      }
    });
  }

  void _login() async {
    if (_isValid) {
      setState(() {
        _isLoading = true;
        _showError = false;
      });

      try {
        final prefs = await SharedPreferences.getInstance();
        bool isAuthenticated = false;

        if (_useEmail) {
          // Verify email and password
          final storedEmail = prefs.getString('user_email') ?? '';
          final storedPassword = prefs.getString('user_password') ?? '';

          if (_emailOrPhoneController.text.trim() == storedEmail &&
              _passwordController.text == storedPassword) {
            isAuthenticated = true;
          }
        } else {
          // Verify phone number
          final storedPhone = prefs.getString('user_phone') ?? '';

          if (_emailOrPhoneController.text.trim() == storedPhone) {
            isAuthenticated = true;
          }
        }

        if (isAuthenticated) {
          // Set login state
          await AuthService.login();

          // Navigate to social screen
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => BottomNavBarDemo()),
            (route) => false, // Remove all previous routes
          );
        } else {
          setState(() {
            _showError = true;
            _errorMessage =
                _useEmail
                    ? 'Invalid email or password'
                    : 'Invalid phone number';
          });
        }
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
    }
  }

  @override
  void dispose() {
    _emailOrPhoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const borderColor = Color(0xFF004D40);
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 768;
    final isWebScreen = screenWidth > 1024;

    // Responsive padding
    final horizontalPadding =
        isWebScreen ? 32.0 : (isLargeScreen ? 28.0 : 24.0);
    final verticalSpacing = isLargeScreen ? 40.0 : 32.0;

    return WillPopScope(
      onWillPop: () async {
        // Disable back button
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            'Login',
            style: _archivoTextStyle(
              fontSize: isWebScreen ? 22 : 20,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false, // Remove back button
          toolbarHeight: isWebScreen ? 70 : 56,
          centerTitle: isWebScreen ? true : false,
        ),
        body: Center(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: isWebScreen ? 480 : double.infinity,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: isWebScreen ? 24 : 16,
            ),
            child: Column(
              children: [
                SizedBox(height: isWebScreen ? 50 : 40),
                Text(
                  _useEmail
                      ? 'Please enter your email and password to login'
                      : 'Please enter your phone number to login',
                  textAlign: TextAlign.center,
                  style: _archivoTextStyle(
                    fontSize: isWebScreen ? 18 : 16,
                    color: grayText,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: verticalSpacing),

                // Email/Phone TextField
                Container(
                  height: 56,
                  decoration: BoxDecoration(
                    border: Border.all(color: borderColor, width: 1.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child:
                      !_useEmail
                          ? Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                child: Text(
                                  '+91',
                                  style: _archivoTextStyle(fontSize: 16),
                                ),
                              ),
                              const VerticalDivider(
                                width: 1,
                                thickness: 1,
                                color: primaryColor,
                              ),
                              Expanded(
                                child: TextField(
                                  controller: _emailOrPhoneController,
                                  keyboardType: TextInputType.number,
                                  maxLength: 10,
                                  decoration: InputDecoration(
                                    counterText: '',
                                    hintText: 'Enter Mobile Number',
                                    hintStyle: _archivoTextStyle(
                                      color: Colors.grey,
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
                                  ),
                                  style: _archivoTextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          )
                          : TextField(
                            controller: _emailOrPhoneController,
                            keyboardType: TextInputType.emailAddress,
                            style: _archivoTextStyle(fontSize: 16),
                            decoration: InputDecoration(
                              hintText: 'Enter your Email',
                              hintStyle: _archivoTextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                            ),
                          ),
                ),

                // Password TextField (only for email login)
                if (_useEmail) ...[
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
                      style: _archivoTextStyle(fontSize: 16),
                      decoration: InputDecoration(
                        hintText: 'Enter your Password',
                        hintStyle: _archivoTextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                      ),
                    ),
                  ),
                ],

                if (_showError)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      _errorMessage,
                      style: _archivoTextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
                SizedBox(height: isWebScreen ? 32 : 24),

                // Login Button
                SizedBox(
                  width: isWebScreen ? 320 : double.infinity,
                  height: isWebScreen ? 52 : 48,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : (_isValid ? _login : null),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _isValid ? Colors.black : Colors.grey.shade300,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child:
                        _isLoading
                            ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                            : Text(
                              'Login',
                              style: _archivoTextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: isWebScreen ? 18 : 16,
                              ),
                            ),
                  ),
                ),

                SizedBox(height: isWebScreen ? 24 : 20),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _useEmail = !_useEmail;
                      _emailOrPhoneController.clear();
                      _passwordController.clear();
                      _isValid = false;
                    });
                  },
                  child: Text(
                    _useEmail ? 'Use Phone instead' : 'Use Email instead',
                    style: _archivoTextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: isWebScreen ? 16 : 14,
                      color: primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
