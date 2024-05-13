import 'package:mongo_dart/mongo_dart.dart';

class Answer {
  late String answer;
  late String correct;
  Answer({required this.answer, required this.correct});

  Answer.fromMap(Map<String, dynamic> map) {
    answer = map['answer'];
    correct = map['correct'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['answer'] = answer;
    data['correct'] = correct;
    return data;
  }
}

class Question {
  late ObjectId id;
  late String question;
  late List<Answer> answers;

  Question({required this.id, required this.question, required this.answers});

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['question'] = question;
    data['answers'] = answers.map((v) => v.answer).toList();
    return data;
  }

  Question.fromMap(Map<String, dynamic> map, String string) {
    id = map['_id'];
    question = map['question'];
    answers = <Answer>[];
    map['answers'].forEach((v) {
      answers.add(Answer.fromMap(v));
    });
  }
}
