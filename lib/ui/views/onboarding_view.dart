import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/prefs_service.dart';
import '../theme/app_theme.dart';
import 'home_view.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({Key? key}) : super(key: key);

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  static const _pages = [
    _OnboardingPage(
      icon: Icons.quiz_rounded,
      title: 'Flutter Quiz',
      description:
          'Проверьте свои знания Dart и Flutter!\nВопросы охватывают основы языка, виджеты, архитектуру и навигацию.',
      gradient: [Color(0xFF6B4EE6), Color(0xFF4338CA)],
    ),
    _OnboardingPage(
      icon: Icons.checklist_rounded,
      title: 'Как проходить тест',
      description:
          'Последовательно отвечайте на вопросы.\nВыберите один вариант — правильный подсветится зелёным.\nВ конце вы увидите результат и интерпретацию.',
      gradient: [Color(0xFF0EA5E9), Color(0xFF0284C7)],
    ),
    _OnboardingPage(
      icon: Icons.notifications_active_rounded,
      title: 'Напоминания',
      description:
          'Не забывайте про тест!\nУстановите таймер и приложение пришлёт push-уведомление, когда придёт время освежить знания.',
      gradient: [Color(0xFF10B981), Color(0xFF059669)],
    ),
  ];

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _finish();
    }
  }

  Future<void> _finish() async {
    await PrefsService.instance.setOnboardingDone();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomeView()),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _pages.length,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemBuilder: (ctx, i) => _buildPage(_pages[i]),
          ),
          // Skip button
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            right: 24,
            child: _currentPage < _pages.length - 1
                ? TextButton(
                    onPressed: _finish,
                    child: Text(
                      'Пропустить',
                      style: GoogleFonts.outfit(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          // Bottom controls
          Positioned(
            bottom: MediaQuery.of(context).padding.bottom + 48,
            left: 0,
            right: 0,
            child: Column(
              children: [
                // Dots indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _pages.length,
                    (i) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _currentPage == i ? 28 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _currentPage == i
                            ? Colors.white
                            : Colors.white38,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                // Next / Start button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 48),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: _pages[_currentPage].gradient.first,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        textStyle: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      onPressed: _nextPage,
                      child: Text(
                        _currentPage == _pages.length - 1
                            ? 'Начать!'
                            : 'Далее',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(_OnboardingPage page) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: page.gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            // Icon circle
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.15),
                border: Border.all(color: Colors.white24, width: 2),
              ),
              child: Icon(page.icon, size: 72, color: Colors.white),
            ),
            const SizedBox(height: 48),
            Text(
              page.title,
              style: GoogleFonts.outfit(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                page.description,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 17,
                  color: Colors.white.withOpacity(0.85),
                  height: 1.6,
                ),
              ),
            ),
            const SizedBox(height: 120), // space for bottom controls
          ],
        ),
      ),
    );
  }
}

class _OnboardingPage {
  final IconData icon;
  final String title;
  final String description;
  final List<Color> gradient;

  const _OnboardingPage({
    required this.icon,
    required this.title,
    required this.description,
    required this.gradient,
  });
}
