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
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EvalScreen extends StatefulWidget {
  const EvalScreen({Key? key}) : super(key: key);

  @override
  State<EvalScreen> createState() => _EvalScreenState();
}

class _EvalScreenState extends State<EvalScreen> {
  final String appKey = app; //from keys.dart (untracked, holds appKey and secretKey)
  final String secretKey = secret;
  final String userId = "rsarikonda";
  final String baseHOST = "api.speechsuper.com";

  final String wordCore = "word.eval.promax"; // Change the coreType according to your needs.
  final String sentCore = "sent.eval.promax";
  final refText = "supermarket"; // Change the reference text according to your needs.
  final audioPath = "../assets/supermarket.wav"; // Change the audio path corresponding to the reference text.
  final audioType = "wav"; // Change the audio type corresponding to the audio file.
  final audioSampleRate = "16000";

  FlutterSoundRecorder? _recorder = FlutterSoundRecorder();
  bool _isRecording = false;
  late String _recordedFilePath;
  String _selectedOption = ''; // State variable to track the selected option

  TextEditingController resultController = new TextEditingController();

  Future<void> storeValue(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  Future<String?> retrieveValue(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  Future<void> requestMicrophonePermission() async {
    final microphoneStatus = await Permission.microphone.status;
    if (!(microphoneStatus.isGranted)) {
      await Permission.microphone.request();
    }
  }

  Future<String?> getSavePath() async {
    Directory? directory = Directory('/storage/emulated/0/Download');
    if (!(await directory.exists())) {
      directory =
          await getDownloadsDirectory(); // Handle case where external storage unavailable
    }

    final filename = await showDialog(
      context: NavigationService
          .navigatorKey.currentContext!, // Replace with your navigator key
      builder: (context) => const SaveFileDialog(),
    );
    String? finalPath =
        filename != null ? '${directory!.path}/$filename.mp4' : null;
    print(finalPath);
    return finalPath;
  }

  @override
  void initState() {
    super.initState();
    requestMicrophonePermission();
    _recorder!.openRecorder().then((value) => setState(() {}));
  }

  @override
  void dispose() {
    _recorder!.closeRecorder();
    _recorder = null;
    super.dispose();
  }

  Future<void> _startRecording() async {
    _recordedFilePath = await getSavePath() ?? '';
    print(_recordedFilePath);
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

  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    keyboardType: TextInputType.multiline,
                    maxLength: null,
                    minLines: 6,
                    maxLines: 22,
                    readOnly: true,
                    controller: resultController,
                    decoration: const InputDecoration(hintText: "Result:", contentPadding: const EdgeInsets.symmetric(vertical: 20.0),),
                  ),
                   const SizedBox(height: 30.0,),
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
            "refText": refText,
            "tokenId": tokenId
          }
        }
      }
    };

    rootBundle.load(audioPath).then((ByteData data) async {
      var url = Uri.https(baseHOST, wordCore);
      var request = http.MultipartRequest("POST", url)
        ..fields["text"] = jsonEncode(params)
        ..files.add(http.MultipartFile.fromBytes("audio", data.buffer.asUint8List()))
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
    });


  }

  void doSentEval() {
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
            "refText": refText,
            "tokenId": tokenId
          }
        }
      }
    };

    rootBundle.load(audioPath).then((ByteData data) async {
      var url = Uri.https(baseHOST, sentCore);
      var request = http.MultipartRequest("POST", url)
        ..fields["text"] = jsonEncode(params)
        ..files.add(http.MultipartFile.fromBytes("audio", data.buffer.asUint8List()))
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
    });
  }
}

class WordEvaluationPage extends StatelessWidget {
  Future<String> _loadRandomWord() async {
    String jsonString = await rootBundle.loadString('../assets/common.json');
    Map map = jsonDecode(jsonString);
    List<String> words = map["commonWords"].cast<String>();
    
    return words[Random().nextInt(words.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Word Evaluation'),
      ),
      body: FutureBuilder<String>(
        future: _loadRandomWord(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: Text('Loading...'));
          } else {
            if (snapshot.hasError)
              return Center(child: Text('Error: ${snapshot.error}'));
            else
              return Center(child: Text('The word you need to say is: ${snapshot.data}'));
          }
        },
      ),
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