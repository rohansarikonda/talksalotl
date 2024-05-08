import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import '../keys.dart';
import 'dart:io';
import 'dart:math';

//all above imports are for the api calls

import '../navigation_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../Components/save_file.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
//all above packages are for the audio recording
import 'package:shared_preferences/shared_preferences.dart'; //for high score storage

class EvalScreen extends StatefulWidget {
  const EvalScreen({Key? key}) : super(key: key);

  @override
  State<EvalScreen> createState() => _EvalScreenState();
}

class _EvalScreenState extends State<EvalScreen> {
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => WordEvaluationPage()),
                      );
                    },
                    style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all<Color>(Colors.transparent), //splashColor
                      backgroundColor: MaterialStateProperty.all<Color>(Color(0xFFFFC800)),
                      elevation: MaterialStateProperty.all<double>(0),
                    ),
                    child: const Text("Click me to do a word evaluation!")
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SentenceEvaluationPage()),
                      );
                    },
                    style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all<Color>(Colors.transparent), //splashColor
                      backgroundColor: MaterialStateProperty.all<Color>(Color(0xFFFFC800)),
                      elevation: MaterialStateProperty.all<double>(0),
                    ),
                    child: const Text("Click me to do a sentence evaluation!")
                  )
                ],
            )
        )
    );
  }
}
class SentenceEvaluationPage extends StatelessWidget {
  const SentenceEvaluationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sentence Evaluation'),
      ),
      body: const Center(
        child: Text('Sentence Evaluation Page'),
      ),
    );
  }
}

class WordEvaluationPage extends StatefulWidget {
  const WordEvaluationPage({Key? key}) : super(key: key);

  @override
  _WordEvaluationPageState createState() => _WordEvaluationPageState();
}

class _WordEvaluationPageState extends State<WordEvaluationPage> {
  FlutterSoundRecorder? _recorder = FlutterSoundRecorder();
  bool _isRecording = false;
  late String _recordedFilePath;
  late String _currentWord;
  TextEditingController resultController = new TextEditingController();

  final String appKey = app; //from keys.dart (untracked, holds appKey and secretKey)
  final String secretKey = secret;
  final String userId = "rsarikonda";
  final String baseHOST = "api.speechsuper.com";

  final String wordCore = "word.eval.promax"; // Change the coreType according to your needs.
  final String sentCore = "sent.eval.promax";
  final audioType = "mp3"; // Change the audio type corresponding to the audio file.
  final audioSampleRate = "16000";

  //SCORE STORAGE AND RETRIEVAL

  Future<void> storeValue(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  Future<String?> retrieveValue(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  //REQUEST PERMISSIONS

  Future<void> requestMicrophonePermission() async {
    final microphoneStatus = await Permission.microphone.status;
    if (!(microphoneStatus.isGranted)) {
      await Permission.microphone.request();
    }
    print("MICROPHONE:" + microphoneStatus.toString());
  }

  Future<void> requestStoragePermissions() async {
    final storageStatus = await Permission.storage.status;
    if (!(storageStatus.isGranted)) {
      await Permission.storage.request();
    }

    print("STORAGE:" + storageStatus.toString());
  }

  Future<void> requestAudioPermissions() async {
    final audioStatus = await Permission.audio.status;
    if (!(audioStatus.isGranted)) {
      await Permission.audio.request();
    }

    print("AUDIO: " + audioStatus.toString());
  }

  Future<void> requestAllPermissions() async {
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
  Future<String?> getSavePath() async {
  Directory? directory = await getApplicationDocumentsDirectory();
  print("INITIAL DIRECTORY: " + directory.path);
  if (directory != null) {
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
  } else {
    print("Error: Documents directory not available.");
    return null;
  }
  }

  @override
  void initState() {
    super.initState();
    requestAllPermissions();
    _loadRandomWord().then((word) {
      setState(() {
        _currentWord = word;
      });
    });
    _recorder!.openRecorder().then((value) => setState(() {}));
  }

  @override
  void dispose() {
    _recorder!.closeRecorder();
    _recorder = null;
    super.dispose();
  }

  Future<void> _startRecording() async {
  String filePath = await getSavePath() ?? 'placeholder';
  if (filePath.isEmpty) {
    print("Error: No path retrieved from getSavePath");
    return;
  }
  print("CURRENT FILE PATH:" + filePath);
  setState(() { 
    _isRecording = true;
    _recordedFilePath = filePath;  // Set path directly
  });
  print("RECORDED FILE PATH: $_recordedFilePath");
  
  try {
    await _recorder!.startRecorder(toFile: filePath);
  } catch (e) {
    print("Error starting recorder: $e");
  }
}

  Future<void> _stopRecording() async {
    setState(() {
      _isRecording = false;
    });

    try {
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

  //WORD FOR AUDIO
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

  void doWordEval() async {
    
    String timestamp =  DateTime.now().millisecondsSinceEpoch.toString();
    String connectSig = sha1.convert(utf8.encode("$appKey$timestamp$secretKey")).toString();
    String startSig = sha1.convert(utf8.encode("$appKey$timestamp$userId$secretKey")).toString();
    String tokenId = DateTime.now().millisecondsSinceEpoch.toString();
    var params = {
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
    if (!await file.exists()) {
      print("ERROR: THE FILE DOES NOT EXIST AT: $_recordedFilePath");
      return;
    }

    //read the file's bytes
    final bytes = await file.readAsBytes();

    //use bytes directly in the request

    
    var url = Uri.https(baseHOST, wordCore);
    var request = http.MultipartRequest("POST", url)
    ..fields["text"] = jsonEncode(params)
    ..files.add(http.MultipartFile.fromBytes("audio", bytes))
    ..headers["Request-Index"] = "0";

      var response = await request.send();
      if(response.statusCode != 200) {
        resultController.text = "HTTP status code ${response.statusCode}";
      } else {
         response.stream.transform(utf8.decoder).join().then((String str) {
           if(str.contains("error")) {
             resultController.text = str;
           } else {
             var respJson = jsonDecode(str);
             resultController.text = "overall: ${respJson["result"]["overall"]}";
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
  body: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Column(
        children: <Widget>[
          const Text('The word you need to say is:'),
          Text(
            '$_currentWord',
            style: TextStyle(
              fontSize: 30.0, // This makes the text bigger
              fontWeight: FontWeight.bold, // This makes the text bold
            ),
            textAlign: TextAlign.center, // This centers the text
          ),
        ],
      ),
      TextField(
        keyboardType: TextInputType.multiline,
        maxLength: null,
        minLines: 6,
        maxLines: 22,
        readOnly: true,
        controller: resultController,
        decoration: const InputDecoration(hintText: "Result:", contentPadding: const EdgeInsets.symmetric(vertical: 20.0),),
        style: const TextStyle(
          fontSize: 50.0, // text size
          fontWeight: FontWeight.bold, // bold text
          color: Color(0xFF8eb8e5), // custom color
        ),
        textAlign: TextAlign.center, //center the result
      ),
      ElevatedButton(
        onPressed: doWordEval,
        child: const Text('Press After Recording'),
        ),
    ],
  ),
  floatingActionButton: FloatingActionButton(
    onPressed: _isRecording ? _stopRecording : _startRecording,
    backgroundColor: Colors.blue,
    child: Icon(_isRecording ? Icons.stop : Icons.mic),
  ),
);
  }
}