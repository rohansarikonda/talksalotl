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
 FlutterSoundRecorder? _recorder = FlutterSoundRecorder();
 bool _isRecording = false;
 final String _recordedFilePath = '';
 String _selectedOption = ''; // State variable to track the selected option

 @override
 void initState() {
    super.initState();
    _recorder!.openRecorder().then((value) => setState(() {}));
 }

 @override
 void dispose() {
    _recorder!.closeRecorder();
    _recorder = null;
    super.dispose();
 }

 Future<void> _startRecording() async {
    await _recorder!.startRecorder(toFile: _recordedFilePath);
    setState(() {
      _isRecording = true;
    });
 }

 Future<void> _stopRecording() async {
    await _recorder!.stopRecorder();
    setState(() {
      _isRecording = false;
    });
 }

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
      ),floatingActionButton: FloatingActionButton(
      onPressed: _isRecording ? _stopRecording : _startRecording,
      backgroundColor: Colors.blue,
      child: Icon(_isRecording ? Icons.stop : Icons.mic),
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