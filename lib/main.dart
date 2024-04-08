import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';

void main() {
 runApp(const MainApp());
}

class MainApp extends StatelessWidget {
 const MainApp({Key? key}) : super(key: key);

 @override
 Widget build(BuildContext context) {
    return MaterialApp(
      home: const SplashScreen(),
    );
 }
}

class SplashScreen extends StatefulWidget {
 const SplashScreen({Key? key}) : super(key: key);

 @override
 _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
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
          child: Text(
            'Tap anywhere to begin',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
 }
}

class HomePage extends StatelessWidget {
 const HomePage({Key? key}) : super(key: key);

 @override
 Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Already an user?',
              style: TextStyle(fontSize: 24),
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Profile Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Create Profile',
              style: TextStyle(fontSize: 24),
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Enter Profile Name',
                border: OutlineInputBorder(),
              ),
            ), ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SecondPage()),
            );
          },
          child: Text('Navigate to Feelings Page'),
        ),
          ],
        ),
      ),
    );
 }
}
class SecondPage extends StatelessWidget {
 const SecondPage({Key? key}) : super(key: key);

 @override
 Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('How are you feeling today?'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.push(
                 context,
                 MaterialPageRoute(builder: (context) => const ThirdPage('Green Smiley Face')),
                );
              },
              child: Icon(Icons.sentiment_very_satisfied, color: Colors.green, size: 100),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.push(
                 context,
                 MaterialPageRoute(builder: (context) => const ThirdPage('Yellow Neutral Face')),
                );
              },
              child: Icon(Icons.sentiment_neutral, color: Colors.yellow, size: 100),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.push(
                 context,
                 MaterialPageRoute(builder: (context) => const ThirdPage('Red Sad Face')),
                );
              },
              child: Icon(Icons.sentiment_dissatisfied, color: Colors.red, size: 100),
            ),
          ],
        ),
      ),
    );
 }
}
class ThirdPage extends StatefulWidget {
 final String feeling;

 const ThirdPage(this.feeling, {Key? key}) : super(key: key);

 @override
 _ThirdPageState createState() => _ThirdPageState();
}


class _ThirdPageState extends State<ThirdPage> {
 FlutterSoundRecorder? _recorder = FlutterSoundRecorder();
 bool _isRecording = false;
 String _recordedFilePath = '';
 String _selectedOption = ''; // State variable to track the selected option

 @override
 void initState() {
    super.initState();
    _recorder!.openAudioSession().then((value) => setState(() {}));
 }

 @override
 void dispose() {
    _recorder!.closeAudioSession();
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
        title: Text('Feeling Selected'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('You selected: ${widget.feeling}'),
            SizedBox(height: 20),
            Text('The people took my _____ on a walk'),
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
      child: Icon(_isRecording ? Icons.stop : Icons.mic),
      backgroundColor: Colors.blue,
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
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: _selectedOption == option ? Colors.green : defaultColor, // Change color based on selection
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(option),
      ),
    );
 }
}
