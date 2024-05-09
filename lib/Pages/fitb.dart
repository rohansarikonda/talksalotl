//fitb stands for fill in the blank

import 'package:flutter/material.dart';
import '../constants.dart';
import 'congrats.dart';

class FITB extends StatefulWidget {
  const FITB({super.key});

  @override
  FITBState createState() => FITBState();
}

class FITBState extends State<FITB> {
  String _selectedOption = ''; // State variable to track the selected option

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comprehension Questions'),
      ),
      body: Container(
        color: AppConstants
            .backgroundColor1, // Set your desired background color here
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'What noise does the dog make?',
                  style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 180), // Add space here
                Wrap(
                  spacing: 35.0,
                  runSpacing: 8.0,
                  children: <Widget>[
                    _buildOption('meow', Colors.grey, 29.0),
                    _buildOption('woof', Colors.grey, 29.0),
                    _buildOption('moo', Colors.grey, 29.0),
                    _buildOption('oink', Colors.grey, 29.0),
                    _buildOption('ribbit', Colors.grey, 29.0),
                  ],
                ),
                // Rest of the code remains unchanged
              ],
            ),
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _isRecording ? _stopRecording : _startRecording,
      //   backgroundColor: Colors.blue,
      //   child: Icon(_isRecording ? Icons.stop : Icons.mic),
      // ),
    );
  }

  Widget _buildOption(String option, Color defaultColor, double fontSize) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedOption = option; // Update the selected option
        });
        if (option == 'woof') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Congrats()),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(13.0),
        decoration: BoxDecoration(
          color: _selectedOption == option
              ? option == 'woof'
                  ? Colors.green
                  : Colors.red
              : defaultColor, // Change color based on selection
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(
          option,
          style: TextStyle(fontSize: fontSize), // Change the font size here
        ),
      ),
    );
  }
}

class Style {
  const Style();
}