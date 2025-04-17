import 'package:flutter/material.dart';
import 'package:attendance_flutter/screens/home_screen.dart';
import 'package:attendance_flutter/screens/attendance_screen.dart';
import 'package:attendance_flutter/screens/splash_screen.dart';
import 'package:attendance_flutter/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Attendance Counter',
      theme: _isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme,
      home: const SplashScreen(),
      routes: {
        '/home': (context) => HomeScreen(
              isDarkMode: _isDarkMode,
              onThemeToggle: _toggleTheme,
            ),
        '/attendance': (context) => AttendanceScreen(
              isDarkMode: _isDarkMode,
              onThemeToggle: _toggleTheme,
            ),
      },
    );
  }
}
