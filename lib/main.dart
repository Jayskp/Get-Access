import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:getaccess/screens/Login/login_screen.dart';
import 'package:getaccess/signin_screen.dart';
import 'BottomNavBar.dart';
import 'auth_serviices.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'providers/social_post_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'splash_screen.dart';
import 'providers/comment_provider.dart';
import 'providers/announcement_provider.dart';
import 'providers/notice_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Check if Firebase is already initialized
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
  } catch (e) {
    if (kDebugMode) {
      print('Firebase initialization error: $e');
    }
    // Continue with the app even if Firebase fails
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SocialPostProvider()),
        ChangeNotifierProvider(create: (_) => CommentProvider()),
        ChangeNotifierProvider(create: (_) => AnnouncementProvider()),
        ChangeNotifierProvider(create: (context) => NoticeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Get Access',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: Colors.white,
        cardColor: Colors.white,
        colorScheme: ColorScheme.light(
          background: Colors.white,
          surface: Colors.white,
          primary: Colors.teal,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

Future<void> checkAuthAndRedirect(BuildContext context) async {
  try {
    // First check Firebase Auth
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      // User is already authenticated with Firebase
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const BottomNavBarDemo()),
      );
      return;
    }

    // Check if user is already logged in via AuthService
    final isLoggedIn = await AuthService.isLoggedIn();
    if (isLoggedIn) {
      // User is already logged in through shared preferences
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const BottomNavBarDemo()),
      );
    } else {
      // Check if user is registered but not logged in
      final prefs = await SharedPreferences.getInstance();
      final isRegistered = prefs.getBool('is_registered') ?? false;

      if (isRegistered) {
        // User is registered, navigate to login screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      } else {
        // New user, navigate to sign up screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const SignUpPage()),
        );
      }
    }
  } catch (e) {
    if (kDebugMode) {
      print("Error during auth check: $e");
    }
    // Fallback to sign up screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const SignUpPage()),
    );
  }
}
