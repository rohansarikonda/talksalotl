import 'package:flutter/material.dart';

// background color for all pages to be used for simple access in the coding of app pages
class AppConstants {
  static Color backgroundColor1 = const Color.fromARGB(235, 240, 219, 239);
  static Color accentColor1 = const Color.fromARGB(255,142, 184, 229);

  // Multiple choice answers
  static const Color correctAnswerColor = Colors.green;
  static const Color incorrectAnswerColor = Colors.red;
  static const Color defaultAnswerColor = Colors.grey;
  static const double answerBoxBorderRadius = 8.0;
  static const double answerFontSize = 29.0;
  static const double questionFontSize = 40.0;
  static const double questionPaddingEdgeInsets = 8.0;
  static const double questionsSizedBoxHeight = 180.0;
  static const double wrapSpacing = 35.0;
  static const double wrapRunSpacing = 8.0;
  static const double answerEdgeInsets = 13.0;
  static const double mainCompEdgeInsets = 16.0;
  static const double nextQuestionFontSize = 12.0;

  // Font sizes

  // Mongodb collection name
  static const questionsCollection = "questions";
}
