// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import '../constants.dart'; // import constants
import 'fitb.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import '../keys.dart';
import 'dart:io';
import 'dart:math';
//all above imports are for the api calls

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
//all above packages are for the audio recording
import 'package:shared_preferences/shared_preferences.dart'; //for high score storage


class Choice extends StatefulWidget {
  const Choice({super.key});

  @override
  State<Choice> createState() => _ChoiceState();
}

class _ChoiceState extends State<Choice> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Pronunciation or Comprehension',
            style: TextStyle(fontSize: 20)),
      ),
      body: Container(
        color: AppConstants
            .backgroundColor1, // Set your desired background color here
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const FITB(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize:
                        const Size(350, 100), // Set the minimum size of the button
                    textStyle: const TextStyle(
                      fontSize: 30, // Adjust the font size here
                    ),
                  ),
                  child: const Text('Comprehension'),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const WordEvaluationPage())
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize:
                        const Size(350, 100), // Set the minimum size of the button
                    textStyle: const TextStyle(
                      fontSize: 30, // Adjust the font size here
                    ),
                  ),
                  child: const Text('Pronunciation'),
                ),
              ),
              // GestureDetector(
              //   onTap: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(builder: (context) => EvalScreen()),
              //     );
              //   },
              //   child: const Text('Navigate to Pronunciation Questions'),
              // ),
            ],
          ),
        ),
      ),
    );
  }



}

class WordEvaluationPage extends StatefulWidget {
  const WordEvaluationPage({super.key});

  @override
  WordEvaluationPageState createState() => WordEvaluationPageState();
}

class WordEvaluationPageState extends State<WordEvaluationPage> {
  FlutterSoundRecorder? _recorder = FlutterSoundRecorder();
  bool _isRecording = false;
  bool _highScore = false;
  double _currentHighScore = 0.0;
  double _currentScore = 0.0;
  late String _recordedFilePath;
  late String _currentWord;
  TextEditingController resultController = TextEditingController();

  //below are constants for the API calls

  final String appKey = app; //app and secret are from keys.dart (untracked for security, holds appKey and secretKey)
  final String secretKey = secret;
  final String userId = "rsarikonda";
  final String baseHOST = "api.speechsuper.com";

  final String wordCore = "word.eval.promax"; // coretype for the word evaluation
  final String sentCore = "sent.eval.promax"; // coretype for the sentence evaluation
  final audioType = "mp3"; // Change the audio type corresponding to the audio file.
  final audioSampleRate = "16000";

  //SCORE STORAGE AND RETRIEVAL

  Future<void> storeValue(String key, String value) async { //store "something" (used for high scores)
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  Future<void> retrieveValue(String key) async { //retrieve "something" (used for high scores)
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentHighScore = double.parse(prefs.getString(key) ?? "0.0");
    });
  }

  //REQUEST PERMISSIONS

  Future<void> requestMicrophonePermission() async {  //request microphone permission
    final microphoneStatus = await Permission.microphone.status;
    if (!(microphoneStatus.isGranted)) {
      await Permission.microphone.request();
    }
    print("MICROPHONE:$microphoneStatus");
  }

  Future<void> requestStoragePermissions() async { //request storage permission
    final storageStatus = await Permission.storage.status;
    if (!(storageStatus.isGranted)) {
      await Permission.storage.request();
    }

    print("STORAGE:$storageStatus");
  }

  Future<void> requestAudioPermissions() async { //request audio permission
    final audioStatus = await Permission.audio.status;
    if (!(audioStatus.isGranted)) {
      await Permission.audio.request();
    }

    print("AUDIO: $audioStatus");
  }

  Future<void> requestAllPermissions() async { //request all required permissions
    requestAudioPermissions();
    requestMicrophonePermission();
    requestStoragePermissions();
  }

  /*Future<void> requestExternalStoragePermissions() async {
    final status = await Permission.manageExternalStorage.status;
    if (!(status.isGranted)) {
      await Permission.manageExternalStorage.request();
    }
  }*/ //this permission is for using external storage like SD cards

  //AUDIO RECORDING

  //get path for where to save audio files
  Future<String?> getSavePath() async {
  Directory? directory = await getApplicationDocumentsDirectory();
  print("INITIAL DIRECTORY: ${directory.path}");
  // ignore: unnecessary_null_comparison
  if (directory != null) {
    /*
    final filename = await showDialog(
      context: NavigationService.navigatorKey.currentContext?? context,
      builder: (context) => const SaveFileDialog(),
    );

    if (filename != null) {
      setState(() {
        _recordedFilePath = '${directory.path}/$filename.aac';
      });
      print("Current File Path: ${directory.path}/$filename.aac");
      return '${directory.path}/$filename.aac';
    } else {
      print("Error: File name not provided.");
      return null;
    }
    */
    setState(() {
        _recordedFilePath = '${directory.path}/temp.aac';
      });
      print("Current File Path: ${directory.path}/temp.aac");
      return '${directory.path}/temp.aac';
  } else {
    print("Error: Documents directory not available.");
    return null;
  }
  }

  //do this on initialization
  @override
  void initState() {
    super.initState(); //initState
    requestAllPermissions(); //get all perms
    _loadRandomWord().then((word) { //load the word 
      setState(() {
        _currentWord = word;
      });
    });
    _recorder!.openRecorder().then((value) => setState(() {})); //make the audio recorder
  }

  //get rid of the recorder
  @override
  void dispose() {
    _recorder!.closeRecorder();
    _recorder = null;
    super.dispose();
  }

  //start the recording
  Future<void> _startRecording() async { 
  String filePath = await getSavePath() ?? 'placeholder'; //handle the case for no path recieved
  if (filePath.isEmpty) {
    print("Error: No path retrieved from getSavePath");
    return;
  }
  print("CURRENT FILE PATH:$filePath");
  setState(() { 
    _isRecording = true;
    _recordedFilePath = filePath;  // Set path directly
  });
  print("RECORDED FILE PATH: $_recordedFilePath");
  
  try {
    await _recorder!.startRecorder(toFile: filePath); //error handling in case of recorder malfunction
  } catch (e) {
    print("Error starting recorder: $e");
  }
}

  //stop the recording
  Future<void> _stopRecording() async {
    setState(() {
      _isRecording = false; //set the recording state to false
    });

    try { //error handling with recorder closing
      await _recorder!.stopRecorder();
    } catch (e) {
      print("Error Closing Recorder: $e");
    }
    // Check if the file exists
    final fileExists = await File(_recordedFilePath).exists();
    if (!fileExists) {
      print('Error: File does not exist at path: $_recordedFilePath');
      return;
    }

    // Check if the file is empty
    final fileSize = await File(_recordedFilePath).length();
    if (fileSize == 0) {
      print('Error: File is empty at path: $_recordedFilePath');
      return;
    }
  }

  //load the word for the user to say
  Future<String> _loadRandomWord() async {

    Directory current = Directory.current;
    String dir = current.path;
    print(dir);
    String jsonString = await rootBundle.loadString('./assets/common.json');
    Map map = await jsonDecode(jsonString);
    List<String> words = await map["commonWords"].cast<String>();

    String word = words[Random().nextInt(words.length)];
    
    setState(() {
      _currentWord = word;
    });

    return word;
  }

  String getScoreMessage(double score) { //returns the approriate message depending on their score
    if (score >= 80 && score <= 100) {
      return 'Very good!';
    } else if (score >= 60 && score < 80) {
      return 'Pretty good!';
    } else if (score >= 30 && score < 60) {
      return 'Needs some work.';
    } else {
      return 'You can do better next time!';
    }
  }
  
  //method for pronunciation evaluation
  void doWordEval() async {
    
    String timestamp =  DateTime.now().millisecondsSinceEpoch.toString(); //timestamp of api call
    String connectSig = sha1.convert(utf8.encode("$appKey$timestamp$secretKey")).toString(); //signature of this connection
    String startSig = sha1.convert(utf8.encode("$appKey$timestamp$userId$secretKey")).toString(); //signature of the start call
    String tokenId = DateTime.now().millisecondsSinceEpoch.toString(); //id of the token
    var params = { //parameters for connecting and starting the api call
      "connect": {
        "cmd": "connect",
        "param": {
           "sdk": {
             "version": 16777472,
             "source": 9,
             "protocol": 2
           },
          "app": {
            "applicationId": appKey,
            "sig": connectSig,
            "timestamp": timestamp
          }
        }
      },
      "start": {
        "cmd": "start",
        "param": {
          "app": {
            "applicationId": appKey,
            "sig": startSig,
            "userId": userId,
            "timestamp": timestamp
          },
          "audio": {
            "audioType": audioType,
            "sampleRate": audioSampleRate,
            "channel": 1,
            "sampleBytes":2
          },
          "request": {
            "refText": _currentWord,
            "tokenId": tokenId
          }
        }
      }
    };

    final file = File(_recordedFilePath); //load the file from the filesystem
    if (!await file.exists()) { //if the file doesn't exist
      print("ERROR: THE FILE DOES NOT EXIST AT: $_recordedFilePath");
      return;
    }

    //read the file's bytes
    final bytes = await file.readAsBytes();

    //use bytes directly in the request
    var url = Uri.https(baseHOST, wordCore); //create the url
    var request = http.MultipartRequest("POST", url) //make http request
    ..fields["text"] = jsonEncode(params)
    ..files.add(http.MultipartFile.fromBytes("audio", bytes)) //pass bytes from the audio file
    ..headers["Request-Index"] = "0";

      var response = await request.send(); //get the response back
      if(response.statusCode != 200) {
        resultController.text = "HTTP status code ${response.statusCode}"; //if something went wrong
      } else {
         response.stream.transform(utf8.decoder).join().then((String str) { //decode the response
           if(str.contains("error")) {
          resultController.text = str; //handle errors in the response
            } else {
              var respJson = jsonDecode(str); //decode the json
              double currentScore = double.parse("${respJson["result"]["overall"]}"); //set the current score
              _currentScore = currentScore;
              print("CURRENT SCORE: $currentScore"); //print the current score (for debugging)
              print("CURRENT HIGH SCORE: $_currentHighScore"); //print the current high score (for debugging)
              if (currentScore > _currentHighScore) {
                setState(() {
                  _highScore = true;
                });
                print("NEW HIGH SCORE!");
                storeValue(_currentWord, currentScore.toString());
              }
              else {
                setState(() {
                  _highScore = false;
                });
                print("NO NEW HIGH SCORE!");
              }
              resultController.text = currentScore.toString(); //make the value in resultController the score
            }
         });
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  appBar: AppBar(
    title: const Text('Word Evaluation'),
  ),
  body: Container (
    color: AppConstants.backgroundColor1,
    child: Stack(
    children: <Widget>[
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            children: <Widget>[
              const Text('The word you need to say is:'), //helper text
              Text(
                _currentWord,
                style: const TextStyle(
                  fontSize: 30.0, //big text
                  fontWeight: FontWeight.bold, //bold text
                ),
                textAlign: TextAlign.center, //center the text
              ),
            ],
          ),
          Expanded(
            child: TextField(
              controller: resultController, //display the word they need to say
              style: const TextStyle(
                fontSize: 50.0, //really big text
                fontWeight: FontWeight.bold, //make it bold
                color: Color(0xFF8eb8e5), //colored light blue
              ),
              textAlign: TextAlign.center,
            ),
          ),
           if (_highScore) //if their score was a new high score
              const Text(
                'New high score!',
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
                textAlign: TextAlign.center,
              ),
            if (_currentScore != 0) 
              Text(
              getScoreMessage(_currentScore),
              style: const TextStyle(
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
              ),
            textAlign: TextAlign.center,
            ),
        ],
      ),
      Positioned(
        bottom: 100.0,
        left: 0.0,
        right: 0.0,
        child: Center(
        child: Container(
          height: 100.0,  // Set the height
          width: 100.0,  // Set the width
          child: FloatingActionButton(
            onPressed: () async {
              if (_isRecording) {
                await _stopRecording();
                doWordEval();
              } else {
                _startRecording();
              }
            },
            backgroundColor: AppConstants.accentColor1,
            child: Icon(_isRecording ? Icons.stop : Icons.mic, size: 50.0),  // Increase the size of the icon as well
          ),
        ),
  ),
      ),
    ],
  ),
  )
);
  }
}

