// To parse this JSON data, do
//
//     final subject = subjectFromMap(jsonString);

import 'dart:convert';

import 'question.dart';

class Subject {
  Subject({
    required this.name,
    required this.easy,
    required this.medium,
    required this.hard,
  });

  final String name;
  final List<Question> easy;
  final List<Question> medium;
  final List<Question> hard;

  Subject copyWith({
    required String name,
    required List<Question> easy,
    required List<Question> medium,
    required List<Question> hard,
  }) =>
      Subject(
        name: name,
        easy: easy,
        medium: medium,
        hard: hard,
      );

  factory Subject.fromJson(String str) => Subject.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Subject.fromMap(Map<String, dynamic> json) => Subject(
        name: json["name"],
        easy: List<Question>.from(
          json["easy"].map(
            (x) => Question.fromMap(x),
          ),
        ),
        medium: List<Question>.from(
          json["medium"].map(
            (x) => Question.fromMap(x),
          ),
        ),
        hard: List<Question>.from(
          json["hard"].map(
            (x) => Question.fromMap(x),
          ),
        ),
      );

  Map<String, dynamic> toMap() => {
        "name": name,
        "easy": List<dynamic>.from(
          easy.map(
            (x) => x.toMap(),
          ),
        ),
        "medium": List<dynamic>.from(
          medium.map(
            (x) => x.toMap(),
          ),
        ),
        "hard": List<dynamic>.from(
          hard.map(
            (x) => x.toMap(),
          ),
        ),
      };
}
