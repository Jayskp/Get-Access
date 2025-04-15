import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:getaccess/splash_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Gate',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        primaryColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 1,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
        ),
        colorScheme: const ColorScheme.light(
          primary: Colors.grey,
          secondary: Colors.transparent,
          onPrimary: Colors.black,
        ),
      ),
      home: SplashScreen(),
    );
  }
}