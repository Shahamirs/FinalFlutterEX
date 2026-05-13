import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  static AnalyticsService? _instance;
  AnalyticsService._();
  static AnalyticsService get instance => _instance ??= AnalyticsService._();

  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  FirebaseAnalyticsObserver get observer =>
      FirebaseAnalyticsObserver(analytics: _analytics);

  /// Вызывается при старте теста
  Future<void> logQuizStarted({String? topic}) async {
    await _analytics.logEvent(
      name: 'quiz_started',
      parameters: topic != null ? {'topic': topic} : null,
    );
  }

  /// Вызывается при ответе на каждый вопрос
  Future<void> logQuestionAnswered({
    required int questionIndex,
    required bool isCorrect,
    required String topic,
  }) async {
    await _analytics.logEvent(
      name: 'question_answered',
      parameters: {
        'question_index': questionIndex,
        'is_correct': isCorrect ? 1 : 0,
        'topic': topic,
      },
    );
  }

  /// Вызывается при завершении теста
  Future<void> logQuizFinished({
    required int correctAnswers,
    required int totalQuestions,
  }) async {
    final percentage = (correctAnswers / totalQuestions * 100).round();
    await _analytics.logEvent(
      name: 'quiz_finished',
      parameters: {
        'correct_answers': correctAnswers,
        'total_questions': totalQuestions,
        'percentage': percentage,
      },
    );
  }
}
