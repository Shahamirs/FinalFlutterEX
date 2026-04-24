import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../view_models/quiz_view_model.dart';
import 'home_view.dart';
import '../theme/app_theme.dart';

class ResultView extends StatelessWidget {
  const ResultView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Результат теста'),
        automaticallyImplyLeading: false, // Hide back button
      ),
      body: Consumer<QuizViewModel>(
        builder: (context, viewModel, child) {
          final result = viewModel.result;
          
          if (result == null) {
            return const Center(child: Text('Нет доступных результатов.'));
          }

          // Determine color based on percentage
          Color resultColor;
          if (result.percentage >= 70) {
            resultColor = AppTheme.correctColor;
          } else if (result.percentage >= 50) {
            resultColor = Colors.orange;
          } else {
            resultColor = AppTheme.wrongColor;
          }

          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.surfaceColor,
                      border: Border.all(
                        color: resultColor,
                        width: 8,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: resultColor.withOpacity(0.3),
                          blurRadius: 30,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${result.percentage.toInt()}%',
                            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                              fontSize: 48,
                              color: resultColor,
                            ),
                          ),
                          Text(
                            'Правильно',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 48),
                  Text(
                    '${result.correctAnswers} из ${result.totalQuestions} ответов',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    result.interpretation,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                  const SizedBox(height: 64),
                  ElevatedButton.icon(
                    onPressed: () {
                      viewModel.retryQuiz();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const HomeView()), // Go to home first
                      );
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Пройти ещё раз'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: () {
                      viewModel.restartLoading();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const HomeView()),
                      );
                    },
                    icon: const Icon(Icons.home),
                    label: const Text('На главную'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.textPrimaryColor,
                      side: const BorderSide(color: AppTheme.textSecondaryColor),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
