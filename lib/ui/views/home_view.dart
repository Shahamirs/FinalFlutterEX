import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../view_models/quiz_view_model.dart';
import 'quiz_view.dart';
import '../theme/app_theme.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F172A), Color(0xFF1E1B4B)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo/Icon area
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.surfaceColor,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryColor.withOpacity(0.3),
                      blurRadius: 30,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.flutter_dash,
                  size: 80,
                  color: AppTheme.secondaryColor,
                ),
              ),
              const SizedBox(height: 48),
              Text(
                'Flutter Quiz',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Text(
                  'Проверьте свои знания Dart, виджетов и архитектуры Flutter',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              const SizedBox(height: 64),
              ElevatedButton(
                onPressed: () {
                  context.read<QuizViewModel>().startQuiz();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const QuizView()),
                  );
                },
                child: const Text('Начать тест'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
