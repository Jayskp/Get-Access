import 'dart:async';
import 'package:flutter/material.dart';
import 'package:getaccess/BottomNavBar.dart';
import 'package:getaccess/signin_screen.dart';
import 'package:getaccess/auth_serviices.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    // Add a small delay to show the splash screen animation
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    // Check if user is logged in
    final isLoggedIn = await AuthService.isLoggedIn();

    // Check if user is admin (only if logged in)
    bool isAdmin = false;
    if (isLoggedIn) {
      isAdmin = await AuthService.isAdmin();
    }

    if (!mounted) return;

    // Navigate to appropriate screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder:
            (context) =>
                isLoggedIn
                    ? BottomNavBarDemo(isAdmin: isAdmin)
                    : const SignUpPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Image(
                    image: AssetImage('assets/images/icons/logo.png'),height: 300,width: 300,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: SizedBox(
                  height: 4,
                  child: const ProcessCompletorIndicator(),
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Text('Loading', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class ProcessCompletorIndicator extends StatefulWidget {
  const ProcessCompletorIndicator({super.key});
  @override
  _ProcessCompletorIndicatorState createState() =>
      _ProcessCompletorIndicatorState();
}

class _ProcessCompletorIndicatorState extends State<ProcessCompletorIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Container(
              width: maxWidth * _controller.value,
              height: 4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                gradient: LinearGradient(
                  colors: [Color(0xFF31AF64), Color(0xFFFFB74D)],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
