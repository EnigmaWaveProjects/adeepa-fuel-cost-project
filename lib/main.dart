// Import the Firebase Core package
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fuelcost/pages/home_page.dart';
import 'package:fuelcost/pages/profile_page.dart';
import 'package:fuelcost/pages/signin_page.dart'; // Import your SignInPage here
import 'package:fuelcost/pages/signup_page.dart';
import 'package:fuelcost/pages/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/', // Set the initial route
      routes: {
        '/': (context) =>
            const SplashScreen(), // Use '/' as the route name for SignupPage
        '/signin': (context) => SignInPage(),
        '/signup': (context) => SignupPage(),
        '/home': (context) => const HomePage(),
        '/profile': (context) =>
            ProfilePage(), // Use '/signin' as the route name for SignInPage
      },
      // Use '/signin' as the route name for SignInPage
    );
  }
}
