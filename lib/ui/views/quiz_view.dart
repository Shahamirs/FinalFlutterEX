import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../view_models/quiz_view_model.dart';
import 'result_view.dart';
import '../theme/app_theme.dart';

class QuizView extends StatelessWidget {
  const QuizView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Quiz'),
      ),
      body: Consumer<QuizViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.state == QuizState.finished) {
            // Wait until build completes to navigate
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const ResultView()),
              );
            });
            return const SizedBox();
          }

          if (viewModel.state == QuizState.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.state == QuizState.error) {
            return Center(
              child: Text(
                viewModel.errorMessage ?? 'Ошибка загрузки',
                style: const TextStyle(color: AppTheme.wrongColor),
              ),
            );
          }

          final question = viewModel.currentQuestion;
          final isAnswered = viewModel.selectedIndex != null;

          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Progress
                Text(
                  'Вопрос ${viewModel.currentIndex + 1} из ${viewModel.totalQuestions}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: (viewModel.currentIndex + 1) / viewModel.totalQuestions,
                  backgroundColor: AppTheme.surfaceColor,
                  color: AppTheme.primaryColor,
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(4),
                ),
                const SizedBox(height: 32),
                
                // Topic Chip
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.secondaryColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.secondaryColor.withOpacity(0.5)),
                    ),
                    child: Text(
                      question.topic,
                      style: TextStyle(
                        color: AppTheme.secondaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Question Text
                Text(
                  question.text,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 32),

                // Options
                Expanded(
                  child: ListView.builder(
                    itemCount: question.options.length,
                    itemBuilder: (context, index) {
                      bool isSelected = viewModel.selectedIndex == index;
                      bool isCorrect = index == question.correctIndex;
                      
                      Color cardColor = AppTheme.surfaceColor;
                      Color borderColor = Colors.transparent;

                      if (isAnswered) {
                        if (isCorrect) {
                          cardColor = AppTheme.correctColor.withOpacity(0.2);
                          borderColor = AppTheme.correctColor;
                        } else if (isSelected && !isCorrect) {
                          cardColor = AppTheme.wrongColor.withOpacity(0.2);
                          borderColor = AppTheme.wrongColor;
                        }
                      } else if (isSelected) {
                        borderColor = AppTheme.primaryColor;
                      }

                      return GestureDetector(
                        onTap: () {
                          if (!isAnswered) {
                            viewModel.selectAnswer(index);
                          }
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: borderColor, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  question.options[index],
                                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: (isAnswered && isCorrect) 
                                        ? AppTheme.correctColor 
                                        : AppTheme.textPrimaryColor,
                                  ),
                                ),
                              ),
                              if (isAnswered && isCorrect)
                                const Icon(Icons.check_circle, color: AppTheme.correctColor),
                              if (isAnswered && isSelected && !isCorrect)
                                const Icon(Icons.cancel, color: AppTheme.wrongColor),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Next Button
                if (isAnswered)
                  FadeTransition(
                    opacity: const AlwaysStoppedAnimation(1.0),
                    child: ElevatedButton(
                      onPressed: () {
                        viewModel.proceedToNext();
                      },
                      child: Text(
                        viewModel.currentIndex == viewModel.totalQuestions - 1
                            ? 'Завершить тест'
                            : 'Следующий вопрос',
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
