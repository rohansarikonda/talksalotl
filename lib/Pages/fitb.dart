//fitb stands for fill in the blank

import 'package:flutter/material.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';

class FITB extends StatefulWidget {
 final String feeling;

 FITB(this.feeling);

 @override
 _FITBState createState() => _FITBState();
}


class _FITBState extends State<FITB> {
 String _selectedOption = ''; // State variable to track the selected option


 @override
 Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feeling Selected'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('You selected: ${widget.feeling}'),
            const SizedBox(height: 20),
            const Text('The people took my _____ on a walk'),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: <Widget>[
                _buildOption('dog', Colors.grey),
                _buildOption('hairbrush', Colors.grey),
                _buildOption('nail polish', Colors.grey),
              ],
            ),
            // Rest of the code remains unchanged
          ],
        ),
      ),
    );
 }

 Widget _buildOption(String option, Color defaultColor) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedOption = option; // Update the selected option
        });
      },
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: _selectedOption == option 
          ? option == 'dog' ? Colors.green : Colors.red
          : defaultColor, // Change color based on selection
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(option),
      ),
    );
 }
}