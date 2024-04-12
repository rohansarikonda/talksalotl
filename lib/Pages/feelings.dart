
import 'package:flutter/material.dart';
import './fitb.dart';

class Feelings extends StatelessWidget {
 const Feelings({Key? key});

 @override
 Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('How are you feeling today?'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.push(
                 context,
                 MaterialPageRoute(builder: (context) => FITB('Green Smiley Face')),
                );
              },
              child: const Icon(Icons.sentiment_very_satisfied, color: Colors.green, size: 100),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.push(
                 context,
                 MaterialPageRoute(builder: (context) => FITB('Yellow Neutral Face')),
                );
              },
              child: const Icon(Icons.sentiment_neutral, color: Colors.yellow, size: 100),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.push(
                 context,
                 MaterialPageRoute(builder: (context) => FITB('Red Sad Face')),
                );
              },
              child: const Icon(Icons.sentiment_dissatisfied, color: Colors.red, size: 100),
            ),
          ],
        ),
      ),
    );
 }
}