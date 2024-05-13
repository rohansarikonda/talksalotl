import 'package:flutter/material.dart';
import '../constants.dart';

// creates page where users are at the end, congragulating them on completely their activity time
class Congrats extends StatelessWidget {
  const Congrats({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Congratulations!', style: TextStyle(fontSize: 35)),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        color: AppConstants
            .backgroundColor1, // Set your desired background color here

        child: const Center(
          // padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Good job! We hope to see you again!',
                style: TextStyle(fontSize: 50),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
