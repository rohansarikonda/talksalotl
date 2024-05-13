//fitb stands for fill in the blank

import 'package:flutter/material.dart';
import '../constants.dart';
import '../database/database.dart';
import '../model/question.dart';
import 'congrats.dart';

class FITB extends StatefulWidget {
  const FITB({super.key});

  @override
  FITBState createState() => FITBState();
}

class FITBState extends State<FITB> {
  String _selectedOption = ''; // State variable to track the selected option
  List<Question> questions = [];
  Question? _currentQuestion;
  int _currentPageIndex = 0;
  // final int _maxQuestionsPerSession = 10;

  late PageController _controller;
  static const _kDuration = Duration(milliseconds: 300);
  static const _kCurve = Curves.ease;

  @override
  void initState() {
    super.initState();
    _getQuestions();
    _controller = PageController();
  }

  Future<void> _getQuestions() async {
    final List<Map<String, dynamic>> data = await MongoDatabase.getDocuments();

    setState(() {
      questions = data
          .map((qData) => Question.fromMap(qData, qData['question'].toString()))
          .toList();
      questions.shuffle();
    });
  }

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
            padding: const EdgeInsets.all(AppConstants.mainCompEdgeInsets),
            child: PageView.builder(
              controller: _controller,
              itemCount: questions
                  .length, // _maxQuestionsPerSession, // questions.length,
              itemBuilder: (context, index) {
                // _currentPageIndex = index;
                // log(_currentPageIndex);
                _currentQuestion = questions[index];
                return _buildQuestionAndAnswers(_currentQuestion!);
              },
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FloatingActionButton(
          onPressed: () {
            if (_currentPageIndex >= questions.length) {
              // _maxQuestionsPerSession) {
              // questions.length) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Congrats()),
              );
            } else {
              _controller.nextPage(duration: _kDuration, curve: _kCurve);
              _currentPageIndex++;
            }
          },
          child: const Icon(Icons.navigate_next),
        ),
      ),
    );
  }

  Widget _buildQuestionAndAnswers(Question question) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.questionPaddingEdgeInsets),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              question.question,
              style: const TextStyle(
                  fontSize: AppConstants.questionFontSize,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
                height: AppConstants.questionsSizedBoxHeight), // Add space here
            Wrap(
              spacing: AppConstants.wrapSpacing,
              runSpacing: AppConstants.wrapRunSpacing,
              children: _buildAnswerOptions(question),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildAnswerOptions(Question question) {
    List<Widget> answerOptions = <Widget>[];
    for (int i = 0; i < question.answers.length; i++) {
      var answer = question.answers[i];
      answerOptions.add(GestureDetector(
        onTap: () {
          setState(() {
            _selectedOption = answer.answer; // Update the selected option
          });
          if (answer.correct == 'true') {
            _controller.nextPage(duration: _kDuration, curve: _kCurve);
          }
        },
        child: Container(
          padding: const EdgeInsets.all(AppConstants.answerEdgeInsets),
          decoration: BoxDecoration(
            color: _selectedOption == answer.answer
                ? answer.correct == 'true'
                    ? AppConstants.correctAnswerColor
                    : AppConstants.incorrectAnswerColor
                : AppConstants
                    .defaultAnswerColor, // Change color based on selection
            borderRadius:
                BorderRadius.circular(AppConstants.answerBoxBorderRadius),
          ),
          child: Text(
            answer.answer,
            style: const TextStyle(
                fontSize:
                    AppConstants.answerFontSize), // Change the font size here
          ),
        ),
      ));
    }

    return answerOptions;
  }
}

class Style {
  const Style();
}
