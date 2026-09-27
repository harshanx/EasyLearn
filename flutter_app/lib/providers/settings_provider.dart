import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsState {
  final ThemeMode themeMode;
  final Locale locale;
  final double textSizeMultiplier;
  final bool highContrast;
  final bool reduceMotion;
  final String? loggedInRole; // Helper to track active login role (for demo purposes)

  SettingsState({
    required this.themeMode,
    required this.locale,
    required this.textSizeMultiplier,
    required this.highContrast,
    required this.reduceMotion,
    this.loggedInRole,
  });

  SettingsState copyWith({
    ThemeMode? themeMode,
    Locale? locale,
    double? textSizeMultiplier,
    bool? highContrast,
    bool? reduceMotion,
    String? loggedInRole,
  }) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
      textSizeMultiplier: textSizeMultiplier ?? this.textSizeMultiplier,
      highContrast: highContrast ?? this.highContrast,
      reduceMotion: reduceMotion ?? this.reduceMotion,
      loggedInRole: loggedInRole == 'none' ? null : (loggedInRole ?? this.loggedInRole),
    );
  }
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  final SharedPreferences _prefs;

  SettingsNotifier(this._prefs)
      : super(SettingsState(
          themeMode: _parseThemeMode(_prefs.getString('theme_mode') ?? 'light'),
          locale: Locale(_prefs.getString('language_code') ?? 'en'),
          textSizeMultiplier: _prefs.getDouble('text_size_multiplier') ?? 1.0,
          highContrast: _prefs.getBool('high_contrast') ?? false,
          reduceMotion: _prefs.getBool('reduce_motion') ?? false,
          loggedInRole: _prefs.getString('logged_in_role'),
        ));

  static ThemeMode _parseThemeMode(String mode) {
    switch (mode) {
      case 'dark':
        return ThemeMode.dark;
      case 'light':
        return ThemeMode.light;
      default:
        return ThemeMode.system;
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    String modeStr = 'light';
    if (mode == ThemeMode.dark) modeStr = 'dark';
    if (mode == ThemeMode.system) modeStr = 'system';
    
    await _prefs.setString('theme_mode', modeStr);
    state = state.copyWith(themeMode: mode);
  }

  Future<void> setLocale(Locale newLocale) async {
    await _prefs.setString('language_code', newLocale.languageCode);
    state = state.copyWith(locale: newLocale);
  }

  Future<void> setTextSizeMultiplier(double multiplier) async {
    await _prefs.setDouble('text_size_multiplier', multiplier);
    state = state.copyWith(textSizeMultiplier: multiplier);
  }

  Future<void> setHighContrast(bool enabled) async {
    await _prefs.setBool('high_contrast', enabled);
    state = state.copyWith(highContrast: enabled);
  }

  Future<void> setReduceMotion(bool enabled) async {
    await _prefs.setBool('reduce_motion', enabled);
    state = state.copyWith(reduceMotion: enabled);
  }

  Future<void> setLoggedInRole(String? role) async {
    if (role == null) {
      await _prefs.remove('logged_in_role');
      state = state.copyWith(loggedInRole: 'none');
    } else {
      await _prefs.setString('logged_in_role', role);
      state = state.copyWith(loggedInRole: role);
    }
  }
}

// Provider definition
final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  throw UnimplementedError('SharedPreferences must be initialized in main');
});
