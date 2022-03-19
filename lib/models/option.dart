import 'dart:convert';

class Option {
  Option({
    required this.answer,
    required this.validity,
  });

  final String answer;
  final bool validity;

  Option copyWith({
    required String answer,
    required bool validity,
  }) =>
      Option(
        answer: answer,
        validity: validity,
      );

  factory Option.fromJson(String str) => Option.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Option.fromMap(Map<String, dynamic> json) => Option(
        answer: json["answer"],
        validity: json["validity"],
      );

  Map<String, dynamic> toMap() => {
        "answer": answer,
        "validity": validity,
      };
}
