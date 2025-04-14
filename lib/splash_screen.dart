import 'dart:async';
import 'package:flutter/material.dart';
import 'package:getaccess/BottomNavBar.dart';
import 'package:getaccess/Settings.dart';
// import 'package:mygate/screens/signin/signin_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BottomNavBarDemo()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Image(image: AssetImage('assets/images/icons/GA.png')),
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
  const ProcessCompletorIndicator({Key? key}) : super(key: key);
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
                  colors: [
                    Color(0xFFFFF9C4),
                    Color(0xFFBBDEFB),
                  ], // light yellow → light blue
                ),
              ),
            );
          },
        );
      },
    );
  }
}
