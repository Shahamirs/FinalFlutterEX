import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'ui/theme/app_theme.dart';
import 'ui/views/home_view.dart';
import 'ui/views/onboarding_view.dart';
import 'view_models/quiz_view_model.dart';
import 'view_models/notification_view_model.dart';
import 'services/notification_service.dart';
import 'services/prefs_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Firebase (graceful — работает даже без реального google-services.json)
  try {
    await Firebase.initializeApp();
    debugPrint('[App] Firebase initialized successfully');
  } catch (e) {
    debugPrint('[App] Firebase init skipped: $e');
  }

  // 2. Local notifications
  try {
    await NotificationService.instance.initialize();
    debugPrint('[App] NotificationService initialized');
  } catch (e) {
    debugPrint('[App] NotificationService init error: $e');
  }

  // 3. Check onboarding flag
  bool onboardingDone = false;
  try {
    onboardingDone = await PrefsService.instance.isOnboardingDone();
  } catch (e) {
    debugPrint('[App] PrefsService error: $e');
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => QuizViewModel()),
        ChangeNotifierProvider(create: (_) => NotificationViewModel()),
      ],
      child: FlutterQuizApp(showOnboarding: !onboardingDone),
    ),
  );
}

class FlutterQuizApp extends StatelessWidget {
  final bool showOnboarding;

  const FlutterQuizApp({Key? key, required this.showOnboarding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Quiz',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: showOnboarding ? const OnboardingView() : const HomeView(),
    );
  }
}
