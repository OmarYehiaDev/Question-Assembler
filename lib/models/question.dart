import 'dart:convert';

import 'option.dart';

class Question {
  Question({
    required this.questionId,
    required this.options,
    required this.questionPhrase,
  });

  final String questionId;
  final List<Option> options;
  final String questionPhrase;

  Question copyWith({
    required String questionId,
    required List<Option> options,
    required String questionPhrase,
  }) =>
      Question(
        questionId: questionId,
        options: options,
        questionPhrase: questionPhrase,
      );

  factory Question.fromJson(String str) => Question.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Question.fromMap(Map<String, dynamic> json) => Question(
        questionId: json["question_id"],
        options: List<Option>.from(
          json["options"].map(
            (x) => Option.fromMap(x),
          ),
        ),
        questionPhrase: json["question_phrase"],
      );

  Map<String, dynamic> toMap() => {
        "question_id": questionId,
        "options": List<dynamic>.from(
          options.map(
            (x) => x.toMap(),
          ),
        ),
        "question_phrase": questionPhrase,
      };
}

List<Question> decodeQuestionsFromJson(String str) => List<Question>.from(
      json.decode(str).map(
            (item) => Question.fromJson(
              item,
            ),
          ),
    );
