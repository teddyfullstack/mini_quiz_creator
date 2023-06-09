class Question {
  final String id;
  final String src;
  final String type;
  final String question;
  final List<String> explanations;
  final List<String>? answers;
  final List<SubQuestion>? subQuestions;

  Question({
    required this.id,
    required this.src,
    required this.type,
    required this.question,
    required this.explanations,
    required this.answers,
    required this.subQuestions,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      src: json['src'],
      type: json['type'],
      question: json['question'],
      explanations: List<String>.from(json['explanations']),
      answers:
          json['answers'] != null ? List<String>.from(json['answers']) : null,
      subQuestions: json['subQuestions'] != null
          ? List<SubQuestion>.from(json['subQuestions']
              .map((subQuestionJson) => SubQuestion.fromJson(subQuestionJson)))
          : null,
    );
  }
}

class SubQuestion {
  final String question;
  final List<String> answers;

  SubQuestion({
    required this.question,
    required this.answers,
  });

  factory SubQuestion.fromJson(Map<String, dynamic> json) {
    return SubQuestion(
      question: json['question'],
      answers: List<String>.from(json['answers']),
    );
  }
}
