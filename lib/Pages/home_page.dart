import 'package:flutter/material.dart';
import '../constants.dart';
import 'feelings.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

// home page is created where users can input their profile name or create a profile
class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppConstants
          .backgroundColor1, // Set your desired background color here
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Already a user?',
              style: TextStyle(fontSize: 40),
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
              style: TextStyle(fontSize: 40),
            ),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Enter Profile Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const Feelings(),
                  ),
                );
              },
              child: const Text('Navigate to Feelings Page'),
            ),
            const SizedBox(height: 20),
            
          ],
        ),
      ),
    );
  }
}
