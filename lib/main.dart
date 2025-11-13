// lib/main.dart

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart';
import 'package:habitflow/src/features/auth/presentation/auth_wrapper.dart';
import 'package:habitflow/src/features/habits/domain/habit_log_model.dart';
import 'package:habitflow/src/features/habits/domain/habit_model.dart';
import 'package:habitflow/src/shared/services/notification_service.dart';

class HabitFlowTheme {
  static const Color primaryColor = Color(0xFF6A11CB);
  static const Color secondaryColor = Color(0xFF2575FC);
  static const Color darkBg = Color(0xFF0F0C29);
  static const Color darkSurface = Color(0xFF1C1A3A);
  static const Color kWhite = Colors.white;
  static const Color kWhite70 = Colors.white70;

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: darkBg,
    primaryColor: primaryColor,
    colorScheme: const ColorScheme.dark(
      primary: primaryColor,
      secondary: secondaryColor,
      surface: darkSurface,
      // FIX: Removed deprecated 'background'
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: darkBg, 
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
          fontSize: 20, fontWeight: FontWeight.bold, color: kWhite),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: darkSurface,
      selectedItemColor: primaryColor,
      unselectedItemColor: kWhite70,
      type: BottomNavigationBarType.fixed,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      labelStyle: TextStyle(color: kWhite70),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Color.fromRGBO(255, 255, 255, 0.502)),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: kWhite, width: 2),
      ),
      errorBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.redAccent, width: 2),
      ),
      focusedErrorBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.redAccent, width: 2),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: kWhite,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: kWhite70,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
      foregroundColor: kWhite,
    ),
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Hive.initFlutter();
  Hive.registerAdapter(HabitAdapter());
  Hive.registerAdapter(HabitLogAdapter());
  final notificationService = NotificationService();
  await notificationService.init();
  await notificationService.requestPermissions();
  runApp(
    ProviderScope(
      overrides: [
        notificationServiceProvider.overrideWithValue(notificationService),
      ],
      child: const HabitFlowApp(),
    ),
  );
}

class HabitFlowApp extends StatelessWidget {
  const HabitFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Habit Flow',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      theme: HabitFlowTheme.darkTheme,
      darkTheme: HabitFlowTheme.darkTheme,
      home: const AuthWrapper(),
    );
  }
}