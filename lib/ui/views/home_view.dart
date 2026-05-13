import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../view_models/quiz_view_model.dart';
import 'quiz_view.dart';
import 'notification_settings_view.dart';
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
            children: [
              // Top bar with notification bell
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Flutter Quiz',
                      style: GoogleFonts.outfit(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textSecondaryColor,
                      ),
                    ),
                    IconButton(
                      tooltip: 'Настроить напоминание',
                      icon: const Icon(
                        Icons.notifications_outlined,
                        color: AppTheme.textSecondaryColor,
                        size: 28,
                      ),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const NotificationSettingsView(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Main content
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo/Icon area
                    Container(
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme.surfaceColor,
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryColor.withOpacity(0.35),
                            blurRadius: 40,
                            spreadRadius: 12,
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
                      padding:
                          const EdgeInsets.symmetric(horizontal: 40.0),
                      child: Text(
                        'Проверьте свои знания Dart, виджетов и архитектуры Flutter',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    const SizedBox(height: 64),
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 48.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            context.read<QuizViewModel>().startQuiz();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const QuizView()),
                            );
                          },
                          icon: const Icon(Icons.play_arrow_rounded,
                              size: 24),
                          label: const Text('Начать тест'),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Quick reminder shortcut
                    TextButton.icon(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const NotificationSettingsView(),
                        ),
                      ),
                      icon: const Icon(Icons.alarm,
                          color: AppTheme.textSecondaryColor, size: 18),
                      label: Text(
                        'Поставить напоминание',
                        style: GoogleFonts.inter(
                          color: AppTheme.textSecondaryColor,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
