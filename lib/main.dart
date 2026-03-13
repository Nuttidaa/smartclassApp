import 'package:flutter/material.dart';

import 'screens/checkin_screen.dart';
import 'screens/finish_screen.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const SmartClassApp());
}

class SmartClassApp extends StatelessWidget {
  const SmartClassApp({super.key});

  @override
  Widget build(BuildContext context) {
    const Color pastelBlue = Color(0xFF9DD9F3);
    const Color softBlue = Color(0xFFEAF7FD);
    const Color accentBlue = Color(0xFF5BAFD7);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Class Check-in & Learning Reflection App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: pastelBlue,
          brightness: Brightness.light,
        ).copyWith(
          primary: accentBlue,
          secondary: pastelBlue,
          surface: Colors.white,
        ),
        scaffoldBackgroundColor: softBlue,
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: softBlue,
          foregroundColor: Color(0xFF274C5E),
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Color(0xFF274C5E),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: pastelBlue,
            foregroundColor: const Color(0xFF1E4253),
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: Color(0xFFD4ECF7)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: accentBlue, width: 1.5),
          ),
          labelStyle: const TextStyle(color: Color(0xFF567282)),
        ),
        sliderTheme: SliderThemeData(
          activeTrackColor: accentBlue,
          inactiveTrackColor: const Color(0xFFCFE8F4),
          thumbColor: accentBlue,
          overlayColor: accentBlue.withValues(alpha: 0.15),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Color(0xFF35586A)),
          bodyMedium: TextStyle(color: Color(0xFF4B6C7A)),
          titleLarge: TextStyle(
            color: Color(0xFF274C5E),
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/checkin': (context) => const CheckInScreen(),
        '/finish': (context) => const FinishScreen(),
      },
    );
  }
}
