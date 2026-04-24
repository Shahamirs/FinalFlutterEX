class QuizResult {
  final int totalQuestions;
  final int correctAnswers;

  QuizResult({
    required this.totalQuestions,
    required this.correctAnswers,
  });

  double get percentage => (correctAnswers / totalQuestions) * 100;

  String get interpretation {
    if (percentage >= 90) {
      return "Отлично! Вы превосходно знаете Flutter.";
    } else if (percentage >= 70) {
      return "Хорошо! Но есть куда расти.";
    } else if (percentage >= 50) {
      return "Удовлетворительно. Нужно подтянуть знания.";
    } else {
      return "Плохо. Рекомендуется повторить основы.";
    }
  }
}
