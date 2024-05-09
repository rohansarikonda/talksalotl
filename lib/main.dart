import 'package:flutter/material.dart';
import '../Pages/feelings.dart';

void main() {
 runApp(const MainApp());
}

class MainApp extends StatelessWidget {
 const MainApp({super.key});

 @override
 Widget build(BuildContext context) {
    return const MaterialApp(
      home: SplashScreen(),
    );
 }
}

class SplashScreen extends StatefulWidget {
 const SplashScreen({super.key});

 @override
 SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
 @override
 void initState() {
    super.initState();
    // Use a Timer to delay the navigation to the home page
    Future.delayed(const Duration(seconds: 3000), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    });
 }

 @override
 Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: () {
            // Navigate to the home page immediately when tapped
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          },
          child: const Text(
            'Click here to begin!',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
 }
}

class HomePage extends StatelessWidget {
 const HomePage({super.key});

 @override
 Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Already a user?',
              style: TextStyle(fontSize: 24),
            ),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Profile Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Create Profile',
              style: TextStyle(fontSize: 24),
            ),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Enter Profile Name',
                border: OutlineInputBorder(),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                 context,
                 MaterialPageRoute(builder: (context) => const Feelings()),
                );
              },
              child: const Text('Navigate to Feelings Page'),
            ),
          ],
        ),
      ),
    );
 }
}

