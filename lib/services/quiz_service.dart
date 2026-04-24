import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/question.dart';

class QuizService {
  Future<List<Question>> loadQuestions() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/data/questions.json');
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => Question.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Не удалось загрузить вопросы: $e');
    }
  }
}
