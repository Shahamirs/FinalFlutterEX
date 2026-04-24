import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ui/theme/app_theme.dart';
import 'ui/views/home_view.dart';
import 'view_models/quiz_view_model.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => QuizViewModel()),
      ],
      child: const FlutterQuizApp(),
    ),
  );
}

class FlutterQuizApp extends StatelessWidget {
  const FlutterQuizApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Quiz',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const HomeView(),
    );
  }
}
