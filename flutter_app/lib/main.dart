import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:learning_difficulty_screening/localization/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/config/app_theme.dart';
import 'providers/settings_provider.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/parent/screens/parent_dashboard.dart';
import 'features/teacher/screens/teacher_dashboard.dart';
import 'features/student/screens/student_dashboard.dart';
import 'features/admin/screens/admin_dashboard.dart';
import 'features/settings/screens/settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        settingsProvider.overrideWith((ref) => SettingsNotifier(prefs)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    // Compute appropriate home screen based on active login role (for demo purposes)
    Widget initialScreen;
    if (settings.loggedInRole == 'parent') {
      initialScreen = const ParentDashboard();
    } else if (settings.loggedInRole == 'teacher') {
      initialScreen = const TeacherDashboard();
    } else if (settings.loggedInRole == 'student') {
      initialScreen = const StudentDashboard();
    } else if (settings.loggedInRole == 'admin') {
      initialScreen = const AdminDashboard();
    } else {
      initialScreen = const LoginScreen();
    }

    return MaterialApp(
      title: 'Learning Support AI',
      debugShowCheckedModeBanner: false,

      // Theme configuration
      themeMode: settings.themeMode,
      theme: AppTheme.getLightTheme(
        highContrast: settings.highContrast,
        textScaleFactor: settings.textSizeMultiplier,
      ),
      darkTheme: AppTheme.getDarkTheme(
        highContrast: settings.highContrast,
        textScaleFactor: settings.textSizeMultiplier,
      ),

      // Localization configuration
      locale: settings.locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // English
        Locale('ml', ''), // Malayalam
        Locale('hi', ''), // Hindi
      ],

      // Navigation routing
      home: initialScreen,
      routes: {
        '/login': (context) => const LoginScreen(),
        '/parent-dashboard': (context) => const ParentDashboard(),
        '/teacher-dashboard': (context) => const TeacherDashboard(),
        '/student-dashboard': (context) => const StudentDashboard(),
        '/admin-dashboard': (context) => const AdminDashboard(),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}
