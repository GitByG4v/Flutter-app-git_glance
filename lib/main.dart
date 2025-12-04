import 'package:flutter/material.dart';
import 'utils/constants.dart';
import 'screens/main_screen.dart';

void main() {
  runApp(const GitGlanceApp());
}

class GitGlanceApp extends StatelessWidget {
  const GitGlanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GitGlance',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const MainScreen(),
    );
  }
}
