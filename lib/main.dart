import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

// 1. Import the display‐mode plugin
import 'package:flutter_displaymode/flutter_displaymode.dart';

import 'package:getaccess/auth_services.dart';
import 'package:getaccess/BottomNavBar.dart';
import 'package:getaccess/providers/social_post_provider.dart';
import 'package:getaccess/screens/Login/login_screen.dart';
import 'package:getaccess/screens/Signin/sigin_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Request the highest available refresh rate
  //    On Android this switches you to the top mode if supported :contentReference[oaicite:0]{index=0}.
  try {
    await FlutterDisplayMode.setHighRefreshRate();
  } catch (e) {
    debugPrint('Could not set high refresh rate: $e');
  }

  // 3. Lock to portrait
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  );

  // 4. Edge-to-edge UI
  await SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SocialPostProvider()),
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
      title: 'GetAccess',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
      ),
      home: const LandingPage(),
    );
  }
}

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);
  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  late final Future<Widget> _landingFuture;

  @override
  void initState() {
    super.initState();
    _landingFuture = _determineStartScreen();
  }

  Future<Widget> _determineStartScreen() async {
    final isRegistered = await AuthService.isRegistered();
    if (!isRegistered) return const SignUpPage();

    final isLoggedIn = await AuthService.isLoggedIn();
    if (!isLoggedIn) return const LoginScreen();

    return const BottomNavBarDemo();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _landingFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return WillPopScope(
          onWillPop: () async {
            final exit = await showDialog<bool>(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('Exit App'),
                content: const Text('Do you want to exit the app?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Exit'),
                  ),
                ],
              ),
            ) ??
                false;
            if (exit) SystemNavigator.pop();
            return false;
          },
          child: snapshot.data!,
        );
      },
    );
  }
}
