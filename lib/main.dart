import 'package:flutter/material.dart';
import './constants.dart';
import 'app.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}
// the class below navigates to home page
class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Use a Timer to delay the navigation to the home page
    Future.delayed(const Duration(seconds: 3000), () {
      Navigator.pushReplacement(
        context,
        // MaterialPageRoute(builder: (context) => const RootPage()),
        MaterialPageRoute(builder: (context) => App()),
      );
    });
  }
// navigates within home page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor1,
      appBar: AppBar(
        title: const Text('Talksalotl'),
      ),
      body: Center(
        child: GestureDetector(
          onTap: () {
            // Navigate to the home page immediately when tapped
            Navigator.pushReplacement(
              context,
              // MaterialPageRoute(builder: (context) => const RootPage()),
              MaterialPageRoute(builder: (context) => const App()),
            );
          },
          child: const Text(
            'Tap anywhere to begin',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
