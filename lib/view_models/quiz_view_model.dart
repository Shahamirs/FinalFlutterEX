import 'package:flutter/material.dart';
import '../models/question.dart';
import '../models/quiz_result.dart';
import '../services/quiz_service.dart';

enum QuizState { loading, ready, error, inProgress, finished }

class QuizViewModel extends ChangeNotifier {
  final QuizService _quizService = QuizService();

  QuizState _state = QuizState.loading;
  QuizState get state => _state;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<Question> _questions = [];
  int _currentIndex = 0;
  int _correctAnswers = 0;

  Question get currentQuestion => _questions[_currentIndex];
  int get currentIndex => _currentIndex;
  int get totalQuestions => _questions.length;
  
  // Track selected index before proceeding
  int? _selectedIndex;
  int? get selectedIndex => _selectedIndex;

  QuizResult? _result;
  QuizResult? get result => _result;

  QuizViewModel() {
    _init();
  }

  Future<void> _init() async {
    try {
      _state = QuizState.loading;
      notifyListeners();

      _questions = await _quizService.loadQuestions();
      _questions.shuffle(); // Optional: shuffle questions
      
      _state = QuizState.ready;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _state = QuizState.error;
      notifyListeners();
    }
  }

  void startQuiz() {
    _currentIndex = 0;
    _correctAnswers = 0;
    _selectedIndex = null;
    _result = null;
    _state = QuizState.inProgress;
    notifyListeners();
  }

  void selectAnswer(int index) {
    if (_selectedIndex != null) return; // Prevent changing answer repeatedly

    _selectedIndex = index;
    notifyListeners();
  }

  void proceedToNext() {
    if (_selectedIndex == null) return;

    if (_selectedIndex == currentQuestion.correctIndex) {
      _correctAnswers++;
    }

    if (_currentIndex < _questions.length - 1) {
      _currentIndex++;
      _selectedIndex = null;
    } else {
      _finishQuiz();
    }
    notifyListeners();
  }

  void _finishQuiz() {
    _result = QuizResult(
      totalQuestions: _questions.length,
      correctAnswers: _correctAnswers,
    );
    _state = QuizState.finished;
  }

  void retryQuiz() {
    // Optionally reshuffle here
    _questions.shuffle();
    startQuiz();
  }
  
  void restartLoading() {
      _init();
  }
}
