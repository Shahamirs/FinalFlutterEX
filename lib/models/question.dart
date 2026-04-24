class Question {
  final String text;
  final List<String> options;
  final int correctIndex;
  final String topic;

  Question({
    required this.text,
    required this.options,
    required this.correctIndex,
    required this.topic,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      text: json['text'],
      options: List<String>.from(json['options']),
      correctIndex: json['correctIndex'],
      topic: json['topic'],
    );
  }
}
