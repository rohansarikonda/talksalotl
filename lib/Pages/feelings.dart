import '../constants.dart';
import 'package:flutter/material.dart';
import 'choice.dart';

class Feelings extends StatelessWidget {
  const Feelings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('How are you feeling today?',
            style: TextStyle(fontSize: 35)),
      ),
      body: Container(
        color: AppConstants
            .backgroundColor1, // Set your desired background color here

        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => const Choice()),
                  // );
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const Choice(),
                    ),
                  );
                },
                child: const Icon(Icons.sentiment_very_satisfied,
                    color: Colors.green, size: 100),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const Choice(),
                    ),
                  );
                },
                child: const Icon(Icons.sentiment_neutral,
                    color: Colors.yellow, size: 100),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => Choice()),
                  // );
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const Choice(),
                    ),
                  );
                },
                child: const Icon(Icons.sentiment_dissatisfied,
                    color: Colors.red, size: 100),
              ),
            ],
          ),
        ),
      ),
    );
  }
}