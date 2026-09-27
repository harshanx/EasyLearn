import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:learning_difficulty_screening/providers/settings_provider.dart';

void main() {
  // Required to mock platform channels like SharedPreferences in tests
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SettingsNotifier Tests', () {
    late SharedPreferences prefs;

    setUp(() async {
      SharedPreferences.setMockInitialValues({
        'theme_mode': 'dark',
        'language_code': 'ml',
        'text_size_multiplier': 1.2,
        'high_contrast': true,
        'reduce_motion': true,
      });
      prefs = await SharedPreferences.getInstance();
    });

    test('initializes state correctly from SharedPreferences', () {
      final notifier = SettingsNotifier(prefs);
      
      expect(notifier.state.themeMode, ThemeMode.dark);
      expect(notifier.state.locale.languageCode, 'ml');
      expect(notifier.state.textSizeMultiplier, 1.2);
      expect(notifier.state.highContrast, true);
      expect(notifier.state.reduceMotion, true);
    });

    test('modifies settings correctly and persists them', () async {
      final notifier = SettingsNotifier(prefs);

      // Verify theme change
      await notifier.setThemeMode(ThemeMode.light);
      expect(notifier.state.themeMode, ThemeMode.light);
      expect(prefs.getString('theme_mode'), 'light');

      // Verify locale change
      await notifier.setLocale(const Locale('hi'));
      expect(notifier.state.locale.languageCode, 'hi');
      expect(prefs.getString('language_code'), 'hi');

      // Verify high contrast change
      await notifier.setHighContrast(false);
      expect(notifier.state.highContrast, false);
      expect(prefs.getBool('high_contrast'), false);
    });
  });
}
