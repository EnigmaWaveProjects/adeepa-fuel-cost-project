// Import the Firebase Core package
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fuelcost/pages/home_page.dart';
import 'package:fuelcost/pages/profile_page.dart';
import 'package:fuelcost/pages/signin_page.dart'; // Import your SignInPage here
import 'package:fuelcost/pages/signup_page.dart';
import 'package:fuelcost/pages/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await dotenv.load(fileName: ".env");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: false),
      initialRoute: '/', // Set the initial route
      routes: {
        '/': (context) => const SplashScreen(),
        '/signin': (context) => const SignInPage(),
        '/signup': (context) => SignupPage(),
        '/home': (context) => const HomePage(),
        '/profile': (context) =>
            const ProfilePage(), // Use '/signin' as the route name for SignInPage
      },
      // Use '/signin' as the route name for SignInPage
    );
  }
}
